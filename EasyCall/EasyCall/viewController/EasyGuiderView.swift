//
//  EasyGuiderView.swift
//  UTEasy
//
//  Created by Ungacy Tao on 14-10-17.
//  Copyright (c) 2014年 com.ungacy. All rights reserved.
//

import UIKit

class EasyGuiderView: UIView {
    var param: [Int:Int]? {
        didSet {
            if param != nil {
                imageArray = [UIImage]()
                current = 0
                for (_,(key,value)) in enumerate(param!) {
                    max = value - 1
                    println("named:\(key)-\(value)")
                    for var index = 0; index < value; ++index {
                        let image: UIImage? = UIImage(named: "\(key)-\(index)")
//                        println("UIImage:\(image)")
                        if let img = image {
                            imageArray?.append(img)
                        }
                        
                    }
                }
            }
        }
    }
    var imageArray: [UIImage]?
    var current: Int = 0
    var max: Int = 0
    let display = UIImageView()
    let previous = UIImageView()
    weak var delegate: UIViewController?
    func show(param: [Int:Int],delegate: UIViewController?) {
        self.param = param
        self.hidden = false
        self.display.alpha = 0
        self.previous.alpha = 1
        self.delegate = delegate
        playImage()
        
    }
    
    func custom() {
        setTranslatesAutoresizingMaskIntoConstraints(false)
        display.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(display)
        display.userInteractionEnabled = true
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[display]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["display":display]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[display]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["display":display]))
        
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired  = 1
        display.addGestureRecognizer(tap)
        
        previous.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(previous)
        previous.userInteractionEnabled = true
//        previous.alpha = 0
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[previous]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["previous":previous]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[previous]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["previous":previous]))
        
        previous.addGestureRecognizer(tap)
        bringSubviewToFront(display)
    }
    func playImage() {
        if imageArray?.count == 0 {
            self.hidden = true
            delegate?.navigationController?.navigationBarHidden = false
            return
        }
        if current > max {
            self.imageArray?.removeAll(keepCapacity: false)
            self.hidden = true
            delegate?.navigationController?.navigationBarHidden = false
            return
        }
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.display.image = self.imageArray![self.current]
            self.display.alpha = 1

//            self.previous.alpha = 0
        }) { (flag) -> Void in
            self.previous.image = self.display.image
            self.display.alpha = 0
        }
        
    }
    func tap(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            current = current + 1
            playImage()
        }
    }
    override func didMoveToSuperview() {
        let superview = self.superview
        if let newSuperview = superview {
            newSuperview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[self]|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["self":self]))
            newSuperview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[self]|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["self":self]))
        }
        
    }
}
