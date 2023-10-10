import Foundation
import UIKit

// Global variables
public var chartDisplayMode = String()
public var yPointsData = [[CGFloat]]()
public var xPointsData = [[CGFloat]]()
public var activeTextField: UITextField!
public var yCoordinates = [[[CGFloat]]]()
public var chartPointsId = [[[String]]]()
public var xCoordinates = [[[CGFloat]]]()
public var graphLabelData = [[[String]]]()
public var addPointButtonIndexPath = Int()

protocol saveChartFieldValue {
    func handleLineCreate(line: Int)
    func handleLineChange(line: Int, indexPath: Int)
    func handleLineDelete(line: Int, indexPath: Int)
    func handleXMaxCoordinates(line: Int, newValue: Int)
    func handleYMaxCoordinates(line: Int, newValue: Int)
    func handleXMinCoordinates(line: Int, newValue: Int)
    func handleYMinCoordinates(line: Int, newValue: Int)
    func handlePointCreate(rowId: String, line: Int, indexPath: Int)
    func handleLineData(rowId: String, line: Int, indexPath: Int, newYValue: Int, newXValue: Int, newLabelValue: String)
}

public class Chart: UIView, UIViewControllerTransitioningDelegate {
    
    public var viewMore = UIView()
    public var graphView = UIView()
    public var lineGraph = LineChart()
    public var verticalLabel = Label()
    public var viewMoreLabel = Label()
    public var horizontalLabel = Label()
    public var viewMoreArrow = ImageView()
    public var titleLabel = Label()
    public var toolTipIconButton = UIButton()
    public var toolTipTitle = String()
    public var toolTipDescription = String()
    
    var index = Int()
    var saveDelegate: saveChartFieldValue? = nil
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    public func tooltipVisible(bool: Bool) {
        if bool {
            toolTipIconButton.isHidden = false
        } else {
            toolTipIconButton.isHidden = true
        }
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        setupUI()
        lineGraph.setNeedsDisplay()
    }
    
    func setupUI() {
        // SubViews
        if #available(iOS 13.0, *) {
         self.overrideUserInterfaceStyle = .light
        }
        addSubview(viewMore)
        addSubview(graphView)
        addSubview(toolTipIconButton)
        addSubview(titleLabel)
        graphView.addSubview(lineGraph)
        viewMore.addSubview(viewMoreLabel)
        viewMore.addSubview(viewMoreArrow)
        graphView.addSubview(verticalLabel)
        graphView.addSubview(horizontalLabel)
        
        viewMore.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraph.translatesAutoresizingMaskIntoConstraints = false
        verticalLabel.translatesAutoresizingMaskIntoConstraints = false
        viewMoreLabel.translatesAutoresizingMaskIntoConstraints = false
        viewMoreArrow.translatesAutoresizingMaskIntoConstraints = false
        horizontalLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to imageView
        NSLayoutConstraint.activate([
            // TitleLabel Constraint
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: toolTipIconButton.leadingAnchor, constant: -5),
            
            //TooltipIconButton
            toolTipIconButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            toolTipIconButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            // GraphView Constraint
            graphView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
            graphView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            graphView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            graphView.heightAnchor.constraint(equalToConstant: 272),
            
            // VerticalLabel Constraint
            verticalLabel.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 10),
            verticalLabel.bottomAnchor.constraint(equalTo: graphView.bottomAnchor, constant: -10),
            verticalLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor, constant: -60),
            verticalLabel.widthAnchor.constraint(equalToConstant: 150),
            
            // HorizontalLabel Constraint
            horizontalLabel.bottomAnchor.constraint(equalTo: graphView.bottomAnchor, constant: -10),
            horizontalLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor, constant: 10),
            horizontalLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor, constant: -10),
            horizontalLabel.heightAnchor.constraint(equalToConstant: 15),
            
            // LineGraph Constraint
            lineGraph.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 10),
            lineGraph.leadingAnchor.constraint(equalTo: verticalLabel.trailingAnchor, constant: -55),
            lineGraph.trailingAnchor.constraint(equalTo: graphView.trailingAnchor, constant: -10),
            lineGraph.bottomAnchor.constraint(equalTo: horizontalLabel.topAnchor, constant: -10),
            
            // ViewMore Constraint
            viewMore.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 10),
            viewMore.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            viewMore.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            viewMore.heightAnchor.constraint(equalToConstant: 30),
            
            // ViewMoreLabel Constraint
            viewMoreLabel.topAnchor.constraint(equalTo: viewMore.topAnchor),
            viewMoreLabel.leadingAnchor.constraint(equalTo: viewMore.leadingAnchor),
            viewMoreLabel.trailingAnchor.constraint(equalTo: viewMore.trailingAnchor, constant: -30),
            viewMoreLabel.bottomAnchor.constraint(equalTo: viewMore.bottomAnchor),
            
            // ViewMoreArrow Constraint
            viewMoreArrow.topAnchor.constraint(equalTo: viewMore.topAnchor, constant: 7),
            viewMoreArrow.leadingAnchor.constraint(equalTo: viewMoreLabel.trailingAnchor, constant: 10),
            viewMoreArrow.trailingAnchor.constraint(equalTo: viewMore.trailingAnchor,constant: -10),
            viewMoreArrow.bottomAnchor.constraint(equalTo: viewMore.bottomAnchor, constant: -7)
        ])
        
        // graphView Properties
        graphView.layer.borderWidth = 1.0
        graphView.layer.cornerRadius = 14.0
        graphView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        // viewMore Properties
        viewMore.layer.borderWidth = 1.0
        viewMore.layer.cornerRadius = 6.0
        viewMore.layer.borderColor = UIColor(hexString: "#E2E3E7")?.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewMoreTapped))
        viewMore.addGestureRecognizer(tap)
        viewMore.isUserInteractionEnabled = true
        
        if #available(iOS 13.0, *) {
            viewMoreArrow.image = UIImage(systemName: "chevron.right")
        } else {
            // Fallback on earlier versions
        }
        viewMoreArrow.tintColor = .black
        
        viewMoreLabel.fontSize = 14
        viewMoreLabel.labelText = "View More"
        viewMoreLabel.textAlignment = .center
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        verticalLabel.fontSize = 12
        verticalLabel.numberOfLines = 0
        verticalLabel.labelText = "Vertical"
        verticalLabel.textAlignment = .center
        verticalLabel.transform = CGAffineTransformMakeRotation(-(.pi/2))
        
        horizontalLabel.fontSize = 12
        horizontalLabel.textAlignment = .center
        horizontalLabel.labelText = "Horizontal"
        
        if xCoordinates[index].isEmpty != true {
            for i in 0...yCoordinates[index].count - 1 {
                lineGraph.addLine(yCoordinates[index][i], labels: graphLabelData[index][i])
            }
        }
        
        lineGraph.yMin = 0
        lineGraph.yMax = 100
        lineGraph.xMin = 0
        lineGraph.xMax = 100
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
    }
    
    // Action function for viewMore
    @objc func viewMoreTapped() {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                let newViewController = ChartView()
                newViewController.index = self.index
                newViewController.lineGraph.index = self.index
                newViewController.saveDelegate = self.saveDelegate
                newViewController.transitioningDelegate = self
                newViewController.modalPresentationStyle = .fullScreen
                newViewController.modalTransitionStyle = .crossDissolve
                newViewController.labelTitle = titleLabel.labelText ?? ""
                viewController.present(newViewController, animated: true, completion: nil)
                break
            }
        }
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}
