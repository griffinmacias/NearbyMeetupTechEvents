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
    init?(json: [String: Any]) {
        guard let group = json["group"] as? [String: Any],
            let name = group["name"] as? String else { return nil }
        self.name = name
    }
}
