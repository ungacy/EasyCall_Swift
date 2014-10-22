//
//  EasyFavorTableViewController.swift
//  UTEasy
//
//  Created by Ungacy Tao on 14-10-13.
//  Copyright (c) 2014年 com.ungacy. All rights reserved.
//

import UIKit
import EasyBookKit

class EasyFavorTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView: UITableView!
    let addressBook = EasyBook.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func setupData() {
        tableView.reloadData()
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
        
        
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
        self.navigationItem.leftBarButtonItem = editButton
        
        
        let helpButton = UIBarButtonItem(title: NSLocalizedString("help",comment: ""), style: UIBarButtonItemStyle.Plain, target: self, action: "help")
        self.navigationItem.rightBarButtonItem = helpButton
    }
    func edit() {
        tableView.setEditing(!tableView.editing, animated: true)
    }
    func help() {
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
        app?.rootViewController?.presentViewController(UINavigationController(rootViewController: UserGuiderViewController()), animated: true, completion: { () -> Void in
            
        })
//        self.navigationController?.pushViewController(UserGuiderViewController(), animated: true)
    }
    override func viewDidAppear(animated: Bool) {
        setupData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    // MARK: - Table view data source

    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return addressBook.addedRecordArray.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")
            cell?.editingAccessoryView
        }
        let easy = addressBook.addedRecordArray[indexPath.row]
        cell!.textLabel?.text = easy.compositeName!
        cell!.detailTextLabel?.text = easy.phone
        return cell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    // Override to support editing the table view.
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let easy = addressBook.addedRecordArray[indexPath.row]
            easy.added = false
            saveDefaults()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    private func saveDefaults() {
        let addedArray = addressBook.addedRecordArray
        var idArray = [String]()
        for (_,item) in enumerate(addedArray) {
            idArray.append(item.dictString())
        }
        println(idArray)
        let userDefault = NSUserDefaults(suiteName: "group.ai.ungacy.uteasy")
        userDefault.setObject(idArray.componentsJoinedByString(";"), forKey: "group.ai.ungacy.uteasy.added")
        
        userDefault.synchronize()
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
