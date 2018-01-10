//
//  ViewController.swift
//  Reminder
//
//  Created by Martin Chibwe on 1/9/18.
//  Copyright © 2018 Martin Chibwe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNService.shared.authorize()
        CLService.shared.authorize()
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterRegion), name: NSNotification.Name(rawValue: "internalNotification.enteredRegion"), object: nil)
        //"interanlNotification.handleAction"
        NotificationCenter.default.addObserver(self, selector: #selector(handleAction(_:)), name: NSNotification.Name(rawValue: "interanlNotification.handleAction"), object: nil)
    }
    
    @objc
    func didEnterRegion()  {
        UNService.shared.locationRequest()
    }
    @objc
    func handleAction(_ sender: Notification)  {
        guard let action = sender.object as? NotificationActionID else {return}
        
        switch action {
        case .timer:changeBackground()
        case .date:print("date logic")
        case .location:print("location logic")
        
        }
    }
    func changeBackground()  {
        view.backgroundColor = .red
    }

    @IBAction func onTimerTapped(_ sender: Any) {
        print("Timer")
        AlertService.actionSheet(in: self, title: "5 seconds") {
            UNService.shared.timerRequest(with: 5)
        }
        
    }
    
    @IBAction func onDateTapped(_ sender: Any) {
        print("Date")
        AlertService.actionSheet(in: self, title: "some future time") {
            var componets = DateComponents()
            componets.second = 0
            UNService.shared.dateRequest(with: componets)
        }
        
//        componets.weekday =
        
    }
    
    @IBAction func onLocaitonTapped(_ sender: Any) {
        print("Location")
        AlertService.actionSheet(in: self, title: "When I return ") {
            CLService.shared.updateLocaiton()
            
        }
    }
}

