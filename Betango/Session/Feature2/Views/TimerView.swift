import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerVM

    var body: some View {
        Color.palette(.backColor)
            .ignoresSafeArea()
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    navBar()
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            timerCircle()
                            presetButtons()
                            manualTimeSection()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                        .padding(.bottom, 24)
                    }
                    bottomButtons()
                }
            }
    }

    @ViewBuilder
    private func navBar() -> some View {
        HStack {
            Button { viewModel.onBackTapped() } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.palette(.black900))
            }
            Spacer()
            Text("feature2.timer.title".localized())
                .typography(.body.semibold)
                .foregroundStyle(Color.palette(.black900))
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.palette(.backColor))
    }

    @ViewBuilder
    private func timerCircle() -> some View {
        ZStack {
            Circle()
                .stroke(Color.palette(.white), lineWidth: 10)
                .frame(width: 200, height: 200)
            Circle()
                .trim(from: 0, to: viewModel.timerProgress)
                .stroke(Color.palette(.orangeColor), lineWidth: 10)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
            Text(viewModel.timerFormatted(viewModel.timerRemainingSeconds))
                .typography(.largeTitle.bold)
                .foregroundStyle(Color.palette(.black900))
        }
        .frame(height: 220)
    }

    @ViewBuilder
    private func presetButtons() -> some View {
        HStack(spacing: 12) {
            ForEach(TimerVM.TimerPreset.allCases, id: \.rawValue) { preset in
                let selected = viewModel.timerPreset == preset
                Button {
                    viewModel.selectTimerPreset(preset)
                } label: {
                    Text(preset.title)
                        .typography(.callout.semibold)
                        .foregroundStyle(selected ? Color.palette(.white) : Color.palette(.black900))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(selected ? Color.palette(.orangeColor) : Color.palette(.white))
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private func manualTimeSection() -> some View {
        HStack(spacing: 16) {
            Button { viewModel.timerMinus() } label: {
                Image(systemName: "minus")
                    .font(.title2.bold())
                    .foregroundStyle(Color.palette(.black900))
                    .frame(width: 52, height: 52)
                    .background(Color.palette(.white))
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            Text(viewModel.timerFormatted(viewModel.timerTotalSeconds))
                .typography(.title2.semibold)
                .foregroundStyle(Color.palette(.black900))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.palette(.white))
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button { viewModel.timerPlus() } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundStyle(Color.palette(.black900))
                    .frame(width: 52, height: 52)
                    .background(Color.palette(.white))
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private func bottomButtons() -> some View {
        HStack(spacing: 12) {
            Button {
                if viewModel.isTimerRunning {
                    viewModel.stopTimer()
                } else {
                    viewModel.startTimer()
                }
            } label: {
                Text(viewModel.isTimerRunning ? "feature2.timer.stop".localized() : "feature2.timer.start".localized())
                    .typography(.headline.semibold)
                    .foregroundStyle(Color.palette(.white))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.palette(.orangeColor))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(!viewModel.isStartEnabled && !viewModel.isTimerRunning)
            .buttonStyle(.plain)

            Button {
                viewModel.finishTimer()
            } label: {
                Text("feature2.timer.finish".localized())
                    .typography(.headline.semibold)
                    .foregroundStyle(Color.palette(.orangeColor))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.palette(.white))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.palette(.orangeColor), lineWidth: 2))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .background(Color.palette(.backColor))
    }
}
