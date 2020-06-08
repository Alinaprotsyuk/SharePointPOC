//
//  ItemCollectionViewCell.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/12/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit
protocol ItemCollectionViewCellDelegate: AnyObject {
    func didPressEdit(for section: Int)
}

class ItemCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    private var section: Int?
    weak var delegate: ItemCollectionViewCellDelegate?
    
    override func prepareForReuse() {
        textLabel.text = ""
        textLabel.textAlignment = .left
        editButton.isHidden = true
    }
    
    func setup(section: Int) {
        self.section = section
    }
    
    @IBAction func didPressEditButton(_ sender: UIButton) {
        print("Select section N\(section ?? 0)")
        guard let section = section else { return }
        delegate?.didPressEdit(for: section)
    }
    
}

extension ItemCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
