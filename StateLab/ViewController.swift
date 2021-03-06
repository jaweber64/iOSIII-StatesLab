//
//  ViewController.swift
//  StateLab
//
//  Created by Janet Weber on 10/7/17.
//  Copyright © 2017 Weber Software Solutions. All rights reserved.
//
//  This project is from Chapter 15 of the book "Beginning iPhone Development with Swift -
//  Exploring the iOS SDK".  Grand Central Dispatch, Background Processing and You.

// This project explores execution 'states'.  It uses the console to echo the method being
// called from both the AppDelegate and the ViewController.  The layout consists of a
// segmented controller, an image of a smiley face, and a spinning label (Bazinga!).
// When user hits home button or double hits home button and swipes app off screen,
// the states are echoed in the console as they are reached.  The app also stores
// the state of the segmented controller so when the app comes up next time, it is
//  just as we left it.  We also release resources (images, etc) where appropriate.

import UIKit

class ViewController: UIViewController {
    private var label:UILabel!
    private var smiley:UIImage!
    private var smileyView:UIImageView!
    private var segmentedControl:UISegmentedControl!
    private var index = 0
    private var animate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let bounds = view.bounds
        let labelFrame = CGRect(x: bounds.origin.x, y: bounds.midY - 50,
                                       width: bounds.size.width, height: 100)
        label = UILabel(frame:labelFrame)
        label.font = UIFont(name:"Helvetica", size: 70)
        label.text = "Bazinga!"
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        
        // smiley.png is 84 x 84
        let smileyFrame = CGRect(x: bounds.midX - 42, y: bounds.midY/2 - 42, width: 84, height: 84)
        smileyView = UIImageView(frame:smileyFrame)
        smileyView.contentMode = UIViewContentMode.center
        let smileyPath = Bundle.main.path(forResource: "smiley", ofType: "png")!
        smiley = UIImage(contentsOfFile: smileyPath)
        smileyView.image = smiley
        
        segmentedControl = UISegmentedControl(items: ["One", "Two", "Three", "Four"])
        segmentedControl.frame = CGRect(x: bounds.origin.x + 20, y: 50, width: bounds.size.width - 40, height: 30)
        segmentedControl.addTarget(self, action: #selector(ViewController.selectionChanged), for: UIControlEvents.valueChanged)
        
        view.addSubview(segmentedControl)
        view.addSubview(smileyView)
        view.addSubview(label)
        
        index = UserDefaults.standard.integer(forKey: "index")
        segmentedControl.selectedSegmentIndex = index
        
        //self.rotateLabelDown()
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(ViewController.applicationWillResignActive),
                           name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        center.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive),
                           name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        center.addObserver(self, selector: #selector(ViewController.applicationDidEnterBackground),
                           name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        center.addObserver(self, selector: #selector(ViewController.applicationWillEnterForeground),
                           name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    func rotateLabelDown() {
        UIView.animate(withDuration: 0.5, animations: {
            self.label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            },
                       completion: {(Bool) -> Void in
                        self.rotateLabelUp()
        })
    }
    
    func rotateLabelUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.label.transform = CGAffineTransform(rotationAngle: 0)
        },
           completion: {(Bool) -> Void in
            if self.animate {
                self.rotateLabelDown()
            }
        })
    }
    
    @objc func selectionChanged(sender:UISegmentedControl) {
        index = segmentedControl.selectedSegmentIndex
    }
    
    @objc func applicationWillResignActive() {
        print("VC: (animate - false: \(#function)")
        animate = false
    }
    
    @objc func applicationDidBecomeActive() {
        print("VC: (animate - true) \(#function)")
        animate = true
        rotateLabelDown()
    }
    
    @objc func applicationDidEnterBackground() {
        print("VC: \(#function)")
//        self.smiley = nil
//        self.smileyView.image = nil
        UserDefaults.standard.set(self.index, forKey:"index")
        let app = UIApplication.shared
        var taskId = UIBackgroundTaskInvalid
        let id = app.beginBackgroundTask(){
            print("Background task ran out fo time and was terminated.")
            app.endBackgroundTask(taskId)
        }
        taskId = id
        
        if taskId == UIBackgroundTaskInvalid {
            print("Failed to start background task!")
            return
        }
        
        let bqueue = DispatchQueue.global(qos: .background)
        bqueue.async() {
            print("Starting background task with " + "\(app.backgroundTimeRemaining) second remaining")
            self.smiley = nil
            self.smileyView.image = nil
            
            // simulate a lengthy (15 seconds) procedure
            Thread.sleep(forTimeInterval: 15)
            
            print("Finishing background task with \(app.backgroundTimeRemaining) seconds remaining")
            app.endBackgroundTask(taskId)
            }
      
    }
    
    @objc func applicationWillEnterForeground() {
        print("VC: \(#function)")
        let smileyPath = Bundle.main.path(forResource: "smiley", ofType: "png")!
        smiley = UIImage(contentsOfFile: smileyPath)
        smileyView.image = smiley
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

