//
//  Network.swift
//  MeetupTech
//
//  Created by Mason Macias on 10/19/16.
//  Copyright © 2016 griffinmacias. All rights reserved.
//

import Foundation
import Alamofire

final class Network {
    
    static let sharedInstance = Network()
    private init() {} //Prevents others from using the default () init
    
    func getTechEvents(latitude: Double, longitude: Double, completion: @escaping ([Meetup]?) -> Void)  {
        assert(Api.key == "YOUR-API-KEY" ? false : true, "Please enter API Key in the Api.Swift")
        Alamofire.request(Api.url, parameters: [
            "key": Api.key,
            "category": Api.tech,
            "radius": Api.radius,
            "fields": Api.fields,
            "lat": latitude,
            "lon": longitude
            ])
        .validate()
        .responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error while fetching results: \(response.result.error)")
                completion(nil)
                return
            }
            if let value = response.result.value as? [String: Any], let json = value["results"] as? [Any] {
                print("Value is in! \(value)")
                var meetups: [Meetup] = []
                for dict in json {
                    if let meetupDict = dict as? [String: Any],
                        let meetup = Meetup.init(json: meetupDict) {
                        meetups.append(meetup)
                    }
                }
                completion(meetups)
            }
        }
    }
}
