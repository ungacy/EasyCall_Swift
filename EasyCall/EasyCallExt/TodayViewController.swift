//
//  TodayViewController.swift
//  EasyCallExt
//
//  Created by Ungacy Tao on 14-10-17.
//  Copyright (c) 2014年 com.ungacy. All rights reserved.
//

import UIKit
import NotificationCenter
import EasyBookKit
import AddressBook

class TodayViewController: UIViewController, NCWidgetProviding {
    let maxElementInLine = 3
    var numberOfLine: Int = 0
    var rowInLastLine: Int = 0
    var viewArray = [UIView]()
    
    func setupData() {
        let userDefault = NSUserDefaults(suiteName: "group.ai.ungacy.uteasy")
        let idString = userDefault!.stringForKey("group.ai.ungacy.uteasy.added");
        
        if let string = idString {
            let array = string.componentsSeparatedByString(";")
            var idPhoneDict = [ABRecordID:String]()
            if array.count > 0 {
                for (_,idPhone) in enumerate(array) {
                    let subArray = idPhone.componentsSeparatedByString(":")
                    if subArray.count == 2 {
                        let id = subArray[0]
                        let phone = subArray[1]
                        idPhoneDict[ABRecordID(id.toInt()!)] = phone
                    }
                    
                }
            }
            //            println(idPhoneDict)
            EasyBook.shared.idPhoneDict = idPhoneDict
        }
    }
    
    
    func setupUI() {
        for (_,item) in enumerate(viewArray) {
            item.removeFromSuperview()
        }
        
        let addedArray = EasyBook.shared.addedRecordArray
        let recordCount = addedArray.count
        numberOfLine = recordCount/maxElementInLine
        rowInLastLine = recordCount%maxElementInLine
        let superview = self.view
        for (index,easy) in enumerate(addedArray) {
            
            let line = index/maxElementInLine
            let row = index%maxElementInLine
            let currentView = EasyView()
            currentView.tag = index
            currentView.custom(UIButtonType.Custom)
            currentView.setName(easy.compositeName!)
            currentView.callButton?.addTarget(self, action: "call:", forControlEvents: UIControlEvents.TouchUpInside)
            superview.addSubview(currentView)
            viewArray.append(currentView)
            var viewsDict = ["currentView":currentView]
            var horizontalVisualFormat = "H:|[currentView]"
            //            最后一行
            if line == numberOfLine{
                switch rowInLastLine {
                case 1 :
                    let addButton = EasyView()
                    addButton.custom(UIButtonType.ContactAdd)
                    viewsDict["addButton"] = addButton
                    addButton.hidden = true
                    superview.addSubview(addButton)
                    addButton.callButton?.addTarget(self, action: "recordManager:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    let placeholder = EasyView()
                    placeholder.hidden = true
                    viewsDict["placeholder"] = placeholder
                    superview.addSubview(placeholder)
                    
                    let metricsVertical = ["viewHeight": (84 * line)]
                    let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-viewHeight-[addButton(84)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsVertical, views: ["addButton":addButton])
                    superview.addConstraints(verticalConstraint)
                    horizontalVisualFormat = "H:|[currentView][addButton(currentView)][placeholder(currentView)]|"
                case 2 :
                    //                    row == 2
                    if row == 1 {//水平
                        let leftView = viewArray[(index - 1)]
                        viewsDict["leftView"] = leftView as? EasyView
                        
                        let addButton = EasyView()
                        addButton.custom(UIButtonType.ContactAdd)
                        addButton.hidden = true
                        addButton.callButton?.addTarget(self, action: "recordManager:", forControlEvents: UIControlEvents.TouchUpInside)
                        viewsDict["addButton"] = addButton
                        superview.addSubview(addButton)
                        let metricsVertical = ["viewHeight": 84 * line]
                        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-viewHeight-[addButton(84)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsVertical, views: ["addButton":addButton])
                        superview.addConstraints(verticalConstraint)
                        
                        horizontalVisualFormat = "H:|[leftView][currentView(leftView)][addButton(leftView)]|"
                    }
                default :
                    if row == 0 {//水平
                        
                    } else if row != maxElementInLine - 1 {
                        let leftView = viewArray[(index - 1)]
                        horizontalVisualFormat = "H:[leftView][currentView(leftView)]"
                        viewsDict["leftView"] = leftView as? EasyView
                    } else {
                        let leftView = viewArray[(index - 1)]
                        horizontalVisualFormat = "H:[leftView][currentView(leftView)]|"
                        viewsDict["leftView"] = leftView as? EasyView
                    }
                }
            }
            else {
                if row == 0 {//水平
                    
                } else if row != maxElementInLine - 1 {
                    let leftView = viewArray[(index - 1)]
                    horizontalVisualFormat = "H:[leftView][currentView(leftView)]"
                    viewsDict["leftView"] = leftView as? EasyView
                } else {
                    let leftView = viewArray[(index - 1)]
                    horizontalVisualFormat = "H:[leftView][currentView(leftView)]|"
                    viewsDict["leftView"] = leftView as? EasyView
                }
            }
            let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(horizontalVisualFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:viewsDict)
            superview.addConstraints(horizontalConstraint)
            let metricsVertical = ["viewHeight": 84 * line]
            let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-viewHeight-[currentView(84)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metricsVertical, views: ["currentView":currentView])
            
            superview.addConstraints(verticalConstraint)
            
            
        }
        
    }
    
    func addContactManager() {
        let button = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        button?.setTitle(NSLocalizedString("contactmanager", comment: ""), forState: UIControlState.Normal)
        button?.backgroundColor = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1.0)
        button?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button!.setTranslatesAutoresizingMaskIntoConstraints(false)
        button?.addTarget(self, action: "recordManager:", forControlEvents: UIControlEvents.TouchUpInside)
        button!.layer.cornerRadius = 3
        view.addSubview(button!)
        viewArray.append(button!)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]-30-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["button":button!]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button(20)]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["button":button!]))
        var line = numberOfLine
        if rowInLastLine > 0 {
            line += 1
        }
        let metricsVertical = ["viewHeight": 84 * line + 40]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(viewHeight)]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsVertical,
            views: ["view":view]))
        
        
    }
    func recordManager(sender: UIButton) {
        var urlString = "easycall://"
        if let superview = sender.superview as? EasyView {
            urlString += "add"
        }
        else {
            urlString += "manager"
        }
        println(urlString)
        let url = NSURL(string: urlString)
        extensionContext?.openURL(url!, completionHandler: { (flag) -> Void in
            
        })
    }
    func call(sender: UIButton) {
        let easy = EasyBook.shared.addedRecordArray[sender.tag]
        var phone = easy.phone?.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        phone = phone?.stringByReplacingOccurrencesOfString("+", withString: "00", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        phone = phone?.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        if let number = phone {
            
            var url = NSURL(string: "tel://" + phone!)
            extensionContext?.openURL(url!, completionHandler: { (flag) -> Void in
                
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        addContactManager()
        //        updatePreferredContentSize()
        
        //        println("viewDidLoad:\(preferredContentSize)")
        // Do any additional setup after loading the view from its nib.
    }
    func updatePreferredContentSize() {
        println(preferredContentSize.width)
        var line = numberOfLine
        if rowInLastLine > 0 {
            line += 1
        }
        preferredContentSize = CGSizeMake(preferredContentSize.width, CGFloat(line * 84) + 40)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ context in
            }, completion: nil)
    }
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
}
