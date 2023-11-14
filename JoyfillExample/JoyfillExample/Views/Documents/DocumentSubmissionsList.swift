import SwiftUI

struct DocumentSubmissionsList: View {
    var identifier: String
    
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
                    Text("Submissions")
                        .font(.system(size: 22, weight: .bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Get me working
//                        documentsViewModel.createDocumentSubmission(identifier: identifier)
                    } label: {
                        Text("Fill New")
                        Image(systemName: "plus")
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
    }
}

#Preview {
    DocumentSubmissionsList(identifier: "template_6543d0edf91c009ca84b3a30")
}