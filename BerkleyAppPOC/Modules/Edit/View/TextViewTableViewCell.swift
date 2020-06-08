//
//  TextViewTableViewCell.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 7/4/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit
protocol TextViewTableViewCellDelegate: AnyObject {
    func textViewDidEndEditing(text: String, key: String)
}

class TextViewTableViewCell: UITableViewCell {
    @IBOutlet weak var textView: PlaceholderTextView!
    
    weak var delegate: TextViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
    }
    
    func generalSetup(placeholder: String?, identefier: String?) {
        textView.placeholder = placeholder
        textView.accessibilityLabel = identefier
    }
    
    func setup(text: String) {
        textView.text = text
    }

}

extension TextViewTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

//MARK: - UITextFieldDelegate
extension TextViewTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textFieldText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: text)
        print(txtAfterUpdate)
        delegate?.textViewDidEndEditing(text: txtAfterUpdate, key: textView.accessibilityIdentifier ?? "")
        
        return true
    }
}
