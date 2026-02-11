import Foundation
import Combine

enum Feature2ServiceError: Error, LocalizedError {
    case decodingFailed(Error)
    case encodingFailed(Error)
    case invalidIndex(Int)
    case storageFailure(Error)
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed(let error):
            return "Failed to decode info: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode info: \(error.localizedDescription)"
        case .invalidIndex(let index):
            return "Invalid index for deletion: \(index)"
        case .storageFailure(let error):
            return "Storage operation failed: \(error.localizedDescription)"
        }
    }
}

protocol Feature2Repository {
    var recordsPublisher: AnyPublisher<Result<[SettingsInfo], Feature2ServiceError>, Never> { get }
    func loadRecords() throws -> [SettingsInfo]
    func saveRecord(_ info: [SettingsInfo]) throws
}

protocol Feature2RandomCombosStoring: AnyObject {
    func loadRandomCombos() throws -> [SavedRandomCombo]
    func saveRandomCombo(_ item: SavedRandomCombo) throws
    func deleteRandomCombo(id: String) throws
}

final class KeyValueRecordsRepository2: Feature2Repository, Feature2RandomCombosStoring {
    private let storage: DefaultsStorage
    
    private let recordSubject = PassthroughSubject<Result<[SettingsInfo], Feature2ServiceError>, Never>()
    
    var recordsPublisher: AnyPublisher<Result<[SettingsInfo], Feature2ServiceError>, Never> {
        recordSubject.eraseToAnyPublisher()
    }
    
    init(storage: DefaultsStorage = DefaultsStorage()) {
        self.storage = storage
    }
    
    func loadRecords() throws -> [SettingsInfo] {
        guard let data = storage.data(forKey: .record_data_feature2) else {
            return []
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode([SettingsInfo].self, from: data)
        } catch {
            throw Feature2ServiceError.decodingFailed(error)
        }
    }
    
    func saveRecord(_ info: [SettingsInfo]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(info)
            storage.set(data, forKey: .record_data_feature2)
            recordSubject.send(.success(info))
        } catch {
            throw Feature2ServiceError.encodingFailed(error)
        }
    }

    func loadRandomCombos() throws -> [SavedRandomCombo] {
        guard let data = storage.data(forKey: .random_combos_feature2) else { return [] }
        return try JSONDecoder().decode([SavedRandomCombo].self, from: data)
    }

    func saveRandomCombo(_ item: SavedRandomCombo) throws {
        var list = (try? loadRandomCombos()) ?? []
        if let idx = list.firstIndex(where: { $0.id == item.id }) {
            list[idx] = item
        } else {
            list.append(item)
        }
        let data = try JSONEncoder().encode(list)
        storage.set(data, forKey: .random_combos_feature2)
    }

    func deleteRandomCombo(id: String) throws {
        var list = (try? loadRandomCombos()) ?? []
        list.removeAll { $0.id == id }
        let data = try JSONEncoder().encode(list)
        storage.set(data, forKey: .random_combos_feature2)
    }
}

actor Feature2Service {
    nonisolated var recordsPublisher: AnyPublisher<Result<[SettingsInfo], Feature2ServiceError>, Never> { recordsSubject.eraseToAnyPublisher() }
    nonisolated var myCombosPublisher: AnyPublisher<[SavedRandomCombo], Never> { myCombosSubject.eraseToAnyPublisher() }

    private var records: [SettingsInfo] = []
    private var cancellables = Set<AnyCancellable>()
    private let repository: Feature2Repository
    private let recordsSubject = CurrentValueSubject<Result<[SettingsInfo], Feature2ServiceError>, Never>(.success([]))
    private let myCombosSubject = CurrentValueSubject<[SavedRandomCombo], Never>([])

    init(repository: Feature2Repository = KeyValueRecordsRepository2()) {
        self.repository = repository
        Task { await setupRepositorySubscription() }
        Task { await loadRecords() }
        Task { await loadMyCombos() }
    }
    
    private func setupRepositorySubscription() {
        repository.recordsPublisher
            .sink { [weak self] info in
                Task { [weak self] in
                    await self?.updateRecordsSubject(info)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateRecordsSubject(_ result: Result<[SettingsInfo], Feature2ServiceError>) {
        recordsSubject.send(result)
        if case .success(let records) = result {
            self.records = records
        }
    }
    
    private func loadRecords() {
        do {
            let loadedInfo = try repository.loadRecords()
            self.records = loadedInfo
            recordsSubject.send(.success(records))
        } catch {
            recordsSubject.send(.failure(Feature2ServiceError.storageFailure(error)))
        }
    }
    
    /// Сохраняет запись: обновляет по id, если есть, иначе добавляет новую.
    func saveRecord(_ result: SettingsInfo) async {
        do {
            var latest = try repository.loadRecords()
            if let index = latest.firstIndex(where: { $0.id == result.id }) {
                latest[index] = result
            } else {
                latest.append(result)
            }
            try repository.saveRecord(latest)
            self.records = latest
            recordsSubject.send(.success(latest))
        } catch {
            recordsSubject.send(.failure(Feature2ServiceError.storageFailure(error)))
        }
    }

    // MARK: - Random combos (saved from random screen)

    private func loadMyCombos() {
        let list = (try? (repository as? Feature2RandomCombosStoring)?.loadRandomCombos()) ?? []
        myCombosSubject.send(list)
    }

    func loadRandomCombos() throws -> [SavedRandomCombo] {
        try (repository as? Feature2RandomCombosStoring)?.loadRandomCombos() ?? []
    }

    func saveRandomCombo(_ item: SavedRandomCombo) async throws {
        try (repository as? Feature2RandomCombosStoring)?.saveRandomCombo(item)
        loadMyCombos()
    }

    func deleteRandomCombo(id: String) async throws {
        try (repository as? Feature2RandomCombosStoring)?.deleteRandomCombo(id: id)
        loadMyCombos()
    }
}





