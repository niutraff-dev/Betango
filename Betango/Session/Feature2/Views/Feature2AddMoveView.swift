import SwiftUI

struct Feature2AddMoveView: View {
    @ObservedObject var viewModel: Feature2AddMoveVM

    var body: some View {
        VStack(spacing: 0) {
            navBar()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(viewModel.sortedMoveNames, id: \.self) { name in
                        Button {
                            viewModel.toggle(name)
                        } label: {
                            HStack {
                                Text(name)
                                    .typography(.body.regular)
                                    .foregroundStyle(Color.palette(.black900))
                                Spacer()
                                Image(viewModel.isSelected(name) ? "circle_select" : "circle_unsel")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color.palette(.white))
                        }
                        .buttonStyle(.plain)

                        if name != viewModel.sortedMoveNames.last {
                            Color.palette(.lightGrayColor).frame(height: 1).padding(.leading, 16)
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                .background(Color.palette(.white))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.palette(.backColor))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private func navBar() -> some View {
        HStack {
            Button { viewModel.onBackTapped() } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.palette(.black900))
            }
            Spacer()
            Text("feature2.addMove.title".localized())
                .typography(.body.semibold)
                .foregroundStyle(Color.palette(.black900))
            Spacer()
            Button {
                viewModel.onNextTapped()
            } label: {
                Text("feature2.addMove.next".localized())
                    .typography(.body.semibold)
                    .foregroundStyle(Color.palette(.orangeColor))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.palette(.backColor))
    }
}
