import Foundation

enum KeyValueStorageKey: String {
    case record_data = "record_data"
    case record_data_feature2 = "record_data_feature2"
    case random_combos_feature2 = "random_combos_feature2"
}

protocol KeyValueStorable {
    func bool(forKey key: KeyValueStorageKey) -> Bool
    func string(forKey key: KeyValueStorageKey) -> String?
    func data(forKey key: KeyValueStorageKey) -> Data?
    func value<T>(forKey key: KeyValueStorageKey) -> T?
    func set(_ value: Any?, forKey key: KeyValueStorageKey)
    func remove(forKey key: KeyValueStorageKey)
}
