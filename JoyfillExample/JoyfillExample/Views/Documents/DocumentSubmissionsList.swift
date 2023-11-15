import SwiftUI

struct DocumentSubmissionsList: View {
    var identifier: String
    var name: String
    
    @ObservedObject var documentsViewModel = DocumentsViewModel()
    
    @State private var search: String = ""
    @FocusState private var searchIsFocused: Bool
    
    @State var selectedIdentifier: String?
    
    func customBinding() -> Binding<String?> {
        let binding = Binding<String?>(get: {
            self.selectedIdentifier
        }, set: {
            print("Table \(String(describing: $0)) chosen")
            self.selectedIdentifier = $0
        })
        return binding
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                TextField("Search submissions", text: $search)
                    .focused($searchIsFocused)
                    .onSubmit {
                        print("Submitted \(search)")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.top, .bottom], 10)
                
                
                ForEach(documentsViewModel.submissions) { submission in
                    NavigationLink {
                        DocumentForm(identifier: submission.identifier, userAccessToken: documentsViewModel.userAccessToken)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "doc")
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                                Text(submission.name)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.system(size: 20, weight: .semibold)).padding([.top], 10)
                        Text("Submissions")
                            .font(.system(size: 16, weight: .semibold)).foregroundStyle(.gray)
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Note: @identifier param for refreshing the list after creation only
                        documentsViewModel.createDocumentSubmission(identifier: identifier, completion: { joyDocJSON in
                            documentsViewModel.fetchDocumentSubmissions(identifier: identifier)
                        })
                    } label: {
                        HStack {
                            Text("Fill New")
                            Image(systemName: "plus")
                        }.padding([.top], 28)
                        
                    }
                }
            }
            .overlay {
                if documentsViewModel.submissionsLoading {
                    ProgressView()
                }
            }
        } detail: {
            Text("Select a document")
        }
        .onAppear {
            documentsViewModel.fetchDocumentSubmissions(identifier: identifier)
        }
        .refreshable {
            documentsViewModel.fetchDocumentSubmissions(identifier: identifier)
        }
    }
}

#Preview {
    DocumentSubmissionsList(identifier: "template_65540f03bc18c7a71302b9de", name: "AES 6")
}
