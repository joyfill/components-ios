import Foundation
import UIKit

public class DropDown : UIView {
    
    public var titleLbl = UILabel()
    public var textField = DropDownTestField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 20), height: 100))
        self.setupUI()
    }
    
    func setupUI () {
        titleLbl.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 20)
        textField.frame = CGRect(x: 0, y: titleLbl.frame.maxY + 5, width: bounds.size.width, height: 50)
        addSubview(titleLbl)
        addSubview(textField)
    }
    
    //Drop Down CornerRadius
    @IBInspectable
    open var DropDownCornerRadius: CGFloat = 5 {
        didSet {
            textField.layer.cornerRadius = DropDownCornerRadius
        }
    }
    
    @IBInspectable
    open var DropDownBorderWidth: CGFloat = 1 {
        didSet {
            textField.layer.borderWidth = DropDownBorderWidth
        }
    }
    
    @IBInspectable
    open var DropDownBorderColor: UIColor = UIColor.lightGray {
        didSet {
            textField.layer.borderColor = DropDownBorderColor.cgColor
        }
    }
    
    //DateTime View backgroundColor
    @IBInspectable
    open var DateTimebackgroundColor: UIColor? {
        didSet {
            textField.layer.backgroundColor = DateTimebackgroundColor?.cgColor
        }
    }
    
    //Title
    @IBInspectable
    public var TitleBackgroundColor: UIColor? {
        didSet {
            titleLbl.layer.backgroundColor = TitleBackgroundColor?.cgColor
        }
    }
    
    @IBInspectable
    public var TitleText : String? {
        didSet {
            titleLbl.text = TitleText
        }
    }
    
    @IBInspectable
    public var TitleFont : UIFont? {
        didSet {
            titleLbl.font = TitleFont
        }
    }
    
    @IBInspectable
    public var TitleTextColor : UIColor = .black {
        didSet {
            titleLbl.textColor = TitleTextColor
        }
    }
    
    @IBInspectable
    public var optionDataArray = [String](){
        didSet{
            textField.optionArray = optionDataArray
        }
    }
    
    @IBInspectable
    public var optionIds = [Int](){
        didSet{
            textField.optionIds = optionIds
        }
    }
    
    @IBInspectable
    public var checkMarkEnabled : Bool = true {
        didSet{
            textField.checkMarkEnabled = checkMarkEnabled
        }
    }
    
    @IBInspectable
    public var ArrowSize : CGFloat = 15 {
        didSet {
            textField.arrowSize = ArrowSize
        }
    }
}

