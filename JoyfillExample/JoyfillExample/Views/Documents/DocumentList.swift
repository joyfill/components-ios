import SwiftUI

struct DocumentList: View {
    
    @ObservedObject var documentsViewModel = DocumentsViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var search: String = ""
    @FocusState private var searchIsFocused: Bool
    
    var body: some View {
        List {
            TextField("Search templates", text: $search)
                .focused($searchIsFocused)
                .onSubmit {
                    print("Submitted \(search)")
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.top, .bottom], 10)
                
            ForEach(documentsViewModel.documents) { document in
                NavigationLink {
                    DocumentSubmissionsList(identifier: document.identifier, name: document.name)
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "doc")
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                            Text(document.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("Templates")
        .overlay {
            if documentsViewModel.documentsLoading {
                ProgressView()
            }
        }.onAppear {
            documentsViewModel.fetchDocuments()
        }
    }
}

#Preview {
    DocumentList()
}
