import SwiftUI

struct Feature2RandomView: View {
    @ObservedObject var viewModel: Feature2RandomVM
    
    @FocusState private var isInputActive: Bool

    var body: some View {
        ZStack(alignment: .top) {
            mainContent()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette(.backColor))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top, spacing: 0) { navBar() }
        .onTapGesture {
            isInputActive = false
        }
        .onAppear { viewModel.shuffle() }
        .overlay {
            if let timerVM = viewModel.timerVM {
                TimerView(viewModel: timerVM)
            }
        }
    }

    @ViewBuilder
    private func navBar() -> some View {
        HStack {
            Text("feature2.random.title".localized())
                .typography(.body.semibold)
                .foregroundStyle(Color.palette(.black900))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(Color.palette(.backColor))
        .overlay(alignment: .leading, content: {
            Button {
                if viewModel.isSaveMode {
                    viewModel.closeSaveMode()
                } else {
                    viewModel.onBackTapped()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.palette(.black900))
                    .padding(.leading)
            }
        })
    }

    @ViewBuilder
    private func mainContent() -> some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    if viewModel.isSaveMode {
                        saveModeScrollContent()
                    } else {
                        comboCard()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 16)
            }
            bottomButtons()
        }
    }

    @ViewBuilder
    private func saveModeScrollContent() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("feature2.combo.name".localized())
                .typography(.title3.semibold)
                .foregroundStyle(Color.palette(.black900))

            TextField("", text: Binding(
                get: { viewModel.saveName },
                set: { viewModel.saveName = $0 }
            ))
            .foregroundStyle(Color.palette(.black900))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .keyboardType(.default)
            .focused($isInputActive)
            .placeholder(
                showPlaceHolder: viewModel.saveName.isEmpty,
                placeholder: "feature1.name.placeholder".localized()
            )
            .padding(.leading, 10)
            .background(Color.palette(.white))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("feature2.random.comboTitle".localized())
                .typography(.title3.semibold)
                .foregroundStyle(Color.palette(.black900))

            comboCard()
        }
    }

    @ViewBuilder
    private func bottomButtons() -> some View {
        VStack(spacing: 0) {
            if viewModel.isSaveMode {
                Button {
                    viewModel.saveCombo()
                } label: {
                    Text("feature2.random.save".localized())
                        .typography(.headline.semibold)
                        .foregroundStyle(viewModel.isSaveButtonEnabled ? Color.palette(.white) : Color.palette(.white).opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(viewModel.isSaveButtonEnabled ? Color.palette(.orangeColor) : Color.palette(.orangeColor).opacity(0.45))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!viewModel.isSaveButtonEnabled)
                .buttonStyle(.plain)
            } else {
                threeButtons()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(Color.palette(.backColor))
    }

    @ViewBuilder
    private func comboCard() -> some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.currentCombo.enumerated()), id: \.element.id) { index, item in
                HStack(spacing: 12) {
                    Text("\(index + 1)")
                        .typography(.callout.semibold)
                        .foregroundStyle(Color.palette(.white))
                        .frame(width: 28, height: 28)
                        .background(Color.palette(.orangeColor))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text(item.name)
                        .typography(.body.regular)
                        .foregroundStyle(Color.palette(.black900))
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                if index < viewModel.currentCombo.count - 1 {
                    Color.palette(.lightGrayColor).frame(height: 1).padding(.horizontal, 16)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.palette(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder
    private func threeButtons() -> some View {
        VStack(spacing: 12) {
            Button {
                viewModel.openTimer()
            } label: {
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(Color.palette(.white))
                    Text("feature2.random.playTimer".localized())
                        .typography(.headline.semibold)
                        .foregroundStyle(Color.palette(.white))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.palette(.orangeColor))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)

            HStack(spacing: 12) {
                Button {
                    viewModel.shuffle()
                } label: {
                    HStack {
                        Image(systemName: "shuffle")
                        Text("feature2.random.shuffle".localized())
                            .typography(.callout.semibold)
                    }
                    .foregroundStyle(Color.palette(.black900))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.palette(.white))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.palette(.lightGrayColor), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)

                Button {
                    viewModel.openSaveMode()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("feature2.random.saveCombo".localized())
                            .typography(.callout.semibold)
                    }
                    .foregroundStyle(Color.palette(.black900))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.palette(.white))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.palette(.lightGrayColor), lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }
        }
    }

}

#Preview {
    NavigationStack {
        Feature2RandomView(viewModel: Feature2RandomVM(service: Feature2Service()))
    }
}
