//
//  UserGuiderViewController.swift
//  UTEasy
//
//  Created by Ungacy Tao on 14-10-16.
//  Copyright (c) 2014年 com.ungacy. All rights reserved.
//

import UIKit

class UserGuiderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView: UITableView!
    var guider: EasyGuiderView?
    var guiderList: [[String:Int]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
    }
    func setupData() {
        guiderList = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Guider", ofType: "plist")!) as? Array
        println(guiderList)
    }
    func setupUI() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions.fromRaw(0)!, metrics: nil, views: ["tableView":tableView])
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: NSLayoutFormatOptions.fromRaw(0)!, metrics: nil, views: ["tableView":tableView])
        var constraints = [AnyObject]()
        constraints.extend(horizontalConstraint)
        constraints.extend(verticalConstraint)
        self.view.addConstraints(constraints)
        
        let dismissButton = UIBarButtonItem(title: NSLocalizedString("dismiss",comment: "dismiss"), style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
        self.navigationItem.leftBarButtonItem = dismissButton
    }
    func dismiss() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return guiderList!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = guiderList![indexPath.row].keys.first
        return cell!
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let param = guiderList![indexPath.row].values.first
        if guider == nil {
            guider = EasyGuiderView()
            guider?.custom()
            view.addSubview(guider!)
            
        }
        guider!.show([indexPath.row:param!],delegate: self)
        navigationController?.navigationBarHidden = true
//        navigationController?.hidesBarsOnTap = true
        return nil
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
