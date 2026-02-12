import SwiftUI

struct Feature3View: View {
    
    @ObservedObject var viewModel: Feature3VM
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.allPlayers) { item in
                        SectionView(type: item) {
                            viewModel.onTapped(item)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationView(title: "feature3.title".localized(), showsBackButton: false)
        .background(Color.palette(.backColor))
    }
}

struct SectionView: View {
    
    let type: Dictionary
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(type.title)
                        .font(.headline)
                        .foregroundStyle(Color.palette(.black900))
                    
                    Text(type.subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.palette(.black900).opacity(0.5))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.gray)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(Color.palette(.white))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        Feature3View(viewModel: Feature3VM())
    }
}
