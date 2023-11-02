![joyfill_logo](https://github.com/joyfill/examples/assets/5873346/4943ecf8-a718-4c97-a917-0c89db014e49)

# @joyfill/components-swift

## 🧳 Requirements:
1. Note userAccessTokens & identifiers will need to be stored on your end (usually on a user and set of existing form field-based data) in order to interact with our API and UI Components effectively.
2. iOS v14+
3. Xcode v13+

## Navigation

- [Installation](#-installation)
    - [CocoaPods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
    - [Manually](#manually)
 - [Field Events](#-field-events)
 - [Code Example](#-code-example)
    - [For Swift](#for-Swift)
    - [For Objective-C](#for-Objective-C)

## 💻 Installation:

### Cocoapods

[JoyfillComponents Cocapods Website](https://cocoapods.org/pods/packageSwift)

CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate `AlertToast` into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
pod 'packageSwift'
```

------

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate `JoyFill` into your Xcode project using Xcode, specify it in `specify it in File > Add Packages...:`:

```ogdl
https://github.com/joyfill/components-ios.git, :branch="main" 
```

------

### Manually

If you prefer not to use any of dependency managers, you can integrate `JoyFill` into your project manually. Put `Sources/JoyfillComponents` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Field Events

* **Text**, **Textarea**, **Number**
    *  `onFocus(params: object, e: object)` is fired when the field is focused.
    *  `onChange` is fired when the field value is modified.
    *  `onBlur` is fired when the field is blurred.
*  **Date**, **Dropdown**
    *  `onFocus` is fired when the field is pressed and selection modal is displayed.
    *  `onChange` is fired when the field value is modified.
    *  `onBlur` is fired when the field is blurred and the selection modal is closed.
*  **Multiselect**
    *  `onFocus` is fired when an option is selected or unselected for the first time on the field.
    *  `onChange` is fired when an option is selected or unselected in the field.
*  **Chart**
    *  `onFocus` is fired when “view” button is pressed and modal is displayed.
    *  `onChange` is fired when the field value is modified.
    *  `onBlur` is fired when modal is closed.
*  **Image**
    *  `onFocus` is fired when “view” button is pressed and modal is displayed.
        *  An empty image field that is focused will also trigger the `onUploadAsync` request.
        *  A populated image field that is focused will trigger the image modal to open.
    *  `onChange` is fired when the field images are uploaded or removed.
    *  `onBlur` is fired when modal is closed.
* **Signature**
    *  `onFocus` is fired when open modal button is pressed and modal is displayed.
    *  `onChange` is fired when the field value is modified.
    *  `onBlur` is fired when the modal is closed.
*  **Table**
    *  `onFocus` is fired when “view” button is pressed and modal is displayed.
    *  `onBlur` is fired when modal is closed.
    * **Table Cells**
        * **Text Cell**
            * `onFocus` is fired when the cell is focused.
            * `onChange` is fired when the cell value is modified.
            * `onBlur` is fired when the cell is blurred
        * **Dropdown Cell**
            *  `onFocus` is fired when the cell is pressed and selection modal is displayed.
            *  `onChange` is fired when the field value is modified.
            *  `onBlur` is fired when the cell is blurred and the selection modal is closed.
        * **Image Cell**
            *  `onFocus` is fired cell is pressed and modal is displayed.
                *  An empty image cell that is focused will also trigger the `onUploadAsync` request.
                *  A populated image cell that is focused will trigger the image modal to open.
            *  `onChange` is fired when the cell images are uploaded or removed.
            *  `onBlur` is fired when modal is closed.

**IMPORTANT NOTE:** JoyDoc SDK `onFocus`, `onChange` and `onBlur` events are not always called in the same order. Two different fields can be triggering events at the same time.  For instance, if you have Field A focused and then focus on Field B, the Field B onFocus event could be fired before the Field A onBlur event. Always check the event params object ids to match up the associated field events.

------

## 🛠 Code Example

### For Swift

Inside swift viewController file:

1. On the top 1st import joyfill package using:
```swift

import JoyfillComponents
    
```

2. Then inside your viewController class add these variables:
```swift

var apiUrl = "https://api-joy.joyfill.io"
var identifier = "<REPLACE_ME>"
var userAccessToken = "<REPLACE_ME>"
    
```

3. Then inside viewController override method viewDidLoad() add:
```swift

override func viewDidLoad() {
    super.viewDidLoad()
    getDocumentAsync()
    self.overrideUserInterfaceStyle = .light
}
    
```

4. Then add these function inside your viewController file:
```swift

func getDocumentAsync() {
    let url = URL(string: apiUrl + "/v1/documents/" + identifier)
    guard url != nil else {
        print("Error")
        return
    }
            
    var request = URLRequest(url: url!)
    let verificationToken = ["Authorization": "Bearer \(userAccessToken)"]
    let header = verificationToken
            
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = header
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) {data, _, error in
        if error == nil && data != nil {
            do {
                jsonData = data!
                DispatchQueue.main.async {
                    let components = Form()
                    components.saveDelegate = self
                    components.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(components)
                    NSLayoutConstraint.activate([
                        components.topAnchor.constraint(equalTo: self.view.topAnchor),
                        components.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        components.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                        components.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                    ])
                            
                    uploadImageTapAction = {
                        <Add upload image action here> 
                    }
                            
                    saveButtonTapAction = {
                        self.updateDocumentChangelogsAsync()
                    }
                }
            }
        }
    }.resume()
}
        
func updateDocumentChangelogsAsync() {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: docChangeLogs, options: [])
        if let url = URL(string: apiUrl + "/v1/documents/" + identifier + "/changelogs") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
                    
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let verificationToken = ["Authorization": "Bearer \(userAccessToken)"]
            let header = verificationToken
            request.allHTTPHeaderFields = header
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                    let _ = json as? NSDictionary
                    self.getDocumentAsync()
                }
            }
            task.resume()
        }
    } catch {
        print("Error serializing JSON: \(error)")
    }
}
    
```

5. Then add these onChange, onBlur and onFocus methods inside your viewController file:
```swift

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
    
```

6. Now it is ready to run.

------

### For Objective-C

1. Create a new Swift file in your Objective-C project and while creating swift select "Create Bridging Header". 
2. Create a Bridging Header file manually if doesn't exist in your project:
```swift

To use Swift code in an Objective-C project, you need to create a bridging header. The bridging header is an Objective-C header file that allows your Objective-C code to access Swift code. Xcode will typically prompt you to create a bridging header when you add Swift code to an Objective-C project. If it doesn't, you can create one manually.
- Right click on Project folder -> "New File..."
- Select "Header File" under the "Source" section and give it a name like "YourProject-Bridging-Header.h."

```

3. Replace with below given code in new created swift file:
```swift

import Foundation
import UIKit
import JoyfillComponents

@objc(JoyDocForm)
class JoyDocForm: UIView, onChange {
    
    var apiUrl = "https://api-joy.joyfill.io"
    var identifier = "<REPLACE_ME>"
    var userAccessToken = "<REPLACE_ME>"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    @objc public func getDocumentAsync(viewController: UIViewController) {
        let url = URL(string: apiUrl + "/v1/documents/" + identifier)
        guard url != nil else {
            print("Error")
            return
        }
        
        var request = URLRequest(url: url!)
        let verificationToken = ["Authorization": "Bearer \(userAccessToken)"]
        let header = verificationToken
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) {data, _, error in
            if error == nil && data != nil {
                do {
                    jsonData = data!
                    DispatchQueue.main.async {
                        let components = Form()
                        components.saveDelegate = self
                        components.translatesAutoresizingMaskIntoConstraints = false
                        viewController.view.addSubview(components)
                        NSLayoutConstraint.activate([
                            components.topAnchor.constraint(equalTo: viewController.view.topAnchor),
                            components.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                            components.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
                            components.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
                        ])
                        uploadImageTapAction = {
                            <Add upload image action here>
                        }
                        
                        saveButtonTapAction = {
                            self.updateDocumentChangelogsAsync(viewController: viewController)
                        }
                    }
                }
            }
        }.resume()
    }
    
    func updateDocumentChangelogsAsync(viewController: UIViewController) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: docChangeLogs, options: [])
            if let url = URL(string: apiUrl + "/v1/documents/" + identifier + "/changelogs") {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let verificationToken = ["Authorization": "Bearer \(userAccessToken)"]
                let header = verificationToken
                request.allHTTPHeaderFields = header
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                    } else if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                        let _ = json as? NSDictionary
                        self.getDocumentAsync(viewController: viewController)
                    }
                }
                task.resume()
            }
        } catch {
            print("Error serializing JSON: \(error)")
        }
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

```

4. In Objective-C viewController.m file add:
```objective-C

#import "<Your Project Name>-Swift.h"

```

5. Then in (void)viewDidLoad of Objective-C viewController.m file add:
```objective-C

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JoyDocForm *joyDoc = [JoyDocForm new];
    [joyDoc getDocumentAsyncWithViewController:self];
}

```

6. Now it is ready to run.
