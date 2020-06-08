//
//  CreateEditItemTableViewCell.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/18/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit
protocol TextFieldTableViewCellDelegate: AnyObject {
    func textFieldDidEndEditing(text: String, key: String)
}

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: TextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }

    func setup(text: String, required: Bool) {
        textField.text = text
    }
}

extension TextFieldTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

//MARK: - UITextFieldDelegate
extension TextFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)
        delegate?.textFieldDidEndEditing(text: txtAfterUpdate, key: textField.accessibilityIdentifier ?? "")

        return true
    }
}



