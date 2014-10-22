//
//  EasyRecordButton.swift
//  UTEasy
//
//  Created by Ungacy Tao on 14-10-14.
//  Copyright (c) 2014年 com.ungacy. All rights reserved.
//

import UIKit
import QuartzCore

class EasyView: UIView {
    private var nameLabel: UILabel?
    var callButton: UIButton?
    func setName(name: String) {
        nameLabel?.text = name
    }
    func contactAdd(type: UIButtonType) {
        callButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as? UIButton
        callButton?.tag = tag
        callButton!.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(callButton!)
    }
    func custom(type: UIButtonType) {
        callButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        callButton?.tag = tag
        callButton!.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(callButton!)
        if type == UIButtonType.Custom
        {
            let icon = UIImage(named: "people")
            callButton?.setImage(icon, forState: UIControlState.Normal)
        } else {
            let icon = UIImage(named: "add")
            callButton?.setImage(icon, forState: UIControlState.Normal)
        }
        nameLabel = UILabel()
        nameLabel?.font = UIFont.systemFontOfSize(13)
        nameLabel?.textColor = UIColor.whiteColor()
        nameLabel?.backgroundColor = UIColor.clearColor()
        addSubview(nameLabel!)
        nameLabel?.textAlignment = NSTextAlignment.Center
        nameLabel?.adjustsFontSizeToFitWidth = true
        nameLabel?.minimumScaleFactor = 0.5
        nameLabel?.numberOfLines = 1
        nameLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.backgroundColor = UIColor.clearColor()
        
        let views = [
            "callButton":callButton!,
            "nameLabel":nameLabel!
        ]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[callButton]|",
            options: NSLayoutFormatOptions.fromRaw(0)!,
            metrics: nil,
            views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[nameLabel]|",
            options: NSLayoutFormatOptions.fromRaw(0)!,
            metrics: nil,
            views: views))
        let verticalVisualFormat = "V:|[callButton][nameLabel(20)]|"
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(verticalVisualFormat,
            options: NSLayoutFormatOptions.fromRaw(0)!,
            metrics: nil,
            views: views))

    }
    override func willMoveToSuperview(newSuperview: UIView?) {
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
}
