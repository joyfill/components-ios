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

public var tableRowOrder = [String]()
public var tableColumnType = [String]()
public var tableColumnTitle = [String]()
public var tableCellsData = [[String]]()
public var tableColumnOrderId = [String]()
public var componentId = [String]()

public var jsonString = String()
var tableFieldValue: [ValueElement] = []
var optionsData: [FieldTableColumn] = []
var valueUnion: [ValueUnion] = []
var joyApiData: [JoyFillAPIField] = []

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
                
                // It will prevent tasks to perform on main thread
                DispatchQueue.main.async {
                    // Deinitialize arrays to protect memory leakage
                    yCoordinates = []
                    xCoordinates = []
                    graphLabelData = []
                    joyApiData.removeAll()
                    pickedImg.removeAll()
                    tableFieldValue.removeAll()
                    optionsData.removeAll()
                    tableRowOrder.removeAll()
                    componentType.removeAll()
                    tableCellsData.removeAll()
                    dropdownOptions.removeAll()
                    tableColumnType.removeAll()
                    tableColumnTitle.removeAll()
                    tableColumnOrderId.removeAll()
                    multiSelectOptions.removeAll()
                    componentHeaderText.removeAll()
                    componentsYValueForMobileView.removeAll()
                    componentId.removeAll()
                    
                    jsonString = ""
                    
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
                componentId.append(joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].field ?? "")
                zipAndSortComponents()
                getInputValuesFromPrimaryView(i: i, j: j)
                getOptionValues(i: i, j: j)
            }
            
            // Save field data from JoyDoc
            let count = joyFillStruct?.fields?.count ?? 0
            for k in 0..<count {
                if let field = joyFillStruct?.fields?.first(where: { $0.id == componentId[k] }){
                    joyApiData.append(field)
                }
            }
        }
    } else {
        // Fetch data for mobile view
        pageCount = joyFillStruct?.files?[0].views?[0].pages?.count ?? 0
        for i in 0..<pageCount {
            fieldCount = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?.count ?? 0
            let count = joyFillStruct?.fields?.count ?? 0
            
            for j in 0..<fieldCount {
                // Get y value of all components
                let yFieldValue = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].y ?? 0.0
                componentsYValueForMobileView.append(Int(yFieldValue))
                componentType.append(joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].type ?? "")
                componentId.append(joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].field ?? "")
                zipAndSortComponents()
                
                if joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].type == "block" {
                    blockTextSize = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontSize ?? 18
                    blockTextStyle = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontStyle ?? ""
                    blockTextWeight = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontWeight ?? ""
                    blockTextColor = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontColor ?? "#000000"
                    blockTextAlignment = joyFillStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].textAlign ?? "left"
                }
            }
            
            // Get values of the components from the fields
            for k in 0..<count {
                componentTypeValue = joyFillStruct?.fields?[k].type ?? ""
                getInputValuesFromMobileView(i: i, j: k)
                getOptionValues(i: i, j: k)
                if let field = joyFillStruct?.fields?.first(where: { $0.id == componentId[k] }){
                    joyApiData.append(field)
                    DispatchQueue.main.async {
                        componentTableView.reloadData()
                    }
                }
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

// Zip and sort componentType and ComponentHeaderText with componentsYValueForMobileView
func zipAndSortComponents() {
    var componentIdPairedArray = Array(zip(componentsYValueForMobileView, componentId))
    var componentTypePairedArray = Array(zip(componentsYValueForMobileView, componentType))
    var componentHeaderTextPairedArray = Array(zip(componentsYValueForMobileView, componentHeaderText))
    componentIdPairedArray.sort { $0.0 < $1.0}
    componentTypePairedArray.sort { $0.0 < $1.0 }
    componentHeaderTextPairedArray.sort { $0.0 < $1.0}
    
    // Extract the sorted values back into the original arrays
    componentId = componentIdPairedArray.map { $0.1 }
    componentType = componentTypePairedArray.map { $0.1 }
    componentHeaderText = componentHeaderTextPairedArray.map { $0.1 }
    componentsYValueForMobileView = componentTypePairedArray.map { $0.0 }
}

// MARK: - Function for PrimaryView
// Function to get input values
func getInputValuesFromPrimaryView(i: Int, j: Int) {
    if let value = joyFillStruct?.fields?[j].value {
        switch value {
        case .string(let string):
            getStringValues(string: string, i: i, j: j)
            
        case .valueElementArray(let valueElements):
            getArrayValue(valueElements: valueElements, j: j)
            
        case .integer(let integer):
            getIntegerValue(integer: integer)
        }
    }
}

// MARK: - Function for AlternateView(MobileView)
// Function to get input values
func getInputValuesFromMobileView(i: Int, j: Int) {
    if let value = joyFillStruct?.fields?[j].value {
        switch value {
        case .string(let string):
            getStringValues(string: string, i: i, j: j, mobileView: true)
            
        case .valueElementArray(let valueElements):
            getArrayValue(valueElements: valueElements, j: j)
            
        case .integer(let integer):
            getIntegerValue(integer: integer)
        }
    }
}

// Function to get the option values
func getOptionValues(i: Int, j: Int) {
    optionCount = joyFillStruct?.fields?[j].options?.count ?? 0
    for n in 0..<optionCount {
        if componentTypeValue == "dropdown" {
            dropdownOptions.append(joyFillStruct?.fields?[j].options?[n].value ?? "")
        }
        if componentTypeValue == "multiSelect" {
            multiSelect = joyFillStruct?.fields?[j].multi ?? true
            multiSelectOptions.append(joyFillStruct?.fields?[j].options?[n].value ?? "")
        }
    }
}

// Function to get string values from the model
func getStringValues(string: String, i: Int, j: Int, mobileView: Bool = false) {
    if componentTypeValue == "textarea" {
        textAreaString = string
    }
    if componentTypeValue == "block" {
        if !mobileView {
            blockTextSize = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].fontSize ?? 18
            blockTextStyle = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].fontStyle ?? ""
            blockTextWeight = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].fontWeight ?? ""
            blockTextColor = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].fontColor ?? "#000000"
            blockTextAlignment = joyFillStruct?.files?[0].pages?[i].fieldPositions?[j].textAlign ?? "left"
        }
        
        blockFieldString = string
        
        DispatchQueue.main.async {
            componentTableView.reloadData()
        }
    }
    if componentTypeValue == "text" {
        textFieldString = string
    }
    if componentTypeValue == "richText" {
        jsonString = string
    }
}

