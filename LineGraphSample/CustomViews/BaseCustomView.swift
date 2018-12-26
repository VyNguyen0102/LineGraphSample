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
        return classIdentifier()
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
                                                   attribute: NSLayoutAttribute.centerX,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: parentView,
                                                   attribute: NSLayoutAttribute.centerX,
                                                   multiplier: 1, constant: 0)

        let centerYConstraint = NSLayoutConstraint(item: childView,
                                                   attribute: NSLayoutAttribute.centerY,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: parentView,
                                                   attribute: NSLayoutAttribute.centerY,
                                                   multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: childView,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: parentView,
                                                  attribute: NSLayoutAttribute.height,
                                                  multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: childView,
                                                 attribute: NSLayoutAttribute.width,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: parentView,
                                                 attribute: NSLayoutAttribute.width,
                                                 multiplier: 1, constant: 0)

        parentView.addConstraints([centerXConstraint, centerYConstraint, heightConstraint, widthConstraint])
    }
}
