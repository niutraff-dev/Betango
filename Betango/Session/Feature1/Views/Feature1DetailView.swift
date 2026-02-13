import SwiftUI

struct Feature1DetailView: View {

    @ObservedObject var viewModel: Feature1DetailVM
    
    @FocusState private var isInputActive: Bool

    var body: some View {
        VStack(spacing: 0) {
            headerView()
            contentView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            isInputActive = false
        }
    }

    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Text("feature1.title".localized())
                .typography(.body.semibold)
                .foregroundStyle(Color.palette(.black900))
        }
        .frame(maxWidth: .infinity)
        .overlay {
            HStack {
                Button {
                    viewModel.onBackTapped()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.palette(.black900))
                }

                Spacer()

                Button {
                    viewModel.saveResult()
                } label: {
                    Text("Save")
                        .bold()
                        .font(.body)
                        .foregroundStyle(
                            viewModel.calendarInfo.isValid
                                ? Color.palette(.orangeColor).opacity(0.5)
                                : Color.palette(.orangeColor)
                        )
                }
                .disabled(viewModel.calendarInfo.isValid)
            }
            .padding(.horizontal, 16)
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { viewModel.calendarInfo.date },
                            set: { var c = viewModel.calendarInfo; c.date = $0; viewModel.calendarInfo = c }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .tint(Color.palette(.orangeColor))
                    .foregroundStyle(Color.palette(.black900))
                    .colorScheme(.light)
                }
                .padding(16)
                .background(Color.palette(.white))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                HStack(spacing: 8) {
                    Text("feature1.time".localized())
                        .typography(.subheadline.medium)
                        .foregroundStyle(Color.palette(.black900))

                    Spacer()

                    DatePicker(
                        "",
                        selection: Binding(
                            get: { viewModel.calendarInfo.time },
                            set: { var c = viewModel.calendarInfo; c.time = $0; viewModel.calendarInfo = c }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(Color.palette(.orangeColor))
                    .foregroundStyle(Color.palette(.black900))
                    .colorScheme(.light)
                }
                .padding(16)
                .background(Color.palette(.white))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 8) {
                    TextField("", text: Binding(
                        get: { viewModel.calendarInfo.name },
                        set: { var c = viewModel.calendarInfo; c.name = $0; viewModel.calendarInfo = c }
                    ))
                    .foregroundStyle(Color.palette(.black900))
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .keyboardType(.default)
                    .focused($isInputActive)
                    .placeholder(
                        showPlaceHolder: viewModel.calendarInfo.name.isEmpty,
                        placeholder: "feature1.name.placeholder".localized()
                    )
                    .padding(.leading, 10)
                    .background(Color.palette(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    NavigationStack {
        Feature1DetailView(viewModel: Feature1DetailVM(service: Feature1Service(), existingRecord: nil))
    }
}
