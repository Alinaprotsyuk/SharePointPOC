//
//  BaseCollectionViewCell.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/14/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    }
}
