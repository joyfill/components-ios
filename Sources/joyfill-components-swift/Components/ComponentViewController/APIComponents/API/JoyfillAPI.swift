import Foundation
import UIKit

// Global variables
public var componentType = [String]()
public var componentHeaderText = [String]()
public var componentsYValueForMobileView = [Int]()

// Variables to save input values
public var numberFieldString: Int?
public var textAreaString: String?
public var textFieldString: String?
public var blockFieldString: String?

// Variable to save block field custom style values
public var blockTextSize = Int()
public var blockTextColor = String()
public var blockTextStyle = String()
public var blockTextWeight = String()
public var blockTextAlignment = String()

// Variable to save counts
var pageCount = Int()
var fieldCount = Int()
var optionCount = Int()
var tableColumnsCount = Int()
var componentTypeValue = String()

// MARK: - API link
public var joyfillDocID = String()
public var joyfillAuthorizationToken = String()
let joyfillAPIUri = "https://api-joy.joyfill.io/v1/documents/" + joyfillDocID

// MARK: - Joyfill API Call
var joyFillStruct: JoyFillAPI?
public func joyfillAPICall() {
    let url = URL(string: joyfillAPIUri)
    
    guard url != nil else {
        print("Error")
        return
    }
    
    var request = URLRequest(url: url!)
    let verificationToken = ["Authorization" : joyfillAuthorizationToken]
    let header = verificationToken
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = header
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) {data, _, error in
        if error == nil && data != nil {
            do {
                joyFillStruct = try JSONDecoder().decode(JoyFillAPI.self, from: data!)
                // Deinitialize arrays to protect memory leakage
                yCoordinates = []
                xCoordinates = []
                graphLabelData = []
                pickedImg.removeAll()
                componentType.removeAll()
                dropdownOptions.removeAll()
                multiSelectOptions.removeAll()
                componentHeaderText.removeAll()
                
                // It will prevent tasks to perform on main thread
                DispatchQueue.main.async {
                    // Deinitialize arrays to protect memory leakage
                    yCoordinates = []
                    xCoordinates = []
                    graphLabelData = []
                    pickedImg.removeAll()
                    componentType.removeAll()
                    dropdownOptions.removeAll()
                    multiSelectOptions.removeAll()
                    componentHeaderText.removeAll()
                    componentsYValueForMobileView.removeAll()
                    
                    fetchDataFromApi()
                    
                    componentTableView.delegate = viewForDataSource as? any UITableViewDelegate
                    componentTableView.dataSource = viewForDataSource as? any UITableViewDataSource
                    componentTableView.reloadData()
                    ActivityIndicator.hide()
                }
                print("JoyFill API Success")
            } catch {
                ActivityIndicator.hide()
                print("JoyFill API Fail")
            }
        }
    }.resume()
}

