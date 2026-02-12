import SwiftUI

struct Feature2MyComboView: View {
    @ObservedObject var viewModel: Feature2MyComboVM
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(viewModel.myCombos) { item in
                        Button {
                            viewModel.onComboTapped(item)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundStyle(Color.palette(.black900))

                                    HStack(spacing: 4) {
                                        ForEach(item.combo) { step in
                                            Text(step.name)
                                                .font(.system(size: 12))
                                                .foregroundStyle(Color.palette(.black500))
                                        }
                                    }
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.palette(.black500))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.palette(.white))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .navigationView(title: "My combos", showsBackButton: true, onBackButtonTap: viewModel.onBackTapped)
        .overlay(alignment: .bottom, content: createCombo)
    }

    @ViewBuilder
    private func createCombo() -> some View {
        Button {
            viewModel.onCreateComboTapped()
        } label: {
            HStack {
                Text("Create combo")
                    .typography(.headline.bold)
                    .foregroundStyle(Color.palette(.white))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.palette(.orangeColor))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 30)
    }
}

#Preview {
    Feature2MyComboView(viewModel: Feature2MyComboVM(service: Feature2Service()))
}
