//
//  ViewController.swift
//  MeetupTech
//
//  Created by Mason Macias on 10/19/16.
//  Copyright © 2016 griffinmacias. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    let locationManager: CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func fetchTechEvents(location: CLLocationCoordinate2D) {
        Network.sharedInstance.getTechEvents(latitude: location.latitude, longitude: location.longitude) { (events) in
            print("Ok in the vc we are getting events in! \(events)")
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Locations! \(locations.last?.coordinate)")
        if let coordinate = locations.last?.coordinate {
            self.fetchTechEvents(location: coordinate)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location \(error.localizedDescription)")
    }
}

