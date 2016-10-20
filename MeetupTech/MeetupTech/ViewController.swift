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
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var meetupTableView: UITableView!
    let locationManager: CLLocationManager = CLLocationManager()
    var meetups: [Meetup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupActivityIndicatorView()
        self.setupTableView()
        self.setupLocationManager()
        self.fetchTechEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Setup Methods
    
    func setupActivityIndicatorView() {
        self.activityIndicatorView.color = UIColor.gray
        self.activityIndicatorView.startAnimating()
    }
    
    func setupTableView() {
        self.meetupTableView.delegate = self
        self.meetupTableView.dataSource = self
        self.meetupTableView.register(UINib(nibName: "MeetupTableViewCell", bundle: nil), forCellReuseIdentifier: "MeetupCell")
        //So you can't see a blank tableView
        self.meetupTableView.tableFooterView = UIView()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.updateTechEvents), for: .valueChanged)
        self.meetupTableView.refreshControl = refreshControl
    }
    
    func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.pausesLocationUpdatesAutomatically = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    //MARK: Network Methods
    
    func updateTechEvents() {
        self.fetchTechEvents()
    }
    
    func fetchTechEvents() {
        if let currentLocation = self.locationManager.location?.coordinate {
            Network.sharedInstance.getTechEvents(latitude: currentLocation.latitude, longitude: currentLocation.longitude) { (meetupArray) in
                self.activityIndicatorView.stopAnimating()
                self.meetupTableView.refreshControl?.endRefreshing()
                if let meetups = meetupArray {
                    self.meetups = meetups
                    self.view.layoutIfNeeded()
                    UIView.animate(withDuration: 0.2, delay: 0.2, options: .transitionCrossDissolve, animations: {
                        self.meetupTableView.reloadData()
                        self.view.layoutIfNeeded()
                        }, completion: nil)
                }
            }
        } else {
            self.meetupTableView.refreshControl?.endRefreshing()
            self.activityIndicatorView.stopAnimating()
        }
    }
}

//MARK TableView Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meetup = self.meetups[indexPath.row]
        let cell = self.configureMeetupCell(tableView: tableView, indexPath: indexPath, meetup: meetup)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    func configureMeetupCell(tableView: UITableView, indexPath: IndexPath, meetup: Meetup) -> MeetupTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetupCell", for: indexPath) as! MeetupTableViewCell
        cell.clearContents()
        cell.nameLabel.text = meetup.name
        cell.distanceLabel.text = String(format: "%.2f", meetup.distance) + " mi"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        cell.eventDateTimeLabel.text = "\(dateFormatter.string(from: meetup.eventDate))"
        cell.venueNameLabel.text = "@ \(meetup.venue?.name ?? "TBA")"
        if let imageURL = meetup.group?.imageURL {
            //Personally that it looked better not having a placeholder image
            cell.groupImageView.af_setImage(withURL: imageURL)
        } else {
            let groupIcon = FAKFontAwesome.groupIcon(withSize: 50)
            groupIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray)
            let groupIconImage = groupIcon?.image(with: CGSize(width: 50, height: 50))
            cell.groupImageView.image = groupIconImage
        }
        return cell
    }
}

//MARK: CLLocation Methods

extension ViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Locations! \(locations.last?.coordinate)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.activityIndicatorView.startAnimating()
            self.updateTechEvents()
        default:
            break
        }
    }
}

