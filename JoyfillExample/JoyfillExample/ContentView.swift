/*
 How does this example work?
 
    1. Using the provided userAccessToken we retrieve all published templates
    2. Upon clicking on one of those templates we create a document submission from the selected one
    3. We then display that new documents JSON (JoyDoc structure) to our @joyfill/components-ios sdk form
 */

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        DocumentList()
    }
    
}

#Preview {
    ContentView()
}