// MARK: - Function to get data from API
func fetchDataFromApi() {
    if joyFillStruct?.files?[0].views?.count == 0 {
        // Fetch data for primary view
        pageCount = joyFillStruct?.files?[0].pages?.count ?? 0
        for i in 0..<pageCount {
            fieldCount = joyFillStruct?.files?[0].pages?[i].fieldPositions?.count ?? 0
            for j in 0..<fieldCount {
                
                // Get y value of all components
                let yFieldValue = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].y ?? 0.0
                componentsYValueForMobileView.append(Int(yFieldValue))
                
                componentType.append(joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].type ?? "")
                componentHeaderText.append(joyFillStruct?.fields?[j].title ?? "")
                componentTypeValue = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].type ?? ""
                
                // Zip and sort componentType and ComponentHeaderText with componentsYValueForMobileView
                var componentTypePairedArray = Array(zip(componentsYValueForMobileView, componentType))
                var componentHeaderTextPairedArray = Array(zip(componentsYValueForMobileView, componentHeaderText))
                componentTypePairedArray.sort { $0.0 < $1.0 }
                componentHeaderTextPairedArray.sort { $0.0 < $1.0}

                // Extract the sorted values back into the original arrays
                componentType = componentTypePairedArray.map { $0.1 }
                componentHeaderText = componentHeaderTextPairedArray.map { $0.1 }
                componentsYValueForMobileView = componentTypePairedArray.map { $0.0 }
                
                // MARK: Functions call
                getInputValuesFromPrimaryView(i: i, j: j)
                getOptionValuesFromPrimaryView(i: i, j: j)
            }
        }
    } else {
        // Fetch data for mobile view
        pageCount = joyFillStruct?.files?[0].views?[0].pages?.count ?? 0
        for i in 0..<pageCount {
            fieldCount = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?.count ?? 0
            for j in 0..<fieldCount {
                
                // Get y value of all components
                let yFieldValue = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].y ?? 0.0
                componentsYValueForMobileView.append(Int(yFieldValue))
                
                componentType.append(joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].type ?? "")
                componentTypeValue = joyFillStruct?.fields?[j].type ?? ""
                
                // Zip and sort componentType and ComponentHeaderText with componentsYValueForMobileView
                var componentTypePairedArray = Array(zip(componentsYValueForMobileView, componentType))
                var componentHeaderTextPairedArray = Array(zip(componentsYValueForMobileView, componentHeaderText))
                componentTypePairedArray.sort { $0.0 < $1.0 }
                componentHeaderTextPairedArray.sort { $0.0 < $1.0}

                // Extract the sorted values back into the original arrays
                componentType = componentTypePairedArray.map { $0.1 }
                componentHeaderText = componentHeaderTextPairedArray.map { $0.1 }
                componentsYValueForMobileView = componentTypePairedArray.map { $0.0 }
                
                // MARK: Functions call
                getInputValuesFromMobileView(i: i, j: j)
                getOptionValuesFromMobileView(i: i, j: j)
            }
        }
        
        // Get the title of the components
        for i in 0..<componentType.count {
            if let field = joyFillStruct?.fields?.first(where: { $0.type == componentType[i] }) {
                componentHeaderText.append(field.title ?? "")
            }
        }
    }
}

// MARK: - Function for PrimaryView
// Function to get input values
func getInputValuesFromPrimaryView(i: Int, j: Int) {
    if let value = joyFillStruct?.fields?[j].value {
        switch value {
        case .string(let string):
            if componentTypeValue == "textarea" {
                textAreaString = string
            }
            if componentTypeValue == "block" {
                blockFieldString = string
                blockTextSize = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].fontSize ?? 18
                blockTextStyle = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].fontStyle ?? ""
                blockTextWeight = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].fontWeight ?? ""
                blockTextColor = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].fontColor ?? "#000000"
                blockTextAlignment = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].textAlign ?? "left"
                DispatchQueue.main.async {
                    componentTableView.reloadData()
                }
            }
            if componentTypeValue == "text" {
                textFieldString = string
            }
            
        case .valueElementArray(let valueElements):
            if componentTypeValue == "chart" {
                for k in 0..<valueElements.count {
                    var graphLabelSubArray: [String] = []
                    var graphXCoordinateSubArray: [CGFloat] = []
                    var graphYCoordianteSubArray: [CGFloat] = []
                    if let points = valueElements[k].points {
                        for l in 0..<points.count {
                            let label = points[l].label ?? ""
                            graphLabelSubArray.append(label)
                            
                            let xCoordinate = points[l].x ?? 0
                            graphXCoordinateSubArray.append(xCoordinate)
                            
                            let yCoordinate = points[l].y ?? 0
                            graphYCoordianteSubArray.append(yCoordinate)
                        }
                    }
                    graphLabelData.append(graphLabelSubArray)
                    xCoordinates.append(graphXCoordinateSubArray)
                    yCoordinates.append(graphYCoordianteSubArray)
                }
            }
            if componentTypeValue == "image" {
                for k in 0..<valueElements.count {
                    if let imageURL = URL(string: valueElements[k].url ?? "") {
                        getImageFromURL(url: imageURL) { image in
                            if let image = image {
                                pickedImg.append(image)
                                DispatchQueue.main.async {
                                    componentTableView.reloadData()
                                }
                            } else {
                                print("Failed to download image.")
                            }
                        }
                    }
                }
            }
            
        case .integer(let integer):
            if componentTypeValue == "number" {
                numberFieldString = integer
            }
        }
    }
}

