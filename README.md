# joyfill/components-ios

A description of this package.
## Creating new app:
    1. Create a new Xcode project.
    2. Click on the AppName in the Navigation Area (in the left side).

## Project Requirements:
    Note userAccessTokens & identifiers will need to be stored on your end (usually on a user and set of existing form field-based data) in order to interact with our API and UI Components effectively.
    - iOS v14+
    - Xcode v13+

##Install Dependency:
    1. Under project go to package dependencies click on “+” and add JoyFill package using “ https://github.com/joyfill/components-ios.git ”.

##Implement your code:
    1. import joyfill_components_swift (add this to your .swift file)
    2. There is one Assets folder in the package add that folder to your app.
    3. Inside viewDidLoad() function:
        /*

            joyfillDocID = <REPLACE_ME>
            joyfillAuthorizationToken = <REPLACE_ME>
            joyfillAPICall()
        
            let components = ComponentViewController()
            components.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(components)
        
            NSLayoutConstraint.activate([
                components.topAnchor.constraint(equalTo: self.view.topAnchor),
                components.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                components.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                components.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])

        */
