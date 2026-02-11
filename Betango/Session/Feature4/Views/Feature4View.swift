import SwiftUI

struct Feature4View: View {
    @ObservedObject var viewModel: Feature4VM

    var body: some View {
        VStack {
            VStack {
                arrowView()
                
                stateLabel()
                
                tempoButtons()
                    .padding(.top)
            }
            .padding(.top, UIScreen.main.bounds.height / 7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .navigationView(title: "feature4.title".localized())
        .overlay(alignment: .bottom, content: startStopButton)
    }

    @ViewBuilder
    private func arrowView() -> some View {
        Image("arrow")
            .rotationEffect(.degrees(viewModel.arrowAngle), anchor: .bottom)
            .animation(.easeInOut(duration: 0.08), value: viewModel.arrowAngle)
    }

    @ViewBuilder
    private func stateLabel() -> some View {
        Group {
            switch viewModel.state {
            case .idle: Text("feature4.state.idle".localized())
            case .ready: Text("feature4.state.ready".localized())
            case .playing: Text("feature4.state.playing".localized())
            }
        }
        .font(.title)
        .fontWeight(.regular)
        .foregroundStyle(Color.palette(.black900))
        .padding(.top, 12)
    }

    @ViewBuilder
    private func tempoButtons() -> some View {
        HStack(spacing: 12) {
            ForEach(Feature4VM.tempos, id: \.self) { bpm in
                tempoButton(bpm: bpm)
            }
        }
        .padding(.horizontal, 24)
    }

    private func tempoButton(bpm: Int) -> some View {
        let isSelected = viewModel.selectedTempo == bpm
        return Button {
            viewModel.selectTempo(bpm)
        } label: {
            Text(String(format: "feature4.bpm".localized(), bpm))
                .typography(.callout.semibold)
                .foregroundStyle(isSelected ? Color.palette(.white) : Color.palette(.black900))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? Color.palette(.orangeColor) : Color.palette(.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.palette(.lightGrayColor), lineWidth: isSelected ? 0 : 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func startStopButton() -> some View {
        Button {
            viewModel.toggleStartStop()
        } label: {
            Group {
                if viewModel.isPlaying {
                    Text("feature4.stop".localized())
                        .foregroundStyle(Color.palette(.black900))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.palette(.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.palette(.orangeColor), lineWidth: 2)
                        )
                } else {
                    Text("feature4.start".localized())
                        .foregroundStyle(viewModel.isStartEnabled ? Color.palette(.white) : Color.palette(.white).opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            viewModel.isStartEnabled
                                ? Color.palette(.orangeColor)
                                : Color.palette(.orangeColor).opacity(0.5)
                        )
                }
            }
            .typography(.headline.semibold)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!viewModel.isStartEnabled)
        .buttonStyle(.plain)
        .padding(.horizontal, 24)
        .padding(.bottom, UIScreen.main.bounds.height / 16)
    }
}

#Preview {
    Feature4View(viewModel: Feature4VM())
}
