import SwiftUI

struct Feature2DetailView: View {

    @ObservedObject var viewModel: Feature2DetailVM
    @FocusState private var isInputActive: Bool

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                contentView()
                
                generateButton()
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette(.backColor))
        .navigationView(title: "Settings".localized(), showsBackButton: true, onBackButtonTap: viewModel.onBackTapped)
        .onTapGesture { isInputActive = false }
    }

    @ViewBuilder
    private func contentView() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            nameSection()
            difficultySection()
            lengthSection()
            roleSection()
            focusSection()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 24)
    }

    @ViewBuilder
    private func nameSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("feature2.combo.name".localized())
                .typography(.title2.semibold)
                .foregroundStyle(Color.palette(.black900))
            
            TextField("", text: Binding(
                get: { viewModel.settingsinfo.name },
                set: { var c = viewModel.settingsinfo; c.name = $0; viewModel.settingsinfo = c }
            ))
            .foregroundStyle(Color.palette(.black900))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .keyboardType(.default)
            .focused($isInputActive)
            .placeholder(
                showPlaceHolder: viewModel.settingsinfo.name.isEmpty,
                placeholder: "feature2.combo.name.placeholder".localized()
            )
            .padding(.leading, 12)
            .background(Color.palette(.white))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    @ViewBuilder
    private func difficultySection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("feature2.difficulty".localized())
                .typography(.title2.semibold)
                .foregroundStyle(Color.palette(.black900))
            
            segmentedPicker(
                selection: Binding(
                    get: { viewModel.settingsinfo.difficulty },
                    set: { var c = viewModel.settingsinfo; c.difficulty = $0; viewModel.settingsinfo = c }
                ),
                cases: [Difficulty.beginner, .intermediate, .advanced],
                title: \.title
            )
        }
    }

    @ViewBuilder
    private func lengthSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("feature2.length".localized())
                .typography(.title2.semibold)
                .foregroundStyle(Color.palette(.black900))
            
            Slider(
                value: Binding(
                    get: { Double(viewModel.settingsinfo.lenght) },
                    set: { var c = viewModel.settingsinfo; c.lenght = Int($0.rounded()); viewModel.settingsinfo = c }
                ),
                in: 0...10,
                step: 1
            )
            .tint(Color.palette(.orangeColor))
            HStack {
                Text(String(format: "feature2.steps".localized(), viewModel.settingsinfo.lenght))
                    .typography(.subheadline.regular)
                    .foregroundStyle(Color.palette(.black500))
                Spacer()
                Text("feature2.steps.max".localized())
                    .typography(.subheadline.regular)
                    .foregroundStyle(Color.palette(.black500))
            }
        }
    }

    @ViewBuilder
    private func roleSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("feature2.role".localized())
                .typography(.title2.semibold)
                .foregroundStyle(Color.palette(.black900))
            
            segmentedPicker(
                selection: Binding(
                    get: { viewModel.settingsinfo.role },
                    set: { var c = viewModel.settingsinfo; c.role = $0; viewModel.settingsinfo = c }
                ),
                cases: [Role.leader, .follower, .both],
                title: \.title
            )
        }
    }

    @ViewBuilder
    private func focusSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("feature2.focus".localized())
                .typography(.title2.semibold)
                .foregroundStyle(Color.palette(.black900))
            
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Array(viewModel.settingsinfo.focus.enumerated()), id: \.element.id) { index, _ in
                    focusRow(index: index)
                }
            }
        }
    }

    private func focusRow(index: Int) -> some View {
        let focus = viewModel.settingsinfo.focus[index]
        return Button {
            var c = viewModel.settingsinfo
            guard c.focus.indices.contains(index) else { return }
            c.focus[index].isSelected.toggle()
            viewModel.settingsinfo = c
        } label: {
            HStack(spacing: 10) {
                Image(focus.isSelected ? "slect" : "unselect")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                Text(focus.name)
                    .typography(.body.regular)
                    .foregroundStyle(Color.palette(.black900))
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color.palette(.white))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func segmentedPicker<T: Hashable>(selection: Binding<T>, cases: [T], title: KeyPath<T, String>) -> some View {
        HStack(spacing: 0) {
            ForEach(cases, id: \.self) { value in
                let isSelected = selection.wrappedValue == value
                Button {
                    selection.wrappedValue = value
                } label: {
                    Text(value[keyPath: title])
                        .typography(.callout.semibold)
                        .foregroundStyle(isSelected ? Color.palette(.white) : Color.palette(.black900))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(isSelected ? Color.palette(.orangeColor) : Color.palette(.white))
                }
                .buttonStyle(.plain)
                if value != cases.last {
                    Color.palette(.lightGrayColor).frame(width: 1)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.palette(.lightGrayColor), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func generateButton() -> some View {
        let disabled = viewModel.settingsinfo.isValid
        Button {
            viewModel.saveResult()
        } label: {
            Text("feature2.generate".localized())
                .typography(.headline.semibold)
                .foregroundStyle(disabled ? Color.palette(.white).opacity(0.8) : Color.palette(.white))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(disabled ? Color.palette(.orangeColor).opacity(0.45) : Color.palette(.orangeColor))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(disabled)
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .background(Color.palette(.backColor))
    }
}

#Preview {
    NavigationStack {
        Feature2DetailView(viewModel: Feature2DetailVM(service: Feature2Service(), existingRecord: nil))
    }
}
