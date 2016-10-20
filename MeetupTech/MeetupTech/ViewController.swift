//
//  ViewController.swift
//  MeetupTech
//
//  Created by Mason Macias on 10/19/16.
//  Copyright © 2016 griffinmacias. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage
import FontAwesomeKit

class ViewController: UIViewController {
    
    @IBOutlet weak var meetupTableView: UITableView!
    let locationManager: CLLocationManager = CLLocationManager()
    var meetups: [Meetup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupLocationManager()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView() {
        self.meetupTableView.delegate = self
        self.meetupTableView.dataSource = self
        self.meetupTableView.register(UINib(nibName: "MeetupTableViewCell", bundle: nil), forCellReuseIdentifier: "MeetupCell")
    }
    
    func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func fetchTechEvents(location: CLLocationCoordinate2D) {
        Network.sharedInstance.getTechEvents(latitude: location.latitude, longitude: location.longitude) { (meetups) in
            print("Ok in the vc we are getting events in! \(meetups)")
            self.meetups = meetups
            self.meetupTableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetupCell", for: indexPath) as! MeetupTableViewCell
        let meetup = self.meetups[indexPath.row]
        cell.nameLabel.text = meetup.name
        cell.distanceLabel.text = String(format: "%.2f", meetup.distance) + " mi"
        cell.addressLabel.text = "@ \(meetup.venue?.name ?? "TBA")"
        cell.groupImageView.image = nil
        if let imageURL = meetup.group?.imageURL {
            cell.groupImageView.af_setImage(withURL: imageURL)
        } else {
            let groupIcon = FAKFontAwesome.groupIcon(withSize: 50)
            groupIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray)
            cell.groupImageView.image = groupIcon?.image(with: CGSize(width: 50, height: 50))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
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

