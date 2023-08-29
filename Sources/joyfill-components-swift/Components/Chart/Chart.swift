import Foundation
import UIKit

// Global variables
public var lineGraph = LineChart()
public var yPointsData: [CGFloat] = []
public var xPointsData: [CGFloat] = []
public var chartDisplayMode = String()
public var graphTextData: [String] = []
public var yCoordinates = [[CGFloat]]()
public var xCoordinates = [[CGFloat]]()
public var activeTextField: UITextField!
public var graphLabelData = [[String]]()
public var addPointButtonIndexPath = Int()

public class Chart: UIView, UIViewControllerTransitioningDelegate {
    
    public var viewMore = UIView()
    public var graphView = UIView()
    public var lineGraph = LineChart()
    public var verticalLabel = Label()
    public var viewMoreLabel = Label()
    public var horizontalLabel = Label()
    public var viewMoreArrow = ImageView()
    public var performanceGraphBar = UIView()
    public var performanceGraphLabel = Label()
    public var toolTipIconButton = UIButton()
    public var toolTipTitle = String()
    public var toolTipDescription = String()
    
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
    
    func setupUI() {
        // SubViews
        addSubview(viewMore)
        addSubview(graphView)
        addSubview(performanceGraphBar)
        addSubview(toolTipIconButton)
        graphView.addSubview(lineGraph)
        viewMore.addSubview(viewMoreLabel)
        viewMore.addSubview(viewMoreArrow)
        graphView.addSubview(verticalLabel)
        graphView.addSubview(horizontalLabel)
        performanceGraphBar.addSubview(performanceGraphLabel)
        
        viewMore.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        lineGraph.translatesAutoresizingMaskIntoConstraints = false
        verticalLabel.translatesAutoresizingMaskIntoConstraints = false
        viewMoreLabel.translatesAutoresizingMaskIntoConstraints = false
        viewMoreArrow.translatesAutoresizingMaskIntoConstraints = false
        horizontalLabel.translatesAutoresizingMaskIntoConstraints = false
        performanceGraphBar.translatesAutoresizingMaskIntoConstraints = false
        performanceGraphLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to imageView
        NSLayoutConstraint.activate([
            // PageView Constraint
            performanceGraphBar.topAnchor.constraint(equalTo: topAnchor ,constant: 20),
            performanceGraphBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            performanceGraphBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            performanceGraphBar.heightAnchor.constraint(equalToConstant: 39),
            
            // PageLabel Constraint
            performanceGraphLabel.topAnchor.constraint(equalTo: performanceGraphBar.topAnchor, constant: 4),
            performanceGraphLabel.leadingAnchor.constraint(equalTo: performanceGraphBar.leadingAnchor, constant: 0),
            performanceGraphLabel.heightAnchor.constraint(equalToConstant: 15),
            
            //TooltipIconButton
            toolTipIconButton.topAnchor.constraint(equalTo: performanceGraphBar.topAnchor, constant: 4),
            toolTipIconButton.leadingAnchor.constraint(equalTo: performanceGraphLabel.trailingAnchor, constant: 5),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            // GraphView Constraint
            graphView.topAnchor.constraint(equalTo: performanceGraphBar.bottomAnchor, constant: 0),
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
        
        performanceGraphLabel.labelText = "Performance Graph"
        performanceGraphLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        verticalLabel.fontSize = 12
        verticalLabel.numberOfLines = 0
        verticalLabel.labelText = "Vertical"
        verticalLabel.textAlignment = .center
        verticalLabel.transform = CGAffineTransformMakeRotation(-(.pi/2))
        
        horizontalLabel.fontSize = 12
        horizontalLabel.textAlignment = .center
        horizontalLabel.labelText = "Horizontal"
        
        if xCoordinates.isEmpty {
            yCoordinates = [[0, 50]]
            xCoordinates = [[0, 60]]
            graphLabelData = [["", ""]]
        }
        for i in 0...yCoordinates.count - 1 {
            lineGraph.addLine(yCoordinates[i], labels: graphLabelData[i])
        }
        
        lineGraph.yMin = 0
        lineGraph.yMax = 100
        lineGraph.xMin = 0
        lineGraph.xMax = 100
        
        toolTipIconButton.setImage(UIImage(named: "information"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
    }
    
    // Action function for viewMore
    @objc func viewMoreTapped() {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                let newViewController = ChartView()
                newViewController.transitioningDelegate = self
                viewController.present(newViewController, animated: true, completion: nil)
                break
            }
        }
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}
