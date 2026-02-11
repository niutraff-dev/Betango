import SwiftUI

struct Feature1View: View {

    @ObservedObject var viewModel: Feature1VM

    var body: some View {
        VStack {
            headerView()
            
            if viewModel.records.isEmpty {
                Text("feature1.empty".localized())
                    .font(.headline)
                    .foregroundStyle(Color.palette(.black300))
                    .padding(.top, UIScreen.main.bounds.height / 2.5)
            } else {
                contentView()
                    .padding(.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.palette(.backColor))
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Text("feature1.title".localized())
                .typography(.body.semibold)
                .foregroundStyle(Color.palette(.black900))
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .topTrailing) {
            Button {
                viewModel.onDetailTapped()
            } label: {
                Text("Add")
                    .bold()
                    .font(.body)
                    .foregroundStyle(Color.palette(.orangeColor))
                    .padding(.trailing, 16)
            }
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(viewModel.records) { record in
                    Button {
                        viewModel.onRecordTapped(record)
                    } label: {
                        HStack {
                            Image(.dance)
                            
                            VStack(alignment: .leading){
                                Text(record.name)
                                    .font(.headline)
                                    .foregroundStyle(Color.palette(.black900))
                                
                                Text("\(record.date.dateToString()), \(record.time.timeToString())")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.palette(.black400))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.palette(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        Feature1View(viewModel: Feature1VM(service: Feature1Service()))
    }
}
