//
//  PlaceholderTextView.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 7/4/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

open class PlaceholderTextView: UITextView {
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder), name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder), name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc override open func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPlaceholder), name: UITextView.textDidChangeNotification, object: self)
        
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    deinit {
        privatePlaceholderLabel?.removeFromSuperview()
        privatePlaceholderLabel = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    private var privatePlaceholderLabel: UILabel?
    internal var placeholderLabel: UILabel {
        get {
            if let unwrappedPlaceholderLabel = privatePlaceholderLabel {
                return unwrappedPlaceholderLabel
                
            } else {
                let label = UILabel()
                privatePlaceholderLabel = label
                
                label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 0
                label.font = self.font
                label.textAlignment = self.textAlignment
                label.backgroundColor = UIColor.clear
                label.textColor = UIColor(white: 0.7, alpha: 1.0)
                label.alpha = 0
                self.addSubview(label)
                return label
            }
        }
    }
    
    /** @abstract To set textView's placeholder text color. */
    @IBInspectable open var placeholderTextColor : UIColor? {
        
        get {
            return placeholderLabel.textColor
        }
        
        set {
            placeholderLabel.textColor = newValue
        }
    }
    
    /** @abstract To set textView's placeholder text. Default is nil.    */
    @IBInspectable open var placeholder : String? {
        
        get {
            return placeholderLabel.text
        }
        
        set {
            placeholderLabel.text = newValue
            refreshPlaceholder()
        }
    }
    
    @objc override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let unwrappedPlaceholderLabel = privatePlaceholderLabel {
            
            let offsetLeft = textContainerInset.left + textContainer.lineFragmentPadding
            let offsetRight = textContainerInset.right + textContainer.lineFragmentPadding
            let offsetTop = textContainerInset.top
            let offsetBottom = textContainerInset.top
            
            let expectedSize = unwrappedPlaceholderLabel.sizeThatFits(CGSize(width: self.frame.width-offsetLeft-offsetRight, height: self.frame.height-offsetTop-offsetBottom))
            
            unwrappedPlaceholderLabel.frame = CGRect(x: offsetLeft, y: offsetTop, width: expectedSize.width, height: expectedSize.height)
        }
    }
    
    @objc internal func refreshPlaceholder() {
        
        if !text.isEmpty {
            placeholderLabel.alpha = 0
        } else {
            placeholderLabel.alpha = 1
        }
    }
    
    @objc override open var text: String! {
        
        didSet {
            
            refreshPlaceholder()
            
        }
    }
    
    @objc override open var font : UIFont? {
        
        didSet {
            
            if let unwrappedFont = font {
                placeholderLabel.font = unwrappedFont
            } else {
                placeholderLabel.font = UIFont.systemFont(ofSize: 12)
            }
        }
    }
    
    @objc override open var textAlignment: NSTextAlignment
        {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    @objc override open var delegate : UITextViewDelegate? {
        
        get {
            refreshPlaceholder()
            return super.delegate
        }
        
        set {
            super.delegate = newValue
        }
    }
}
