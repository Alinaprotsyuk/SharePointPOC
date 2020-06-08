//
//  HeaderCollectionViewCell.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/14/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        titleLabel.textAlignment = .left
        sortButton.isSelected = false
    }
}

extension HeaderCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
