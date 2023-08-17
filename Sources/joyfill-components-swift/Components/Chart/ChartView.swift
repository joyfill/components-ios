import Foundation
import UIKit

public class ChartView: UIViewController, UITextFieldDelegate, ChartViewTextFieldCellDelegate {
    
    public var graphView = UIView()
    public var addLineView = UIView()
    public var showHideView = UIView()
    public var showHideLabel = Label()
    public var verticalLabel = Label()
    public var chartLineLabel = Label()
    public var verticalYView = UIView()
    public var horizontalLabel = Label()
    public var stackView = UIStackView()
    public var showHideButton = Button()
    public var horizontalXView = UIView()
    public var GPMTextField = ShortText()
    public var PSITextField = ShortText()
    public var showHideButtonView = UIView()
    public var addGraphLineButton = Button()
    public var performanceGraphBar = UIView()
    public var performanceGraphLabel = Label()
    public var addLineTableView = UITableView()
    public var showHideButtonImage = ImageView()
    public var verticalMaxTextField = ShortText()
    public var verticalMinTextField = ShortText()
    public var horizontalMaxTextField = ShortText()
    public var horizontalMinTextField = ShortText()
    public var scrollView = UIScrollView()
    public var contentView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        view.hideKeyboardOnTapAnyView()
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        addPointButtonIndexPath = 0
    }
    
    func setupUI() {
        // SubViews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.addSubview(graphView)
        contentView.addSubview(showHideView)
        contentView.addSubview(addLineView)
        contentView.addSubview(chartLineLabel)
        contentView.addSubview(performanceGraphBar)
        graphView.addSubview(lineGraph)
        showHideView.addSubview(showHideLabel)
        graphView.addSubview(verticalLabel)
        graphView.addSubview(horizontalLabel)
        verticalYView.addSubview(PSITextField)
        showHideView.addSubview(showHideButtonView)
        addLineView.addSubview(addLineTableView)
        horizontalXView.addSubview(GPMTextField)
        showHideButtonView.addSubview(showHideButton)
        stackView.addArrangedSubview(verticalYView)
        stackView.addArrangedSubview(horizontalXView)
        verticalYView.addSubview(verticalMaxTextField)
        verticalYView.addSubview(verticalMinTextField)
        verticalYView.addSubview(verticalMaxTextField)
        verticalYView.addSubview(verticalMinTextField)
        showHideButtonView.addSubview(showHideButtonImage)
        horizontalXView.addSubview(horizontalMaxTextField)
        horizontalXView.addSubview(horizontalMinTextField)
        performanceGraphBar.addSubview(addGraphLineButton)
        performanceGraphBar.addSubview(performanceGraphLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraph.translatesAutoresizingMaskIntoConstraints = false
        showHideView.translatesAutoresizingMaskIntoConstraints = false
        showHideLabel.translatesAutoresizingMaskIntoConstraints = false
        addLineView.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        PSITextField.translatesAutoresizingMaskIntoConstraints = false
        GPMTextField.translatesAutoresizingMaskIntoConstraints = false
        verticalLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalYView.translatesAutoresizingMaskIntoConstraints = false
        chartLineLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalXView.translatesAutoresizingMaskIntoConstraints = false
        horizontalLabel.translatesAutoresizingMaskIntoConstraints = false
        showHideButtonView.translatesAutoresizingMaskIntoConstraints = false
        addLineTableView.translatesAutoresizingMaskIntoConstraints = false
        showHideButtonImage.translatesAutoresizingMaskIntoConstraints = false
        addGraphLineButton.translatesAutoresizingMaskIntoConstraints = false
        performanceGraphBar.translatesAutoresizingMaskIntoConstraints = false
        verticalMaxTextField.translatesAutoresizingMaskIntoConstraints = false
        verticalMinTextField.translatesAutoresizingMaskIntoConstraints = false
        performanceGraphLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalMaxTextField.translatesAutoresizingMaskIntoConstraints = false
        horizontalMinTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
   
        // Constraint to arrange subviews acc. to chartView
        NSLayoutConstraint.activate([
            // ScrollView Constraint
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView Constraint
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // PerformanceGraphBar Constraint
            performanceGraphBar.topAnchor.constraint(equalTo: contentView.topAnchor ,constant: 20),
            performanceGraphBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            performanceGraphBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            performanceGraphBar.heightAnchor.constraint(equalToConstant: 39),
            
            // PerformanceGraphLabel Constraint
            performanceGraphLabel.topAnchor.constraint(equalTo: performanceGraphBar.topAnchor, constant: 4),
            performanceGraphLabel.leadingAnchor.constraint(equalTo: performanceGraphBar.leadingAnchor, constant: 0),
            performanceGraphLabel.widthAnchor.constraint(equalToConstant: 135),
            performanceGraphLabel.heightAnchor.constraint(equalToConstant: 16),
            
            // AddGraphLineButton Constraint
            addGraphLineButton.topAnchor.constraint(equalTo: performanceGraphBar.topAnchor, constant: 0),
            addGraphLineButton.trailingAnchor.constraint(equalTo: performanceGraphBar.trailingAnchor, constant: -8),
            addGraphLineButton.widthAnchor.constraint(equalToConstant: 100),
            addGraphLineButton.heightAnchor.constraint(equalToConstant: 27),
            
            // GraphView Constraint
            graphView.topAnchor.constraint(equalTo: performanceGraphBar.bottomAnchor, constant: 8),
            graphView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            graphView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalToConstant: 272),
            
            // VerticalLabel Constraint
            verticalLabel.topAnchor.constraint(equalTo: lineGraph.bottomAnchor, constant: -180),
            verticalLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor, constant: -60),
            verticalLabel.widthAnchor.constraint(equalToConstant: 150),
            
            // HorizontalLabel Constraint
            horizontalLabel.bottomAnchor.constraint(equalTo: graphView.bottomAnchor, constant: -10),
            horizontalLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor, constant: 170),
            horizontalLabel.widthAnchor.constraint(equalToConstant: 150),
            horizontalLabel.heightAnchor.constraint(equalToConstant: 15),
            
            // LineGraph Constraint
            lineGraph.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 10),
            lineGraph.leadingAnchor.constraint(equalTo: verticalLabel.trailingAnchor, constant: -55),
            lineGraph.trailingAnchor.constraint(equalTo: graphView.trailingAnchor, constant: -10),
            lineGraph.bottomAnchor.constraint(equalTo: horizontalLabel.topAnchor, constant: -10),
            
            // ToggleView Constraint
            showHideView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20),
            showHideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            showHideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            showHideView.heightAnchor.constraint(equalToConstant: 30),
            
            // ToggleLabel Constraint
            showHideLabel.topAnchor.constraint(equalTo: showHideView.topAnchor),
            showHideLabel.leadingAnchor.constraint(equalTo: showHideView.leadingAnchor, constant: 5),
            showHideLabel.widthAnchor.constraint(equalToConstant: 150),
            showHideLabel.bottomAnchor.constraint(equalTo: showHideView.bottomAnchor),
            
            // ShowHideButtonView Constraint
            showHideButtonView.topAnchor.constraint(equalTo: showHideView.topAnchor),
            showHideButtonView.trailingAnchor.constraint(equalTo: showHideView.trailingAnchor, constant: -5),
            showHideButtonView.widthAnchor.constraint(equalToConstant: 65),
            showHideButtonView.bottomAnchor.constraint(equalTo: showHideView.bottomAnchor),
            
            // ShowHideButton Constraint
            showHideButton.topAnchor.constraint(equalTo: showHideButtonView.topAnchor),
            showHideButton.leadingAnchor.constraint(equalTo: showHideButtonView.leadingAnchor),
            showHideButton.widthAnchor.constraint(equalToConstant: 53),
            showHideButton.bottomAnchor.constraint(equalTo: showHideButtonView.bottomAnchor),
            
            // ShowHideButtonImage Constraint
            showHideButtonImage.topAnchor.constraint(equalTo: showHideButtonView.topAnchor, constant: 7),
            showHideButtonImage.leadingAnchor.constraint(equalTo: showHideButton.trailingAnchor),
            showHideButtonImage.trailingAnchor.constraint(equalTo: showHideButtonView.trailingAnchor),
            showHideButtonImage.bottomAnchor.constraint(equalTo: showHideButtonView.bottomAnchor, constant: -7),
            
            // StackView Constraint
            stackView.topAnchor.constraint(equalTo: showHideView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // VerticalYView Constraint
            verticalYView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0),
            verticalYView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalYView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalYView.heightAnchor.constraint(equalToConstant: 100),
            
            // HorizontalXView Constraint
            horizontalXView.topAnchor.constraint(equalTo: verticalYView.bottomAnchor, constant: 10),
            horizontalXView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalXView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalXView.heightAnchor.constraint(equalToConstant: 100),
            
            // PSITextField Constraint
            PSITextField.topAnchor.constraint(equalTo: verticalYView.topAnchor, constant: 14),
            PSITextField.leadingAnchor.constraint(equalTo: verticalYView.leadingAnchor, constant: 13),
            PSITextField.trailingAnchor.constraint(equalTo: verticalMinTextField.leadingAnchor, constant: -7),
            PSITextField.bottomAnchor.constraint(equalTo: verticalYView.bottomAnchor, constant: -14),
            
            // VerticalMinTextField Constraint
            verticalMinTextField.topAnchor.constraint(equalTo: verticalYView.topAnchor, constant: 14),
            verticalMinTextField.leadingAnchor.constraint(equalTo: PSITextField.trailingAnchor, constant: 7),
            verticalMinTextField.trailingAnchor.constraint(equalTo: verticalMaxTextField.leadingAnchor, constant: -7),
            verticalMinTextField.bottomAnchor.constraint(equalTo: verticalYView.bottomAnchor, constant: -14),
            verticalMinTextField.widthAnchor.constraint(equalToConstant: 76),
            
            // VerticalMaxTextField Constraint
            verticalMaxTextField.topAnchor.constraint(equalTo: verticalYView.topAnchor, constant: 14),
            verticalMaxTextField.leadingAnchor.constraint(equalTo: verticalMinTextField.trailingAnchor, constant: 7),
            verticalMaxTextField.trailingAnchor.constraint(equalTo: verticalYView.trailingAnchor, constant: -13),
            verticalMaxTextField.bottomAnchor.constraint(equalTo: verticalYView.bottomAnchor, constant: -14),
            verticalMaxTextField.widthAnchor.constraint(equalToConstant: 76),
            
            // GPMTextField Constraint
            GPMTextField.topAnchor.constraint(equalTo: horizontalXView.topAnchor, constant: 14),
            GPMTextField.leadingAnchor.constraint(equalTo: horizontalXView.leadingAnchor, constant: 13),
            GPMTextField.trailingAnchor.constraint(equalTo: horizontalMinTextField.leadingAnchor, constant: -7),
            GPMTextField.bottomAnchor.constraint(equalTo: horizontalXView.bottomAnchor, constant: -14),
            
            // HorizontalMinTextField Constraint
            horizontalMinTextField.topAnchor.constraint(equalTo: horizontalXView.topAnchor, constant: 14),
            horizontalMinTextField.leadingAnchor.constraint(equalTo: GPMTextField.trailingAnchor, constant: 7),
            horizontalMinTextField.trailingAnchor.constraint(equalTo: horizontalMaxTextField.leadingAnchor, constant: -7),
            horizontalMinTextField.bottomAnchor.constraint(equalTo: horizontalXView.bottomAnchor, constant: -14),
            horizontalMinTextField.widthAnchor.constraint(equalToConstant: 76),
            
            // HorizontalMaxTextField Constraint
            horizontalMaxTextField.topAnchor.constraint(equalTo: horizontalXView.topAnchor, constant: 14),
            horizontalMaxTextField.leadingAnchor.constraint(equalTo: horizontalMinTextField.trailingAnchor, constant: 7),
            horizontalMaxTextField.trailingAnchor.constraint(equalTo: horizontalXView.trailingAnchor, constant: -13),
            horizontalMaxTextField.bottomAnchor.constraint(equalTo: horizontalXView.bottomAnchor, constant: -14),
            horizontalMaxTextField.widthAnchor.constraint(equalToConstant: 76),
            
            // ChartLineLabel Constraint
            chartLineLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            chartLineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            chartLineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chartLineLabel.heightAnchor.constraint(equalToConstant: 17),
            
            // AddLineView Constraint
            addLineView.topAnchor.constraint(equalTo: chartLineLabel.bottomAnchor, constant: 10),
            addLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            addLineView.heightAnchor.constraint(equalToConstant: 400),
            
            // AddLineTableView Constraint
            addLineTableView.topAnchor.constraint(equalTo: addLineView.topAnchor, constant: 15),
            addLineTableView.leadingAnchor.constraint(equalTo: addLineView.leadingAnchor, constant: 18),
            addLineTableView.trailingAnchor.constraint(equalTo: addLineView.trailingAnchor, constant: -18),
            addLineTableView.bottomAnchor.constraint(equalTo: addLineView.bottomAnchor, constant: -5),
        ])
        
        scrollView.contentSize = contentView.frame.size
        
        // Set edit fields visiblity on the basis of its display mode
        if chartDisplayMode == "readonly" {
            yCoordinates = [[0, 50]]
            xCoordinates = [[0, 60]]
            graphLabelData = [["", ""]]
            chartLineLabel.isHidden = true
            addGraphLineButton.isHidden = true
            PSITextField.textField.isUserInteractionEnabled = false
            GPMTextField.textField.isUserInteractionEnabled = false
            verticalMinTextField.textField.isUserInteractionEnabled = false
            verticalMaxTextField.textField.isUserInteractionEnabled = false
            horizontalMinTextField.textField.isUserInteractionEnabled = false
            horizontalMaxTextField.textField.isUserInteractionEnabled = false
        } else {
            if xCoordinates.isEmpty {
                yCoordinates = [[0]]
                xCoordinates = [[0]]
                graphLabelData = [[""]]
            }
            chartLineLabel.isHidden = false
            addGraphLineButton.isHidden = false
            PSITextField.textField.isUserInteractionEnabled = true
            GPMTextField.textField.isUserInteractionEnabled = true
            verticalMinTextField.textField.isUserInteractionEnabled = true
            verticalMaxTextField.textField.isUserInteractionEnabled = true
            horizontalMinTextField.textField.isUserInteractionEnabled = true
            horizontalMaxTextField.textField.isUserInteractionEnabled = true
        }
        
        // addLineTableView Properties
        addLineTableView.delegate = self
        addLineTableView.dataSource = self
        addLineTableView.separatorStyle = .none
        addLineTableView.backgroundColor = .clear
        addLineTableView.showsVerticalScrollIndicator = false
        addLineTableView.register(ChartLineTableViewCell.self, forCellReuseIdentifier: "ChartLineTableViewCell")
        
        // graphView Properties
        graphView.layer.borderWidth = 1.0
        graphView.layer.cornerRadius = 14.0
        graphView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        // Show/Hide toggleView Properties
        showHideLabel.fontSize = 14
        showHideButton.title = "Show"
        showHideLabel.isTextBold = true
        showHideLabel.labelText = "Chart Coordinates"
        showHideButton.isUserInteractionEnabled = false
        showHideButton.titleColor = UIColor(hexString: "#256FFF")
        showHideButtonImage.tintColor = UIColor(hexString: "#256FFF")
        if #available(iOS 13.0, *) {
            showHideButtonImage.image = UIImage(systemName: "chevron.down")
        } else {
            // Fallback on earlier versions
        }
        showHideButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showHideButtonTapped))
        showHideButtonView.addGestureRecognizer(tap)
        
        // StackView Properties
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        // VerticalYView Properties
        verticalYView.layer.borderWidth = 1.0
        verticalYView.layer.cornerRadius = 14.0
        verticalYView.backgroundColor = UIColor(hexString: "#F9F9FB")
        verticalYView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        // HorizontalXView Properties
        horizontalXView.layer.borderWidth = 1.0
        horizontalXView.layer.cornerRadius = 14.0
        horizontalXView.backgroundColor = UIColor(hexString: "#F9F9FB")
        horizontalXView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        // addLineView Properties
        addLineView.layer.borderWidth = 1.0
        addLineView.layer.cornerRadius = 14.0
        chartLineLabel.labelText = "Chart Lines"
        chartLineLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addLineView.backgroundColor = UIColor(hexString: "#F9F9FB")
        addLineView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        // Vertical Y view textField and label properties
        PSITextField.textField.text = "PSI"
        PSITextField.topLabel.labelText = "Vertical (Y)"
        PSITextField.textField.backgroundColor = .white
        verticalMaxTextField.topLabel.labelText = "Max"
        verticalMinTextField.topLabel.labelText = "Min"
        verticalMaxTextField.textField.backgroundColor = .white
        verticalMinTextField.textField.backgroundColor = .white
        PSITextField.textField.font = UIFont.systemFont(ofSize: 14)
        
        // Horizontal X view textField and label properties
        GPMTextField.textField.text = "GPMs"
        GPMTextField.textField.backgroundColor = .white
        horizontalMaxTextField.topLabel.labelText = "Max"
        horizontalMinTextField.topLabel.labelText = "Min"
        GPMTextField.topLabel.labelText = "Horizontal (X)"
        horizontalMaxTextField.textField.backgroundColor = .white
        horizontalMinTextField.textField.backgroundColor = .white
        GPMTextField.textField.font = UIFont.systemFont(ofSize: 14)
        
        // TextField delegate
        PSITextField.textField.delegate = self
        GPMTextField.textField.delegate = self
        verticalMinTextField.textField.delegate = self
        verticalMaxTextField.textField.delegate = self
        horizontalMinTextField.textField.delegate = self
        horizontalMaxTextField.textField.delegate = self
        
        verticalMinTextField.textField.text = "0"
        verticalMaxTextField.textField.text = "100"
        horizontalMinTextField.textField.text = "0"
        horizontalMaxTextField.textField.text = "100"
        verticalMinTextField.textField.keyboardType = .numberPad
        verticalMaxTextField.textField.keyboardType = .numberPad
        horizontalMinTextField.textField.keyboardType = .numberPad
        horizontalMaxTextField.textField.keyboardType = .numberPad
        
        performanceGraphLabel.labelText = "Performance Graph"
        performanceGraphLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        // Graph vertical and horizontal label properties
        verticalLabel.fontSize = 12
        horizontalLabel.fontSize = 12
        verticalLabel.numberOfLines = 0
        verticalLabel.labelText = PSITextField.textField.text
        horizontalLabel.labelText = GPMTextField.textField.text
        verticalLabel.transform = CGAffineTransformMakeRotation(-(.pi/2))
        
        // Set addGraphLineButton
        addGraphLineButton.borderWidth = 1
        addGraphLineButton.cornerRadius = 6
        addGraphLineButton.title = "Add Line +"
        addGraphLineButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addGraphLineButton.borderColor = UIColor(hexString: "#E2E3E7") ?? .lightGray
        addGraphLineButton.addTarget(self, action: #selector(addGraphLineTapped), for: .touchUpInside)
        
        for i in 0...yCoordinates.count - 1 {
            lineGraph.addLine(yCoordinates[i], labels: graphLabelData[i])
        }
        
        verticalYView.isHidden = true
        horizontalXView.isHidden = true
        lineGraph.yMin = Int(verticalMinTextField.textField.text ?? "") ?? 0
        lineGraph.yMax = Int(verticalMaxTextField.textField.text ?? "") ?? 0
        lineGraph.xMin = Int(horizontalMinTextField.textField.text ?? "") ?? 0
        lineGraph.xMax = Int(horizontalMaxTextField.textField.text ?? "") ?? 0
    }
    
    // Action function called when keyboard appears
    @objc func keyboardShown(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardsize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.contentView.frame.height - keyboardsize.height
        let editingTextFieldY = activeTextField?.convert(activeTextField.bounds, to: self.contentView).minY
        if self.contentView.frame.minY >= 0 {
            if editingTextFieldY ?? 0>keyboardY-80 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.contentView.frame = CGRect(x: 0, y: self.contentView.frame.origin.y-((editingTextFieldY ?? 0)-(keyboardY-120)), width: self.contentView.bounds.width, height: self.contentView.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    // Action function called when keyboard dismissed
    @objc func keyboardHidden(notification: Notification) {
        activeTextField = nil
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        }, completion: nil)
    }
    
    // Action function to hide and unhide horizontal and vertical graph axis value
    @objc func showHideButtonTapped() {
        let isHidden = verticalYView.isHidden
        
        UIView.animate(withDuration: 0.3) {
            self.verticalYView.isHidden = !isHidden
            self.horizontalXView.isHidden = !isHidden
            self.showHideButton.title = isHidden ? "Hide" : "Show"
            if #available(iOS 13.0, *) {
                let imageName = isHidden ? "chevron.up" : "chevron.down"
                self.showHideButtonImage.image = UIImage(systemName: imageName)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    // Action function for addGraphButton
    @objc func addGraphLineTapped() {
        if yCoordinates.count < 12 {
            yCoordinates.append([0])
            xCoordinates.append([0])
            graphLabelData.append([""])
            addPointButtonIndexPath = xCoordinates.count - 1
            for i in 0...yCoordinates.count - 1 {
                lineGraph.addLine(yCoordinates[i], labels: graphLabelData[i])
                addLineTableView.scrollToBottom()
                addLineTableView.reloadData()
            }
        }
    }
    
    // TextField delegate method called when editing stops to update max and min value of horizontal and vertical axis
    public func textFieldDidEndEditing(_ textField: UITextField) {
        verticalLabel.labelText = PSITextField.textField.text
        horizontalLabel.labelText = GPMTextField.textField.text
        lineGraph.yMin = Int(verticalMinTextField.textField.text ?? "") ?? 0
        lineGraph.yMax = Int(verticalMaxTextField.textField.text ?? "") ?? 0
        lineGraph.xMin = Int(horizontalMinTextField.textField.text ?? "") ?? 0
        lineGraph.xMax = Int(horizontalMaxTextField.textField.text ?? "") ?? 0
        lineGraph.setNeedsDisplay()
    }
}

// MARK: TableView extention with tableView delegate methods
extension ChartView: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView delegate method to give tableView section
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: TableView delegate method to give tableView rows
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yCoordinates.count
    }
    
    // MARK: TableView delegate function to set cell inside tableView
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartLineTableViewCell", for: indexPath) as! ChartLineTableViewCell
        tableView.rowHeight = 360
        cell.textFieldDelegate = self
        cell.contentView.backgroundColor = UIColor(hexString: "#F9F9FB")
        
        cell.label.textColor = lineGraph.colors[indexPath.row]
        cell.image.backgroundColor = lineGraph.colors[indexPath.row]
        cell.label.labelText = "Line #\(indexPath.row + 1)"
        cell.view.layer.borderColor = lineGraph.colors[indexPath.row]?.cgColor
        
        cell.removeLabel.tag = indexPath.row
        cell.addPointButton.tag = indexPath.row
        cell.removeLabel.addTarget(self, action: #selector(removeLineTapped), for: .touchUpInside)
        cell.addPointButton.addTarget(self, action: #selector(addPointTapped), for: .touchUpInside)
        
        updateLineGraphAndCell(cell, at: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.setupCell()
        return cell
    }
    
    // MARK: TableView delegate function called when cell is selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? ChartLineTableViewCell
        cell?.contentView.backgroundColor = UIColor(hexString: "#F9F9FB")
        addPointButtonIndexPath = indexPath.row
    }
    
    // MARK: Function to get the indexPath of the tableViewCell when cell scrolling stops
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == addLineTableView {
            // Get the center point of the table view's visible rect
            let center = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
                                 y: scrollView.contentOffset.y + scrollView.bounds.height / 2)
            
            if let indexPath = addLineTableView.indexPathForRow(at: center) {
                let cell = addLineTableView.cellForRow(at: indexPath) as? ChartLineTableViewCell
                addPointButtonIndexPath = indexPath.row
                updateLineGraphAndCell(cell!, at: indexPath)
                cell?.pointsTableView.reloadData()
            }
        }
    }
    
    // MARK: TextField delegate method for textField selection
    func textFieldCellDidSelect(_ cell: UITableViewCell) {}
    
    // Action function for addPointButton inside tableView cell
    @objc func addPointTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let cell = addLineTableView.cellForRow(at: indexPath) as? ChartLineTableViewCell else {
            return
        }
        
        addPointButtonIndexPath = indexPath.row
        yCoordinates[indexPath.row].append(0)
        xCoordinates[indexPath.row].append(0)
        graphLabelData[indexPath.row].append("")
        cell.pointsTableView.scrollToBottom()
        updateLineGraphAndCell(cell, at: indexPath)
    }
    
    // Action function for removeButton to remove line
    @objc func removeLineTapped(_ sender: UIButton) {
        if yCoordinates.count > 1 {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            yCoordinates.remove(at: sender.tag)
            xCoordinates.remove(at: sender.tag)
            graphLabelData.remove(at: sender.tag)
            addLineTableView.deleteRows(at: [indexPath], with: .fade)
            addLineTableView.reloadData()
            
            if addPointButtonIndexPath == xCoordinates.count {
                addPointButtonIndexPath -= 1
                let indexPath2 = IndexPath(row: addPointButtonIndexPath, section: 0)
                if let cell = addLineTableView.cellForRow(at: indexPath2) as? ChartLineTableViewCell {
                    updateLineGraphAndCell(cell, at: indexPath2)
                }
            } else {
                addPointButtonIndexPath = sender.tag
                let indexPath2 = IndexPath(row: addPointButtonIndexPath, section: 0)
                if let cell = addLineTableView.cellForRow(at: indexPath2) as? ChartLineTableViewCell {
                    updateLineGraphAndCell(cell, at: indexPath2)
                }
            }
        }
    }
    
    // Function to update line of graph and tableViewCell
    func updateLineGraphAndCell(_ cell: ChartLineTableViewCell, at indexPath: IndexPath) {
        let graphYPointsData = yCoordinates[indexPath.row]
        cell.configureY(with: graphYPointsData, at: indexPath)
        let graphXPointsData = xCoordinates[indexPath.row]
        cell.configureX(with: graphXPointsData, at: indexPath)
        graphTextData = graphLabelData[indexPath.row]
        lineGraph.setNeedsDisplay()
    }
}
