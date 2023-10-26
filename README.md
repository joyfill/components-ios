![joyfill_logo](https://github.com/joyfill/examples/assets/5873346/4943ecf8-a718-4c97-a917-0c89db014e49)

# joyfill/components-ios

## Project Requirements:
1. Note userAccessTokens & identifiers will need to be stored on your end (usually on a user and set of existing form field-based data) in order to interact with our API and UI Components effectively.
2. iOS v14+
3. Xcode v13+

## Install Dependency:
1. Inside your swift project click on the AppName in the Navigation Area (in the left side).
2. In the Editor Area (in the centre) under project again click on AppName then go to package dependencies click on “+” and add JoyFill package using “ https://github.com/joyfill/components-ios.git ”.

## Implement your code:
Make sure to replace the userAccessToken and documentId. Note that documentId is just for this example, you can call our List all documents endpoint and grab an ID from there.

Inside swift file:

1. After importing JoyFill SDK, inside JoyFill SDK code folder
```swift

- Go to 'Source' -> 'joyfill-components-swift' -> 'Components' 
- Inside Components right click on Assets folder then navigate to 'Show in Finder'
- Then drag and drop Assets to you project and choose 'Create Groups'.  

```

2. On the top 1st import joyfill package using
```swift

import joyfill_components_swift
    
```

3. Then inside your viewController class add these variables:
```swift

var apiUrl = "https://api-joy.joyfill.io"
var identifier = "<REPLACE_ME>"
var userAccessToken = "<REPLACE_ME>"
    
```

4. Then inside viewController override method viewDidLoad() call JoyDoc using:
```swift

override func viewDidLoad() {
    super.viewDidLoad()
    getDocumentAsync()
    self.overrideUserInterfaceStyle = .light
}
    
```

5. Then add these function inside your viewController file:
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

6. Then add these onChange, onBlur and onFocus methods
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

## Fiel Events

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
