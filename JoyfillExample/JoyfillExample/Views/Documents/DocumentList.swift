import SwiftUI

struct DocumentList: View {
    
    @ObservedObject var documentsViewModel = DocumentsViewModel()
    
    @State private var search: String = ""
    @FocusState private var searchIsFocused: Bool
    
    var body: some View {
        NavigationSplitView {
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
                        DocumentSubmissionsList(identifier: document.identifier)
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
            }
        } detail: {
            Text("Select a document")
        }
        .onAppear {
            documentsViewModel.fetchDocuments()
        }
    }
}

#Preview {
    DocumentList()
}