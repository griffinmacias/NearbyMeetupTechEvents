//
//  Models.swift
//  MeetupTech
//
//  Created by Mason Macias on 10/19/16.
//  Copyright © 2016 griffinmacias. All rights reserved.
//

import Foundation

struct Meetup {
    
    var name: String
    var distance: Double
    var eventDate: Date
    var group: Group?
    var venue: Venue?
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let distance = json["distance"] as? Double,
            let timeInMilliseconds = json["time"] as? Double else {
            return nil
        }
        self.name = name
        self.distance = distance
        self.eventDate = Date(timeIntervalSince1970: timeInMilliseconds/1000.0)
        if let venueDict = json["venue"] as? [String: Any] {
            self.venue = Venue.init(venueDict: venueDict)
        }
        if let groupDict = json["group"] as? [String: Any] {
            self.group = Group.init(groupDict: groupDict)
        } else {
            
        }
    }
}

struct Group {
    
    var imageURL: URL?
    var name: String
    
    init?(groupDict: [String: Any]) {
        guard let name = groupDict["name"] as? String else {
            return nil
        }
        self.name = name
        if let imageDict = groupDict["group_photo"] as? [String: Any],
            let imageURL = imageDict["photo_link"] as? String {
            self.imageURL = URL(string: imageURL)
        } else {
            
        }
    }
}

struct Venue {
    
    var longitude: Double
    var latitude: Double
    var address: String?
    var name: String?
    var city: String?
    
    init?(venueDict: [String: Any]) {
        guard let latitude = venueDict["lat"] as? Double,
            let longitude = venueDict["lon"] as? Double else {
            return nil
        }
        self.longitude = longitude
        self.latitude = latitude
        if let address = venueDict["address_1"] as? String {
            self.address = address
        }
        if let name = venueDict["name"] as? String {
            self.name = name
        }
        if let city = venueDict["city"] as? String {
            self.city = city
        }
    }
}
