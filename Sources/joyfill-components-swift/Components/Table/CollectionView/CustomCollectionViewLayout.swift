import Foundation
import UIKit

// Custom layout for collectionView
class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    
    var CELL_HEIGHT = 50.0
    var CELL_WIDTH = 200.0
    let STATUS_BAR = UIApplication.shared.statusBarFrame.height
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        // Cycle through each section of the data source.
        if (collectionView?.numberOfSections)! > 0 {
            for section in 0...collectionView!.numberOfSections-1 {
                
                // Cycle through each item in the section.
                if (collectionView?.numberOfItems(inSection: section))! > 0 {
                    for item in 0...collectionView!.numberOfItems(inSection: section)-1 {
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = NSIndexPath.init(item: item, section: section)
                        let xPos = Double(item) * CELL_WIDTH
                        let yPos = Double(section) * CELL_HEIGHT
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                        
                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        cellAttrsDictionary[cellIndex as IndexPath] = cellAttributes
                    }
                }
            }
        }
        let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
        let contentHeight = Double(collectionView!.numberOfSections) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

// Class to create 2 way scrollView for collectionView
class TwoWayScrollingCollectionViewLayout: UICollectionViewFlowLayout {

    var stickyRowsCount = 0 {
        didSet {
            invalidateLayout()
        }
    }

    var stickyColumnsCount = 0 {
        didSet {
            invalidateLayout()
        }
    }

    private var allAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var contentSize = CGSize.zero

    func isItemSticky(at indexPath: IndexPath) -> Bool {
        return indexPath.item < stickyColumnsCount || indexPath.section < stickyRowsCount
    }

    // MARK: - Collection view flow layout methods
    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        setupAttributes()
        updateStickyItemsPositions()

        let lastItemFrame = allAttributes.last?.last?.frame ?? .zero
        contentSize = CGSize(width: 800, height: lastItemFrame.maxY)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for rowAttrs in allAttributes {
            for itemAttrs in rowAttrs where rect.intersects(itemAttrs.frame) {
                layoutAttributes.append(itemAttrs)
            }
        }
        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: - Helpers
    private func setupAttributes() {
        allAttributes = []

        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        for row in 0..<rowsCount {
            var rowAttrs: [UICollectionViewLayoutAttributes] = []
            xOffset = 0

            for col in 0..<columnsCount(in: row) {
                let itemSize = size(forRow: row, column: col)
                let indexPath = IndexPath(row: row, column: col)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral

                rowAttrs.append(attributes)

                xOffset += itemSize.width
            }

            yOffset += rowAttrs.last?.frame.height ?? 0.0
            allAttributes.append(rowAttrs)
        }
    }

    private func updateStickyItemsPositions() {
        for row in 0..<rowsCount {
            for col in 0..<columnsCount(in: row) {
                let attributes = allAttributes[row][col]

                if row < stickyRowsCount {
                    var frame = attributes.frame
                    frame.origin.y += collectionView!.contentOffset.y
                    attributes.frame = frame
                }

                if col < stickyColumnsCount {
                    var frame = attributes.frame
                    frame.origin.x += collectionView!.contentOffset.x
                    attributes.frame = frame
                }

                attributes.zIndex = zIndex(forRow: row, column: col)
            }
        }
    }

    private func zIndex(forRow row: Int, column col: Int) -> Int {
        if row < stickyRowsCount && col < stickyColumnsCount {
            return ZOrder.staticStickyItem
        } else if row < stickyRowsCount || col < stickyColumnsCount {
            return ZOrder.stickyItem
        } else {
            return ZOrder.commonItem
        }
    }

    // MARK: - Sizing
    private var rowsCount: Int {
        return collectionView!.numberOfSections
    }

    private func columnsCount(in row: Int) -> Int {
        return collectionView!.numberOfItems(inSection: row)
    }

    private func size(forRow row: Int, column: Int) -> CGSize {
        guard let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
            let size = delegate.collectionView?(collectionView!, layout: self, sizeForItemAt: IndexPath(row: row, column: column)) else {
            assertionFailure("Implement collectionView(_,layout:,sizeForItemAt: in UICollectionViewDelegateFlowLayout")
            return .zero
        }
        return size
    }
}

// MARK: - IndexPath
private extension IndexPath {
    init(row: Int, column: Int) {
        self = IndexPath(item: column, section: row)
    }
}

// MARK: - ZOrder
private enum ZOrder {
    static let commonItem = 0
    static let stickyItem = 1
    static let staticStickyItem = 2
}
