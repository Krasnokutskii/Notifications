//
//  ViewController.swift
//  Project21
//
//  Created by Ярослав on 4/21/21.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerlocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    //register notification
    @objc func registerlocal(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert,.badge,.sound]) { (granted, error) in
            if granted {
                print("yeah")
            } else{
                print("booo")
            }
        }
    }
    
    //creating notification and time to execute
    @objc func scheduleLocal(){
        registerCategories() // now ios knows what means category identifier "alarm"
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbazz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    //add additional button to loked skreen
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        #warning("it would be interestion to add image in notification with some text")
        let show = UNNotificationAction(identifier: "show", title: "tell me more", options: .foreground)
        let remindLater = UNNotificationAction(identifier: "remindLater", title: "remind me later", options: .authenticationRequired)
        
        let categoru = UNNotificationCategory(identifier: "alarm", actions: [show,remindLater], intentIdentifiers: [])
        center.setNotificationCategories([categoru])
        
    }
    
    //handling touched event on locked skreen
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo//way to castom data from above
        
        if let customData = userInfo["customData"] as? String{
            print("\(customData)")
            
            switch response.actionIdentifier { //response.actionIdentifier = identifier which you wrote in UNNotificationAction
            case UNNotificationDefaultActionIdentifier:
                //the user swiped to unlock
            print("default identifier")
            case "show":
                print("show more info")
            case "remindLater":
                print("remind later")
                scheduleLocal()
            default:
                break
            }
        }
        completionHandler()
    }

}


///1. register  center.registerAutorithation
///2.create notification    center.add(request)
///3.creater request  request(content, trigger)
///4.create custom action UNNotificationAction
///5 handel tapping
///6 call coplitionHandler()
