//
//  EasyPeoplePickerController.swift
//  UTEasy
//
//  Created by Ungacy Tao on 14-10-13.
//  Copyright (c) 2014年 com.ungacy. All rights reserved.
//

import UIKit
import EasyBookKit
import AddressBook

class EasyPeoplePickerController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {

    var tableView: UITableView!
    let addressBook = EasyBook.shared
    var currentIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    func setupUI() {
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tableView":tableView])
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-22-[tableView]-44-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tableView":tableView])
        var constraints = [AnyObject]()
        constraints.extend(horizontalConstraint)
        constraints.extend(verticalConstraint)
        self.view.addConstraints(constraints)
    }
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return addressBook.allRecordArray!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")
        }
        let easy = addressBook.allRecordArray![indexPath.row]
        if easy.added {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        cell!.textLabel?.text = easy.compositeName!
        cell!.detailTextLabel?.text = easy.allPhoneString
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentIndex = indexPath.row
        let easy = addressBook.allRecordArray![currentIndex]
        easy.added = !easy.added
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        if easy.added {
            if easy.phoneArray!.count > 1 {
                let action = UIActionSheet()
                action.delegate = self
                action.title = NSLocalizedString("choose number", comment: "")
                for (_,item) in enumerate(easy.phoneArray!) {
                    for (key,value) in item {
                        action.addButtonWithTitle(key + ":" + value)
                    }
                }
                action.showInView(view)
                
            } else {
                easy.phone = easy.phoneArray?.first?.values.first
            }
        }
        
        saveDefaults()
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let title = actionSheet.buttonTitleAtIndex(buttonIndex)
        let array = title.componentsSeparatedByString(":")
        let easy = addressBook.allRecordArray![currentIndex]
        easy.phone = array.last
        saveDefaults()
    }
    private func saveDefaults() {
        let addedArray = addressBook.addedRecordArray
        var idArray = [String]()
        for (_,item) in enumerate(addedArray) {
            idArray.append(item.dictString())
        }
        println(idArray)
        let userDefault = NSUserDefaults(suiteName: "group.ai.ungacy.uteasy")
        userDefault!.setObject(idArray.componentsJoinedByString(";"), forKey: "group.ai.ungacy.uteasy.added")
        
        userDefault!.synchronize()
    }
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
}
extension Array {
    func componentsJoinedByString(separator: String) -> String {
        var str : String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }
}