//
//  ButtonTableViewCell.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/18/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit
protocol ButtonTableViewCellDelegate: AnyObject {
    func didPressAddButton()
}

class ButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var attachmentButton: UIButton!
    
    weak var delegate: ButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didPressAtachmentButton(_ sender: UIButton) {
        delegate?.didPressAddButton()
    }
}

extension ButtonTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
