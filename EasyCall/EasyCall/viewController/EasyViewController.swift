//
//  EasyViewController.swift
//  UTEasy
//
//  Created by Ungacy Tao on 14-10-10.
//  Copyright (c) 2014年 com.ungacy. All rights reserved.
//

import UIKit
import EasyBookKit
import AddressBook
class EasyViewController: UITabBarController,UITabBarControllerDelegate,UINavigationControllerDelegate,UITabBarDelegate  {
    func setupUI() {
        let favor = UINavigationController(rootViewController: EasyFavorTableViewController())
        favor.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Favorites, tag: 0)
        let contact = EasyPeoplePickerController()
        contact.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Contacts, tag: 1)
        self.setViewControllers([favor,contact], animated: true)
        self.delegate = self
    }

    func setupData() {
        let userDefault = NSUserDefaults(suiteName: "group.ai.ungacy.uteasy")
        let idString = userDefault!.stringForKey("group.ai.ungacy.uteasy.added");
//        println(idString)
        var idPhoneDict = [ABRecordID:String]()
        if let string = idString {
            let array = string.componentsSeparatedByString(";")
            
            if array.count > 0 {
                for (_,idPhone) in enumerate(array) {
                    let subArray = idPhone.componentsSeparatedByString(":")
                    if subArray.count == 2{
                        let id = subArray[0]
                        let phone = subArray[1]
                        idPhoneDict[ABRecordID(id.toInt()!)] = phone
                    }
                }
            }
            
            if idPhoneDict.count > 0 {
                println("record was set")
            } else {
                println("null record was set")
            }
        }
        else {
            
            println("null record was set")
        }
        EasyBook.shared.idPhoneDict =  idPhoneDict
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setupUI()
        setupData()
//        println(view.frame)
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let favor = viewController as? UINavigationController
        if let navi = favor {
            println(navi.topViewController)
            let topView = navi.topViewController  as? UserGuiderViewController
            if let guider = topView {
                guider.navigationController?.popViewControllerAnimated(false)
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

