import SwiftUI

struct Feature2MyComboDetailView: View {
    @ObservedObject var viewModel: Feature2MyComboDetailVM
    
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
        .alert("feature2.myCombos.deleteAlert.title".localized(), isPresented: $viewModel.showDeleteAlert) {
            Button("common.no".localized(), role: .cancel) { viewModel.cancelDelete() }
            Button("common.yes".localized(), role: .destructive) { viewModel.confirmDelete() }
        } message: {
            Text("feature2.myCombos.deleteAlert.message".localized())
        }
        .onTapGesture {
            isInputActive = false
        }
        .overlay {
            if let timerVM = viewModel.timerVM {
                TimerView(viewModel: timerVM)
            }
        }
    }

    @ViewBuilder
    private func navBar() -> some View {
        HStack {
            Text("feature2.myCombos.title".localized())
                .typography(.body.semibold)
                .foregroundStyle(Color.palette(.black900))
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .overlay(alignment: .leading, content: {
            Button { viewModel.onBackTapped() } label: {
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
                VStack(alignment: .leading, spacing: 20) {
                    nameSection()
                    comboListSection()
                    if viewModel.isCreateMode || viewModel.isEditMode {
                        addMoveButton()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 20)
            }
            bottomSection()
        }
    }

    @ViewBuilder
    private func nameSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("feature2.combo.name".localized())
                .typography(.title3.semibold)
                .foregroundStyle(Color.palette(.black900))
            if viewModel.isCreateMode || viewModel.isEditMode {
                TextField("", text: Binding(
                    get: { viewModel.editName },
                    set: { viewModel.editName = $0 }
                ))
                .foregroundStyle(Color.palette(.black900))
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .keyboardType(.default)
                .focused($isInputActive)
                .placeholder(
                    showPlaceHolder: viewModel.editName.isEmpty,
                    placeholder: "feature1.name.placeholder".localized()
                )
                .padding(.leading, 10)
                .background(Color.palette(.white))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else if let combo = viewModel.combo {
                Text(combo.name)
                    .typography(.body.regular)
                    .foregroundStyle(Color.palette(.black900))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.palette(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    @ViewBuilder
    private func comboListSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("feature2.random.comboTitle".localized())
                .typography(.title3.semibold)
                .foregroundStyle(Color.palette(.black900))
            comboCard(steps: (viewModel.isCreateMode || viewModel.isEditMode) ? viewModel.editCombo : (viewModel.combo?.combo ?? []))
        }
    }

    @ViewBuilder
    private func comboCard(steps: [Combo]) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, item in
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
                .padding(.vertical, 16)

                if index < steps.count - 1 {
                    Color.palette(.lightGrayColor).frame(height: 1).padding(.horizontal, 16)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.palette(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder
    private func addMoveButton() -> some View {
        Button {
            viewModel.openAddMove()
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("feature2.addMove.button".localized())
                    .typography(.callout.semibold)
            }
            .foregroundStyle(Color.palette(.black900))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.gray.opacity(0.3))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.palette(.lightGrayColor), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func bottomSection() -> some View {
        VStack(spacing: 12) {
            if viewModel.isCreateMode || viewModel.isEditMode {
                Button {
                    viewModel.saveTapped()
                } label: {
                    Text("feature2.random.save".localized())
                        .typography(.headline.semibold)
                        .foregroundStyle(viewModel.isSaveEnabled ? Color.palette(.white) : Color.palette(.white).opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(viewModel.isSaveEnabled ? Color.palette(.orangeColor) : Color.palette(.orangeColor).opacity(0.45))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!viewModel.isSaveEnabled)
                .buttonStyle(.plain)
            } else {
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
                        viewModel.deleteTapped()
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("feature2.myCombos.delete".localized())
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
                        viewModel.editTapped()
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                            Text("feature2.myCombos.edit".localized())
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
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(Color.palette(.backColor))
    }
}
