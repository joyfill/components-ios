import SwiftUI
import AlertToast

struct DocumentForm: View {
    var identifier: String
    var userAccessToken: String
    
    @State private var showLoaded = false
    
    var body: some View {
        Group {
            DocumentJoyDoc(identifier: identifier, userAccessToken: userAccessToken)
        }.toast(isPresenting: $showLoaded, duration: 2, tapToDismiss: true) {
            AlertToast(type: .complete(Color(.green)), title: "Form Loaded")
        }.onAppear {
            showLoaded.toggle()
        }
    }
}

#Preview {
    DocumentForm(identifier: "doc_65541474f9ec752c39709966", userAccessToken: Constants.userAccessToken)
}
