//
//  CLService.swift
//  Reminder
//
//  Created by Martin Chibwe on 1/9/18.
//  Copyright © 2018 Martin Chibwe. All rights reserved.
//

import Foundation
import CoreLocation


class CLService: NSObject {
    
    private override init(){}
    static let shared = CLService()
    let locationManager = CLLocationManager()
    var shouldSetRegion = true
    func authorize()  {
       locationManager.requestAlwaysAuthorization()
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.delegate = self
        
        
    }
    
    func updateLocaiton() {
        shouldSetRegion = true
        locationManager.startUpdatingLocation()
        
    }
    
}
extension CLService: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Got location")
        
        guard let currentLocation = locations.first, shouldSetRegion else {return}
        shouldSetRegion = false
        let region = CLCircularRegion(center: currentLocation.coordinate, radius: 20, identifier: "startPosition")
        locationManager.startMonitoring(for: region)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID ENTER REGION VIA CL")
        //when entered region
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "interanlNotfication.enteredRegion"), object: nil)
        
    }
    
}

