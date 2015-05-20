//
//  EasyBook.swift
//  UTEasy
//
//  Created by Ungacy Tao on 14-10-11.
//  Copyright (c) 2014年 com.ungacy. All rights reserved.
//

import UIKit
import AddressBook

public class EasyBook: NSObject {
    public var allRecordArray: [EasyRecord]?
    public var idPhoneDict: [ABRecordID:String]? {
        didSet {
            idArray = idPhoneDict?.keys.array
            println(idArray)
        }
    }
    public var idArray: [ABRecordID]? {
        didSet {
            getContact()
        }
    }
    public var addedRecordArray: [EasyRecord]! {
        get {
            let filter = allRecordArray?.filter { (record) -> Bool in
                return record.added
            }
            if let filterArray = filter {
                return filterArray
            }
            return []
        }
    }
    var addressBook: ABAddressBookRef?
    let status = ABAddressBookGetAuthorizationStatus()
    public class var shared: EasyBook {
        dispatch_once(&Inner.token) {
            Inner.instance = EasyBook()
        }
        return Inner.instance!
    }
    struct Inner {
        static var instance: EasyBook?
        static var token: dispatch_once_t = 0
    }
    
    override init() {
        super.init()
    }
    
    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        var source: ABRecordRef = ABAddressBookCopyDefaultSource(addressBook).takeRetainedValue()
        var contactList: NSArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, ABPersonGetSortOrdering()).takeRetainedValue()
        println("records in the array \(contactList.count)")
        allRecordArray = [EasyRecord]()
        for record:ABRecordRef in contactList {
            let easy = EasyRecord.createWith(record)
            if let easyValue = easy {
                if let ids = idArray {
                    for (_,item) in enumerate(ids) {
                        if easyValue.recordID == item {
                            easyValue.added = true
                            easyValue.phone = idPhoneDict![easyValue.recordID!]
                        }
                    }
                }
                allRecordArray?.append(easyValue)
            }
        }
    }
    func extractABAddressBookRef(abRef: Unmanaged<ABAddressBookRef>!) -> ABAddressBookRef? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    func getContact() {
        switch status {
        case .NotDetermined :
            println("requesting access...")
            var errorRef: Unmanaged<CFError>? = nil
            addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    self.getContactNames()
                }
                else {
                    println("error")
                }
            })
        case .Denied,.Restricted:
            println("access denied")
            
        case .Authorized :
            println("access granted")
            self.getContactNames()
        }
    }
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
extension EasyRecord {
    func values(record: ABRecordRef, property: ABPropertyID!) -> AnyObject? {
        let propertyValue: AnyObject = ABRecordCopyValue(record, property).takeRetainedValue()
        if let values: ABMultiValueRef = propertyValue as ABMultiValueRef?{
            var count = ABMultiValueGetCount(values)
            if  count > 0 {
                self.phoneArray = [[String:String]]()
                for var index = 0; index < count;++index {
                    let value: String? = ABMultiValueCopyValueAtIndex(values,index).takeRetainedValue() as? String
                    let label = ABMultiValueCopyLabelAtIndex(values,index).takeRetainedValue()
                    let key: String = ABAddressBookCopyLocalizedLabel(label).takeRetainedValue() as NSString as String
                    if let string = value {
                        self.phoneArray?.append([key:string])
                    }
                }
//                println(self.phoneArray?)
                
            }
        }
        return nil
    }
}
public class EasyRecord {
    public var recordID: ABRecordID?//typealias ABRecordID = Int32
    public var compositeName: String?
    public var phoneArray: [[String:String]]?
    public var added: Bool = false
    public var phone: String?
    public var allPhoneString: String? {
        get {
            if phoneArray?.count > 0 {
                var desc: String = ""
                for (index,dict) in enumerate(phoneArray!) {
                    if index == phoneArray!.count - 1{
                        desc = desc + dict.values.first!
                    } else {
                        desc = desc + dict.values.first! + "/"
                    }
                    
                }
                return desc
            }
            return nil
        }
    }
    class func createWith(record: ABRecordRef) -> EasyRecord?{
        let easy = EasyRecord()
        easy.recordID = ABRecordGetRecordID(record)
        easy.compositeName = ABRecordCopyCompositeName(record).takeRetainedValue() as NSString as String
        easy.values(record, property: kABPersonPhoneProperty)
        
//#if !NDEBUG
//        easy.compositeName = "测试用户\(easy.recordID!)"
//        if easy.phoneArray?.count > 0 {
//            var temp = [[String:String]]()
//            for (index,dict) in enumerate(easy.phoneArray!) {
//                let tempDict = [dict.keys.first!:"测试号码\(easy.recordID!)" + "\(index)"]
//                temp.append(tempDict)
//            }
//            easy.phoneArray = temp
//        }
//#endif
        
        
        if easy.invalidate() {
            return easy
        }
        return nil
    }
    func invalidate() -> Bool {
        if recordID != nil && compositeName != nil && phoneArray?.count > 0 {
            return true
        }
        return false
    }
    public func dictString() -> String {
        if phone != nil {
           return "\(recordID!):" + phone!
        }
        return ""
    }
    public func descripition() -> String {
        if added {
            return compositeName! + "#" + phone!
        } else {
            return compositeName! + "#" + allPhoneString!
        }
    }
    
}
