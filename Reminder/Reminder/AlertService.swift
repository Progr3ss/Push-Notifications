//
//  AlertService.swift
//  Reminder
//
//  Created by Martin Chibwe on 1/9/18.
//  Copyright © 2018 Martin Chibwe. All rights reserved.
//

import Foundation
import  UIKit
class AlertService {
    
    private init(){}
    
    static func actionSheet(in vc: UIViewController,title: String, completion: @escaping() -> Void){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { (_) in
            completion()
        }
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
        
        
    }
}
