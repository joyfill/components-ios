import SwiftUI
import UIKit
import JoyfillComponents
import AlertToast

class ViewController: UIViewController, onChange {

    // MARK: - Variables
    @ObservedObject var JoyDocModel = JoyDocViewModel()
    
    var apiUrl = "https://api-joy.joyfill.io"
    var identifier = ""
    var userAccessToken = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the joydoc JSON from the Joyfill API (optional). Any JoyDoc spec'd
        // JSON will work with our Form below.
        JoyDocModel.fetchJoyDoc(identifier: identifier, userAccessToken: userAccessToken, completion: { joyDocJSON in
            
            print("Loaded view completion ", joyDocJSON)
            
            jsonData = joyDocJSON as! Data
            DispatchQueue.main.async {
                // Setup joydoc form
                let form = Form()
                form.saveDelegate = self
                
                // Add joydoc to view
                self.view.addSubview(form)
                
                // Set joydoc views for full screen form view (optional)
                self.overrideUserInterfaceStyle = .light
                form.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    form.topAnchor.constraint(equalTo: self.view.topAnchor),
                    form.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    form.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    form.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                ])
                
                // Listener for joydoc form changes
                uploadImageTapAction = {
                    print("Upload images...")
                }
                
                
                // Optional usage for the included Save button, if using self hosted this
                // could be a call to your DB saving the Joyfill JSON
                saveButtonTapAction = {
                    print("Changes saved...")
                    
                    // JoyDoc - Form ongoing user field changes
                    self.JoyDocModel.updateDocumentChangelogs(
                        identifier: self.identifier,
                        userAccessToken: self.userAccessToken,
                        docChangeLogs: docChangeLogs
                    )
                }
            }
            
        })
        
    }
    
    func handleOnChange(docChangelog: [String : Any], doc: [String : Any]) {
        print(">>>>>>>> docChangelog: ", docChangelog)
        print(">>>>>>>> onChange: ", doc)
    }
    
    func handleOnFocus(blurAndFocusParams: [String : Any]) {
        print(">>>>>>>> handleFocus: ", blurAndFocusParams)
    }
    
    func handleOnBlur(blurAndFocusParams: [String : Any]) {
        print(">>>>>>>> handleBlur: ", blurAndFocusParams)
    }
}

// Create a UIViewControllerRepresentable wrapper as JoyFillComponents used UIKit internally
struct UIKitViewControllerWrapper: UIViewControllerRepresentable {
    var identifier: String
    var userAccessToken: String
    
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.identifier = identifier
        viewController.userAccessToken = userAccessToken
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

struct DocumentJoyDoc: View {
    var identifier: String
    var userAccessToken: String
    var body: some View {
        UIKitViewControllerWrapper(identifier: identifier, userAccessToken: userAccessToken)
    }
}

#Preview {
    DocumentJoyDoc(identifier: "template_6543d0edf91c009ca84b3a30", userAccessToken: Constants.userAccessToken)
}