public class DropDownTestField: UITextField {
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.delegate = self
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        self.delegate = self
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.setupUI()
        self.delegate = self
        self.backgroundColor(color: UIColor.white)
        self.cornerRadius(corner: 5)
        self.borderWidth(border: 1)
        self.borderColor(borderClr: UIColor.lightGray.cgColor)
        
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 30)
    
    // MARK: - UITextField Layout Overrides
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    public func backgroundColor(color : UIColor) {
        self.backgroundColor = color
    }
    
    public func cornerRadius(corner : CGFloat) {
        self.layer.cornerRadius = corner
    }
    
    public func borderWidth(border : CGFloat) {
        self.layer.borderWidth = border
    }
    
    public func borderColor(borderClr : CGColor) {
        self.layer.borderColor = borderClr
    }
    
    var arrow: Arrow!
    var table: UITableView!
    var shadow: UIView!
    public  var selectedIndex: Int?
    
    @IBInspectable public var rowHeight: CGFloat = 30
    @IBInspectable public var rowBackgroundColor: UIColor = .white
    @IBInspectable public var selectedRowColor: UIColor = .cyan
    @IBInspectable public var hideOptionsWhenSelect = true
    
    @IBInspectable  public var isSearchEnable: Bool = false {
        didSet{
            addGesture()
        }
    }
    
    @IBInspectable public var listHeight: CGFloat = 150{
        didSet {}
    }
    
    //Variables
    fileprivate  var tableheightX: CGFloat = 100
    fileprivate  var dataArray = [String]()
    fileprivate  var parentController:UIViewController?
    fileprivate  var pointToParent = CGPoint(x: 0, y: 0)
    fileprivate var backgroundView = UIView()
    fileprivate var keyboardHeight:CGFloat = 0
    
    public var rowTextColor: UIColor = .black
    
    public var optionArray = [String]() {
        didSet {
            self.dataArray = self.optionArray
        }
    }
    
    public var optionIds : [Int]?
    public var optionValue : String?
    var searchText = String() {
        didSet {
            if searchText == "" {
                self.dataArray = self.optionArray
            } else {
                dataArray = optionArray.filter {
                    searchFilter(text: $0, searchText: searchText)
                }
            }
            reSizeTable()
            selectedIndex = nil
            self.table.reloadData()
        }
    }
    
    @IBInspectable public var arrowSize: CGFloat = 15 {
        didSet {
            let center =  arrow.superview!.center
            arrow.frame = CGRect(x: center.x - arrowSize/2, y: center.y - arrowSize/2, width: arrowSize, height: arrowSize)
        }
    }
    
    @IBInspectable public var arrowColor: UIColor = .black {
        didSet {
            arrow.arrowColor = arrowColor
        }
    }
    
    @IBInspectable public var checkMarkEnabled: Bool = true {
        didSet {}
    }
    
    @IBInspectable public var handleKeyboard: Bool = true {
        didSet {}
    }
    
    //MARK: Closures
    fileprivate var didSelectCompletion: (String, Int ,Int) -> () = {selectedText, index , id  in }
    fileprivate var TableWillAppearCompletion: () -> () = { }
    fileprivate var TableDidAppearCompletion: () -> () = { }
    fileprivate var TableWillDisappearCompletion: () -> () = { }
    fileprivate var TableDidDisappearCompletion: () -> () = { }
    
    func setupUI () {
        _ = self.frame.height
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30, height: 30))
        self.rightView = rightView
        self.rightViewMode = .always
        let arrowContainerView = UIView(frame: CGRect(x: self.bounds.maxX + 170, y: 0.0, width: 30, height: 30))
        self.rightView?.addSubview(arrowContainerView)
        let center = arrowContainerView.center
        arrow = Arrow(origin: CGPoint(x: center.x - arrowSize/2,y: center.y - arrowSize/2),size: arrowSize  )
        arrowContainerView.addSubview(arrow)
        self.backgroundView = UIView(frame: .zero)
        self.backgroundView.backgroundColor = .clear
        addGesture()
        if isSearchEnable && handleKeyboard{
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
                if self.isFirstResponder{
                    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
                    let keyboardFrame:NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    self.keyboardHeight = keyboardRectangle.height
                    if !self.isSelected{
                        self.showList()
                    }
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
                if self.isFirstResponder{
                    self.keyboardHeight = 0
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func addGesture (){
        let gesture =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        if isSearchEnable{
            self.rightView?.addGestureRecognizer(gesture)
        }else{
            self.addGestureRecognizer(gesture)
        }
        let gesture2 =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        self.backgroundView.addGestureRecognizer(gesture2)
    }
    
    func getConvertedPoint(_ targetView: UIView, baseView: UIView?)->CGPoint{
        var pnt = targetView.frame.origin
        if nil == targetView.superview{
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView{
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview{
                break
            }else{
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
    
    public func showList() {
        parentController = self.parentViewController
        backgroundView.frame = parentController?.view.frame ?? backgroundView.frame
        pointToParent = getConvertedPoint(self, baseView: parentController?.view)
        parentController?.view.insertSubview(backgroundView, aboveSubview: self)
        TableWillAppearCompletion()
        
        if listHeight > rowHeight * CGFloat(dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        } else {
            self.tableheightX = listHeight
        }
        
        table = UITableView(frame: CGRect(x: pointToParent.x ,
                                          y: pointToParent.y + self.frame.height ,
                                          width: self.frame.width,
                                          height: self.frame.height))
        shadow = UIView(frame: table.frame)
        shadow.backgroundColor = .clear
        
        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        table.separatorStyle = .none
        table.layer.cornerRadius = 3
        table.backgroundColor = rowBackgroundColor
        table.rowHeight = rowHeight
        parentController?.view.addSubview(shadow)
        parentController?.view.addSubview(table)
        self.isSelected = true
        let height = (self.parentController?.view.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 5)
        var y = self.pointToParent.y+self.frame.height+5
        
        if height < (keyboardHeight+tableheightX) {
            y = self.pointToParent.y - tableheightX
        }
        
        UIView.animate(withDuration: 0.9,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            
            self.table.frame = CGRect(x: self.pointToParent.x,
                                      y: y,
                                      width: self.frame.width,
                                      height: self.tableheightX)
            self.table.alpha = 1
            self.shadow.frame = self.table.frame
            self.shadow.dropShadow()
        },
                       completion: { (finish) -> Void in
            self.layoutIfNeeded()
            
        })
    }
    
    public func hideList() {
        TableWillDisappearCompletion()
        UIView.animate(withDuration: 1.0,
                       delay: 0.4,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            self.table.frame = CGRect(x: self.pointToParent.x,
                                      y: self.pointToParent.y+self.frame.height,
                                      width: self.frame.width,
                                      height: 0)
            self.shadow.alpha = 0
            self.shadow.frame = self.table.frame
            self.arrow.position = .down
        },
                       completion: { (didFinish) -> Void in
            
            self.shadow.removeFromSuperview()
            self.table.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            self.isSelected = false
            self.TableDidDisappearCompletion()
        })
    }
    
    @objc public func touchAction() {
        
        isSelected ?  hideList() : showList()
    }
    
    func reSizeTable() {
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        } else {
            self.tableheightX = listHeight
        }
        
        let height = (self.parentController?.view.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 5)
        var y = self.pointToParent.y+self.frame.height + 5
        
        if height < (keyboardHeight+tableheightX) {
            y = self.pointToParent.y - tableheightX
        }
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            self.table.frame = CGRect(x: self.pointToParent.x,
                                      y: y,
                                      width: self.frame.width,
                                      height: self.tableheightX)
            self.shadow.frame = self.table.frame
            self.shadow.dropShadow()
            
        },
                       completion: { (didFinish) -> Void in
            //  self.shadow.layer.shadowPath = UIBezierPath(rect: self.table.bounds).cgPath
            self.layoutIfNeeded()
            
        })
    }
    
    open func searchFilter(text: String, searchText: String) -> Bool {
        return text.range(of: searchText, options: .caseInsensitive) != nil
    }
    
    //MARK: Actions Methods
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int , _ id:Int ) -> ()) {
        didSelectCompletion = completion
    }
    
    public func listWillAppear(completion: @escaping () -> ()) {
        TableWillAppearCompletion = completion
    }
    
    public func listDidAppear(completion: @escaping () -> ()) {
        TableDidAppearCompletion = completion
    }
    
    public func listWillDisappear(completion: @escaping () -> ()) {
        TableWillDisappearCompletion = completion
    }
    
    public func listDidDisappear(completion: @escaping () -> ()) {
        TableDidDisappearCompletion = completion
    }
}

