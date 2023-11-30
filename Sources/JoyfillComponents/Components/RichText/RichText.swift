import Foundation
import UIKit

public var richTextIndexPath = Int()
open class RichText: UIView {
    
    public var textLabel = Label()
    public var labelTextData = String()
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    func setupView() {
        // SubViews
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        do {
            // Parse JSON data
            let data = richTextValue[richTextIndexPath].data(using: .utf8)
            let richTextJoyDocData = try JSONDecoder().decode(RichTextData.self, from: data!)
            let blocks = richTextJoyDocData.blocks
            var attributedText = NSMutableAttributedString()
            let attributedTextArray = NSMutableAttributedString()
            var inlineStyleValue = String()
            var inlineStyleKey = String()
            
            for block in blocks {
                if let text = block.text as NSString? {
                    let attributes: [NSAttributedString.Key: Any] = [:]
                    attributedText = NSMutableAttributedString(string: text as String + "\n")
                    for inlineStyle in block.inlineStyleRanges {
                        let rangeStart = inlineStyle.offset
                        let rangeLength = inlineStyle.length
                        let rangeEnd = min(rangeStart + rangeLength, text.length)
                        let range = NSRange(location: rangeStart, length: rangeEnd - rangeStart)
                        
                        // Separated InlineStyleRange by "-"
                        let separatedInlineStyleValues = inlineStyle.style.components(separatedBy: "-")
                        if separatedInlineStyleValues.count == 2 {
                            inlineStyleValue = separatedInlineStyleValues[1]
                            inlineStyleKey = separatedInlineStyleValues[0]
                            
                            // Set fontsize and color to the text
                            if inlineStyleKey == "fontsize" {
                                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: CGFloat(Int(inlineStyleValue) ?? 0)), range: range)
                            } else if inlineStyleKey == "color" {
                                if inlineStyleValue.hasPrefix("#") {
                                    attributedText.addAttribute(.foregroundColor, value: UIColor(hexString: inlineStyleValue ) as Any, range: range)
                                    attributedText.addAttribute(.underlineColor, value: UIColor(hexString: inlineStyleValue ) as Any, range: range)
                                } else {
                                    let hexValue = rgbToHex(rgbString: inlineStyleValue)
                                    attributedText.addAttribute(.foregroundColor, value: UIColor(hexString: hexValue ?? "") as Any, range: range)
                                    attributedText.addAttribute(.underlineColor, value: UIColor(hexString: hexValue ?? "") as Any, range: range)
                                }
                            }
                        }
                        
                        switch inlineStyle.style {
                        case "BOLD":
                            let existingFont = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 17)
                            let boldFont = UIFont.boldSystemFont(ofSize: existingFont.pointSize)
                            attributedText.addAttribute(.font, value: boldFont, range: range)
                        case "ITALIC":
                            let existingFont = attributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 17)
                            if existingFont.isBold {
                                if let italicFontDescriptor = existingFont.fontDescriptor.withSymbolicTraits([.traitItalic, .traitBold]) {
                                    let italicBoldFont = UIFont(descriptor: italicFontDescriptor, size: existingFont.pointSize)
                                    attributedText.addAttribute(.font, value: italicBoldFont, range: range)
                                } else {
                                    let italicFont = UIFont.italicSystemFont(ofSize: existingFont.pointSize)
                                    attributedText.addAttribute(.font, value: italicFont, range: range)
                                }
                            } else {
                                let italicFont = UIFont.italicSystemFont(ofSize: existingFont.pointSize)
                                attributedText.addAttribute(.font, value: italicFont, range: range)
                            }
                        case "UNDERLINE":
                            attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                        default:
                            break
                        }
                    }
                    attributedTextArray.append(attributedText)
                }
            }
            textLabel.numberOfLines = 0
            textLabel.attributedText = attributedTextArray
            labelTextData = textLabel.text ?? ""
            
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
}
