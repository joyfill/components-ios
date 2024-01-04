
import UIKit
import JoyfillComponents
import Toast

// Shows the list of documents (not templates, rather submissions)
class JoyDocViewController: UIViewController, onChange, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let vm = JoyDocViewModel()
    var selectedDocumentIdentifier: String = ""
    var selectedDocumentName: String = ""
    
    // MARK: - Components
    private lazy var saveBtn: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.title = "Save"
        config.baseBackgroundColor = .systemBlue.withAlphaComponent(0.08)
        config.baseForegroundColor = .systemBlue
        config.buttonSize = .medium
        config.cornerStyle = .medium
        
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
        
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController {
            joyfillNavigationController = navigationController
        }
        setup()
        vm.delegate = self
        vm.fetchJoyDoc(identifier: selectedDocumentIdentifier)
    }
}

// MARK: - Composition (Joyfill)
extension JoyDocViewController: JoyDocViewModelDelegate {
    
    // When the joydoc is fetched from the Joyfill API
    func didFinish() {
        print("Joydoc retrieved did finish.")
        self.title = "\(selectedDocumentName) <\(selectedDocumentIdentifier.suffix(4))>"
        
        // MARK: - Setup JoyDoc Form
        // jsonData is the joydocs internal data
        jsonData = vm.activeJoyDoc as! Data
        DispatchQueue.main.async {
            
            // 1. Setup joydoc form
            let joyfillForm = JoyfillForm()
            joyfillForm.mode = "fill" // or readonly
            joyfillForm.saveDelegate = self
            joyfillForm.translatesAutoresizingMaskIntoConstraints = false
            
            // 2. Add joydoc to view
            self.view.addSubview(joyfillForm)
            
            NSLayoutConstraint.activate([
                joyfillForm.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -12),
                joyfillForm.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                joyfillForm.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                joyfillForm.bottomAnchor.constraint(equalTo: self.saveBtn.topAnchor, constant: 0),
                
                self.saveBtn.topAnchor.constraint(equalTo: joyfillForm.bottomAnchor, constant: -25),
                self.saveBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
                self.saveBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
                self.saveBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
            ])
            
            // 3. Handle when user presses an ImageField upload button
            joyfillFormImageUpload = {
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
    }
    
    func didFail(_ error: Error) {
        print(error)
    }
    
    // MARK: - Lifecycles -> JoyDoc Handlers
    func handleOnChange(docChangelog: [String : Any], doc: [String : Any]) {
        print("change: ", docChangelog)
    }
    
    func handleOnFocus(blurAndFocusParams: [String : Any]) {
        print("focus: ", blurAndFocusParams)
    }
    
    func handleOnBlur(blurAndFocusParams: [String : Any]) {
        print("blur: ", blurAndFocusParams)
    }
    
    func handleImageUploadAsync(images: [String]) {
        print(">>>>>>>> images: ", images)
    }
    
    /* 
        MARK: - Functions to access and fetch image from gallery.
        Keep in mind that you do not have to use image picker you could provide a pre set list of images or don't handle it at all. We are just showing an exampel but once joyfillFormImageUpload is called you can do what you want with that action
     */
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
            onUploadAsync(imageUrl: "data:image/jpeg;base64,\(base64String)")
        }
    }
    
    // MARK: - Handle save button clicked
    @objc func didSave() {
        print("Saving...")
        
        // JoyDoc - Form ongoing user field changes
        vm.updateDocumentChangelogs(identifier: selectedDocumentIdentifier, docChangeLogs: docChangeLogs)
        
        let toast = Toast.text("Form saved ✅")
        toast.show()
        navigationController?.popViewController(animated: true)
    }
}

private extension JoyDocViewController {
    
    func setup() {
        
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        view.overrideUserInterfaceStyle = .light
                
        view.addSubview(saveBtn)
//        NSLayoutConstraint.activate([
//            saveBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
//            saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
//            saveBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -50),
//            saveBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
//        ])
        
        saveBtn.addTarget(self,
                          action: #selector(didSave),
                          for: .touchUpInside)
        
    }
    
    
}