// Function to get chart and image values
func getArrayValue(valueElements: [ValueElement], j: Int) {
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
        imageMultiValue = joyFillStruct?.fields?[j].multi ?? false
        for k in 0..<valueElements.count {
            pickedSingleImg = [valueElements[k].url ?? ""]
            pickedImg.append(valueElements[k].url ?? "")
        }
    }
    
    if componentTypeValue == "table" {
        optionsData = joyFillStruct?.fields?[j].tableColumns ?? []
        for item in valueElements {
            if (item.deleted ?? false) == false {
                tableFieldValue.append(item)
            }
        }
        
        // Fetch table row order from joyDoc
        for rows in 0..<(joyFillStruct?.fields?[0].rowOrder?.count ?? 0) {
            tableRowOrder.append(joyFillStruct?.fields?[0].rowOrder?[rows] ?? "")
        }
        
        // Fetch table column type and title after sorting column based on their columnId
        for columns in 0..<(joyFillStruct?.fields?[0].tableColumnOrder?.count ?? 0) {
            tableColumnOrderId.append(joyFillStruct?.fields?[0].tableColumnOrder?[columns] ?? "")
            if let fieldTableColumn = joyFillStruct?.fields?[j].tableColumns?.first(where: { $0.id == joyFillStruct?.fields?[0].tableColumnOrder?[columns]}) {
                tableColumnType.append(fieldTableColumn.type ?? "")
                tableColumnTitle.append(fieldTableColumn.title ?? "")
            }
        }
        
        for k in 0..<tableFieldValue.count {
            if let cells = tableFieldValue[k].cells {
                let valuesArray = Array(cells.values)
                tableCellsData.append(valuesArray)
            }
        }
    }
}

// Function to get int values from model
func getIntegerValue(integer: Int) {
    if componentTypeValue == "number" {
        numberFieldString = integer
    }
}