// Function to get the option values
func getOptionValuesFromPrimaryView(i: Int, j: Int) {
    optionCount = joyFillStruct?.fields?[j].options?.count ?? 0
    for n in 0..<optionCount {
        if componentTypeValue == "dropdown" {
            dropdownOptions.append(joyFillStruct?.fields?[j].options?[n].value ?? "")
        }
        if componentTypeValue == "multiSelect" {
            multiSelectOptions.append(joyFillStruct?.fields?[j].options?[n].value ?? "")
        }
    }
}

// MARK: - Function for AlternateView(MobileView)
// Function to get input values
func getInputValuesFromMobileView(i: Int, j: Int) {
    if let value = joyFillStruct?.fields?[j].value {
        switch value {
        case .string(let string):
            if componentTypeValue == "textarea" {
                textAreaString = string
            }
            if componentTypeValue == "block" {
                blockFieldString = string
                blockTextSize = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontSize ?? 18
                blockTextStyle = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontStyle ?? ""
                blockTextWeight = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontWeight ?? ""
                blockTextColor = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontColor ?? "#000000"
                blockTextAlignment = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].textAlign ?? "left"
                DispatchQueue.main.async {
                    componentTableView.reloadData()
                }
            }
            if componentTypeValue == "text" {
                textFieldString = string
            }
            
        case .valueElementArray(let valueElements):
            if componentTypeValue == "chart" {
                for k in 0..<valueElements.count {
                    var graphLabelSubArray: [String] = []
                    var graphXCoordinateSubArray: [CGFloat] = []
                    var graphYCoordianteSubArray: [CGFloat] = []
                    if let points = valueElements[k].points {
                        for l in 0..<points.count {
                            let label = points[l].label ?? ""
                            graphLabelSubArray.append(label)
                            
                            let xCoordinate = points[l].x ?? 0
                            graphXCoordinateSubArray.append(xCoordinate)
                            
                            let yCoordinate = points[l].y ?? 0
                            graphYCoordianteSubArray.append(yCoordinate)
                        }
                    }
                    graphLabelData.append(graphLabelSubArray)
                    xCoordinates.append(graphXCoordinateSubArray)
                    yCoordinates.append(graphYCoordianteSubArray)
                }
            }
            if componentTypeValue == "image" {
                for k in 0..<valueElements.count {
                    if let imageURL = URL(string: valueElements[k].url ?? "") {
                        getImageFromURL(url: imageURL) { image in
                            if let image = image {
                                pickedImg.append(image)
                                DispatchQueue.main.async {
                                    componentTableView.reloadData()
                                }
                            } else {
                                print("Failed to download image.")
                            }
                        }
                    }
                }
            }
            
        case .integer(let integer):
            if componentTypeValue == "number" {
                numberFieldString = integer
            }
        }
    }
}

// Function to get the option values
func getOptionValuesFromMobileView(i: Int, j: Int) {
    optionCount = joyFillStruct?.fields?[j].options?.count ?? 0
    for n in 0..<optionCount {
        if componentTypeValue == "dropdown" {
            dropdownOptions.append(joyFillStruct?.fields?[j].options?[n].value ?? "")
        }
        if componentTypeValue == "multiSelect" {
            multiSelectOptions.append(joyFillStruct?.fields?[j].options?[n].value ?? "")
        }
    }
}

// MARK: - Function to convert image url to UIImage
public func getImageFromURL(url: URL, completion: @escaping (UIImage?) -> Void) {
    // Create a URLSession
    let session = URLSession.shared
    
    // Create a data task to download the image data
    let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error downloading image: \(error)")
            completion(nil)
            return
        }
        
        // Check if data is available and create UIImage
        if let data = data, let image = UIImage(data: data) {
            completion(image)
        } else {
            completion(nil)
        }
    }
    task.resume()
}
