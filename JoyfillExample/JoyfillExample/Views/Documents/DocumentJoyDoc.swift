import SwiftUI
import UIKit
import JoyfillComponents
import AlertToast

class ViewController: UIViewController, onChange, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    // MARK: - Variables
    @ObservedObject var JoyDocModel = JoyDocViewModel()
    
    var apiUrl = "https://api-joy.joyfill.io"
    var identifier = ""
    var userAccessToken = ""
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
                mode = "fill"
                form.saveDelegate = self
                
                // Add joydoc to view
                self.view.addSubview(form)
                self.view.addSubview(self.saveButton)
                
                // Set joydoc views for full screen form view (optional)
                self.overrideUserInterfaceStyle = .light
                form.translatesAutoresizingMaskIntoConstraints = false
                self.saveButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    form.topAnchor.constraint(equalTo: self.view.topAnchor),
                    form.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    form.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    form.bottomAnchor.constraint(equalTo: self.saveButton.topAnchor, constant: -5),
                    
                    self.saveButton.topAnchor.constraint(equalTo: form.bottomAnchor, constant: 5),
                    self.saveButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
                    self.saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
                    self.saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
                ])
                
                // Listener for joydoc form changes
                uploadImageTapAction = {
                    print("Upload images...")
                    
                    var alertStyle = UIAlertController.Style.actionSheet
                    if (UIDevice.current.userInterfaceIdiom == .pad) {
                        alertStyle = UIAlertController.Style.alert
                    }
                    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: alertStyle)
                    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                        self.openImageGallery()
                    }))
                    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    @objc func saveButtonTapped() {
        // Optional usage for the included Save button, if using self hosted this
        // could be a call to your DB saving the Joyfill JSON
        print("Changes saved...")
        
        // JoyDoc - Form ongoing user field changes
        self.JoyDocModel.updateDocumentChangelogs(
            identifier: self.identifier,
            userAccessToken: self.userAccessToken,
            docChangeLogs: docChangeLogs
        )
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
    
    // MARK: - Functions to access and fetch image from gallery.
    func openImageGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            convertImageToDataURI(uri: pickedImage)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to convert UIImage to data URI
    func convertImageToDataURI(uri: UIImage) {
        if let imageData = uri.jpegData(compressionQuality: 1.0) {
            let base64String = imageData.base64EncodedString()
            updateImage = true
            imageSelectionCount[imageIndexNo] = ["data:image/jpeg;base64,\(base64String)"]
            pickedSinglePicture[imageIndexNo] = ["data:image/jpeg;base64,\(base64String)"]
            selectedPicture[imageIndexNo].append("data:image/jpeg;base64,\(base64String)")
            componentTableView.reloadData()
        }
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
    DocumentJoyDoc(identifier: "template_65540f03bc18c7a71302b9de", userAccessToken: Constants.userAccessToken)
}
