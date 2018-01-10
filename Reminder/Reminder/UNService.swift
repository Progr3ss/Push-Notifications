//
//  UNService.swift
//  Reminder
//
//  Created by Martin Chibwe on 1/9/18.
//  Copyright © 2018 Martin Chibwe. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class UNService: NSObject {
    
    private override init(){}
    static let shared = UNService()
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize()  {
        let options: UNAuthorizationOptions = [.alert, .badge , .sound,.carPlay]
        unCenter.requestAuthorization(options: options){ (granted, error) in
            print(error ?? " No UN autho error")
            
            guard granted else{
                print("USER DENIED ACCESS")
                return
            }
            self.configure()
        }
        
    }
    
    func getAttachment(for id: NoticationAttachmentID)  -> UNNotificationAttachment? {
        
        var imageName:String
       
        switch id {
        case .timer:  imageName = "TimeAlert"
        case .date:  imageName = "DateAlert"
        case .location: imageName = "LocationAlert"
            
        
    
        }
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else {return nil }
        
        do {
            let attachment = try UNNotificationAttachment(identifier: id.rawValue, url: url)
            return attachment
        } catch {
            return nil
        }
      
    
    }
    
    func configure()  {
        unCenter.delegate = self
        setupAcetionsAndCategories()
    }
    //
    func setupAcetionsAndCategories()  {
        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue, title: "Run timer logic", options: [.authenticationRequired])
         let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue, title: "Run date logic", options: [.destructive])
        let location = UNNotificationAction(identifier: NotificationActionID.location.rawValue, title: "Run location logic", options: [.foreground])
        
        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue, actions: [timerAction], intentIdentifiers: [], options: [])
        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue, actions: [dateAction], intentIdentifiers: [], options: [])
        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue, actions: [location], intentIdentifiers: [], options: [])
        
        
        unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
        
        
    }
    
    
    
    func timerRequest(with interval : TimeInterval) {
        //content: what you will be sending to be called
        //trigger: whatever its causing it to happen
        //request: when met it will send the notficaiton to user
        
        
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "Your timer is all done."
        content.sound  = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.timer.rawValue
        if let attachment = getAttachment(for: .timer){
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotficaiton.timer", content: content, trigger: trigger)
        
        unCenter.add(request)
        
        
        
    }
    
    func dateRequest(with components: DateComponents)  {
        let content = UNMutableNotificationContent()
        content.title = "Date trigger"
        content.body = "It is now the future!"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.date.rawValue
        if let attachment = getAttachment(for: .date){
            content.attachments = [attachment]
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "userNotificaiton.date", content: content, trigger: trigger)
        
        unCenter.add(request)
        
        
//        content
        
    }
    
    func  locationRequest()  {
        UNService.shared.locationRequest()
        let content = UNMutableNotificationContent()
        content.title = "You have retured"
        content.body = "Welcome back you"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.location.rawValue
        //trigger does not run correctly
        if let attachment = getAttachment(for: .location){
            content.attachments = [attachment]
        }
        
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        
        unCenter.add(request)

        
    }
    
    
}

extension UNService: UNUserNotificationCenterDelegate {
    //When user taps on the notficaiton
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        if let action = NotificationActionID(rawValue: response.actionIdentifier){
            NotificationCenter.default.post(name: NSNotification.Name("interanlNotification.handleAction"), object: action)
            
        }
        completionHandler()
    }
    //When app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN WIll present")
        //when user is in the app
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
        
    }
    
}
