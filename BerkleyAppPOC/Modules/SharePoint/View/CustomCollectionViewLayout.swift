//
//  CustomCollectionViewLayout.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/12/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

protocol CustomCollectionViewLayoutDelegate: class {
    // 1. Method to ask the delegate for the height of the image
    func collectionView(_ collectionView: UICollectionView, widthAtIndexPath indexPath: Int) -> CGFloat
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    
    // Used for calculating each cells CGRect on screen.
    // CGRect will define the Origin and Size of the cell.
    var CELL_HEIGHT: Double {
        return UIDevice.current.userInterfaceIdiom == .phone ? 40.0 : 60.0
    }
    let CELL_WIDTH = 250.0
    
    weak var delegate: CustomCollectionViewLayoutDelegate?
    // Dictionary to hold the UICollectionViewLayoutAttributes for
    // each cell. The layout attribtues will define the cell's size
    // and position (x, y, and z index). I have found this process
    // to be one of the heavier parts of the layout. I recommend
    // holding onto this data after it has been calculated in either
    // a dictionary or data store of some kind for a smooth performance.
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    
    // Defines the size of the area the user can move around in
    // within the collection view.
    var contentSize = CGSize.zero
    
    // Used to determine if a data source update has occured.
    // Note: The data source would be responsible for updating
    // this value if an update was performed.
    var dataSourceDidUpdate = true
    var sectionWidth = [Double]()
    
    override var collectionViewContentSize : CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        super.prepare()
        print("Prepare")
        
        var countItems = 0
        guard let collectionView = collectionView else { return }

        if collectionView.numberOfSections > 0 {
            for section in 0..<collectionView.numberOfSections {
                countItems += collectionView.numberOfItems(inSection: section)
            }
            
            if cellAttrsDictionary.count == 0 {
                calculate()
            }
        }
    }
    
    private func calculate() {
        guard let collectionView = collectionView else { return }
        let countOfSections = collectionView.numberOfSections
        
        // Cycle through each section of the data source.
        if countOfSections > 0 {
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let width = delegate?.collectionView(collectionView, widthAtIndexPath: item) ?? 0
                sectionWidth.append(Double(width + 30))
            }
            for section in 0..<countOfSections {
                // Cycle through each item in the section.
                if collectionView.numberOfItems(inSection: section) > 0 {
                    
                    for item in 0..<collectionView.numberOfItems(inSection: section) {
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = IndexPath(item: item, section: section)
                        if section == 0 {
                            if let attr = cellAttrsDictionary[cellIndex] {
                                var frame = attr.frame
                                frame.origin = collectionView.contentOffset
                                attr.frame = frame
                            }
                        }
                        
                        //let xPos = Double(item) * CELL_WIDTH
                        var xPos: Double = 0
                        for index in 0..<item {
                            xPos += sectionWidth[index]
                        }
                        let yPos = Double(section) * CELL_HEIGHT
                       
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: sectionWidth[item], height: CELL_HEIGHT)
                        // Save the attributes.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else
                            if section == 0 {
                                cellAttributes.zIndex = 2
                            }
                            else if item == 0 {
                                cellAttributes.zIndex = 2
                            }
                            else {
                                cellAttributes.zIndex = 1
                        }
                        cellAttrsDictionary[cellIndex] = cellAttributes
                    }
                }
            }
            
            let contentWidth = sectionWidth.reduce(0.0, +)
            let contentHeight = Double(collectionView.numberOfSections) * CELL_HEIGHT
            self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        }
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
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        //return true
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    func cleanCache() {
        cellAttrsDictionary.removeAll()
        contentSize = .zero
        sectionWidth.removeAll()
    }
}
