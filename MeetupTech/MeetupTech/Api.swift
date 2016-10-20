//
//  ApiKey.swift
//  MeetupTech
//
//  Created by Mason Macias on 10/19/16.
//  Copyright © 2016 griffinmacias. All rights reserved.
//

import Foundation

struct Api {
    static let url = "https://api.meetup.com/2/open_events.json"
    static let key = "YOUR-API-KEY"
    //34 number is for tech meetups
    static let tech = 34
    //Figured 5 miles was decent
    static let radius = 5
    static let fields = "group_photo"
}
