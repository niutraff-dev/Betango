import SwiftUI

struct Feature2View: View {

    @ObservedObject var viewModel: Feature2VM

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Button {
                    viewModel.onRandomTapped()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Generate random combo")
                                .bold()
                                .font(.title2)
                                .foregroundStyle(Color.palette(.white))
                            
                            Text("Get an instant practice sequence")
                                .foregroundStyle(Color.palette(.white))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color.palette(.orangeColor))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                }
                .buttonStyle(.plain)
                .padding(.top)
                
                if !viewModel.records.isEmpty {
                    contentView()
                        .padding(.top)
                }
                
                Button {
                    viewModel.onDetailTapped()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.palette(.black900))
                        
                        Text("Add custom")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.palette(.black900))
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .background(Color.gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                }
                .buttonStyle(.plain)
                .padding(.top)
                
                
                Button {
                    viewModel.onMyCombosTapped()
                } label: {
                    HStack {
                        Text("My combos")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.palette(.black900))
                        
                        Spacer()
                        
                        Text("\(viewModel.myCombos.count)")
                            .foregroundStyle(Color.palette(.orangeColor))
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.palette(.black300))
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                    .background(Color.palette(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(.plain)
                .padding(.top)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
        .navigationView(title: "feature2.title".localized())
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.records.enumerated()), id: \.element.id) { index, item in
                Button {
                    viewModel.onRecordTapped(item)
                } label: {
                    HStack {
                        Text(item.difficulty.title)
                            .font(.body)
                            .foregroundStyle(Color.palette(.black900))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.palette(.black300))
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)

                if index < viewModel.records.count - 1 {
                    Color.palette(.lightGrayColor).frame(height: 1).padding(.leading, 16)
                }
            }
        }
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(Color.palette(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        Feature2View(viewModel: Feature2VM(service: .init()))
    }
}