// MARK: UITextFieldDelegate
extension DropDownTestField : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        superview?.endEditing(true)
        return false
    }
    
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        self.dataArray = self.optionArray
        touchAction()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isSearchEnable
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            self.searchText = self.text! + string
        } else {
            let subText = self.text?.dropLast()
            self.searchText = String(subText!)
        }
        
        if !isSelected {
            showList()
        }
        return true;
    }
}

// MARK: UITableViewDataSource
extension DropDownTestField: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DropDownCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        if indexPath.row != selectedIndex{
            cell!.backgroundColor = rowBackgroundColor
        }else {
            cell?.backgroundColor = selectedRowColor
        }
        //        let dataArray = dataArray[indexPath.row]
        //        cell!.textLabel!.text = dataArray["value"] as? String ?? ""
        cell!.textLabel!.text = "\(dataArray[indexPath.row])"
        cell!.accessoryType = (indexPath.row == selectedIndex) && checkMarkEnabled  ? .checkmark : .none
        cell!.selectionStyle = .none
        cell?.textLabel?.font = self.font
        cell?.textLabel?.textAlignment = self.textAlignment
        cell?.textLabel?.textColor = rowTextColor
        return cell!
    }
    
}

//MARK: UITableViewDelegate
extension DropDownTestField: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = (indexPath as NSIndexPath).row
        let selectedText = dataArray[selectedIndex!]
        tableView.cellForRow(at: indexPath)?.alpha = 0
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
            tableView.cellForRow(at: indexPath)?.alpha = 1.0
            tableView.cellForRow(at: indexPath)?.backgroundColor = self.selectedRowColor
        } ,
                       completion: { (didFinish) -> Void in
            self.text = "\(selectedText)"
            tableView.reloadData()
        })
        
        if hideOptionsWhenSelect {
            touchAction()
            self.endEditing(true)
        }
    }
}

// MARK: Arrow
enum Position {
    case left
    case down
    case right
    case up
}

class Arrow: UIView {
    let shapeLayer = CAShapeLayer()
    
    var arrowColor: UIColor = .black {
        didSet {
            shapeLayer.fillColor = arrowColor.cgColor
        }
    }
    
    var position: Position = .down {
        didSet {
            switch position {
            case .left:
                transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                break
                
            case .down:
                transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
                break
                
            case .right:
                transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                break
                
            case .up:
                transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                break
            }
        }
    }
    
    init(origin: CGPoint, size: CGFloat) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Get size
        let size = layer.frame.width
        
        // Create path
        let bezierPath = UIBezierPath()
        
        // Draw points
        let qSize = size / 4
        bezierPath.move(to: CGPoint(x: 0, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size / 2, y: qSize * 3))
        bezierPath.addLine(to: CGPoint(x: 0, y: qSize))
        bezierPath.close()
        
        // Mask to path
        shapeLayer.path = bezierPath.cgPath
        
        if #available(iOS 12.0, *) {
            self.layer.addSublayer(shapeLayer)
        } else {
            layer.mask = shapeLayer
        }
    }
}
