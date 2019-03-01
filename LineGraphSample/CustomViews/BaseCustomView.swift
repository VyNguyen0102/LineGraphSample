//
//  BaseCustomView.swift
//  ChildBook
//
//  Created by Vy Nguyen on 4/27/17.
//  Copyright © 2017 VVLab. All rights reserved.
//

import Foundation
import UIKit

// In almost all cases we can use View Controller instead of Custom View.
// But in this project i still need to do it.
// You can add it to View controller xib file :)
// Don't forget set file owner in xib file
extension NSObject {
    // Static Class using
    class var string: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
}

class BaseCustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }

    func getNibName() -> String {
        return className
    }

    func load() {
        let bundle = Bundle.init(for:BaseCustomView.self)
        let nib = UINib(nibName: getNibName(), bundle: bundle)
        let views = nib.instantiate(withOwner: self, options: nil)
        if let childView = views[0] as? UIView {
            addViewOverlay(childView: childView, toView: self)
            loadingViewComplete(childView: childView)
        }
    }

    func loadingViewComplete(childView: UIView) {

    }
    func addViewOverlay(childView: UIView, toView parentView: UIView) {
        parentView.addSubview(childView)
        BaseCustomView.addConstrainOverlay(childView: childView, toView: parentView)
    }
    static func addConstrainOverlay(childView: UIView, toView parentView: UIView) {
        childView.bounds = parentView.bounds // use for non auto layout project.
        childView.translatesAutoresizingMaskIntoConstraints = false

        let centerXConstraint = NSLayoutConstraint(item: childView,
                                                   attribute: NSLayoutConstraint.Attribute.centerX,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: parentView,
                                                   attribute: NSLayoutConstraint.Attribute.centerX,
                                                   multiplier: 1, constant: 0)

        let centerYConstraint = NSLayoutConstraint(item: childView,
                                                   attribute: NSLayoutConstraint.Attribute.centerY,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: parentView,
                                                   attribute: NSLayoutConstraint.Attribute.centerY,
                                                   multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: childView,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: parentView,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: childView,
                                                 attribute: NSLayoutConstraint.Attribute.width,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: parentView,
                                                 attribute: NSLayoutConstraint.Attribute.width,
                                                 multiplier: 1, constant: 0)

        parentView.addConstraints([centerXConstraint, centerYConstraint, heightConstraint, widthConstraint])
    }
}
