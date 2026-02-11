import SwiftUI

struct Feature3DetailView: View {
    
    @ObservedObject var viewModel: Feature3DetailVM
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.type.title)
                        .bold()
                        .font(.system(size: 32))
                        .foregroundStyle(Color.palette(.black900))
                    
                    Text(viewModel.type.info)
                        .foregroundStyle(Color.palette(.black900).opacity(0.5))
                        .multilineTextAlignment(.leading)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .navigationView(title: "feature3.title".localized(), showsBackButton: true)
    }
}

#Preview {
    NavigationStack {
        Feature3DetailView(viewModel: Feature3DetailVM(type: .type1))
    }
}
