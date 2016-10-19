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
    func getTechEvents(latitude: Double, longitude: Double, completion: @escaping (Any) -> Void)  {
        Alamofire.request(Api.url, parameters: ["key": Api.key, "category": Api.tech, "lat": latitude, "lon": longitude, "radius": Api.radius, "photo-host": Api.photoHost])
        .validate()
        .responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error while fetching results: \(response.result.error)")
                return
            }
            if let value = response.result.value as? [String: Any] {
                print("Value is in! \(value)")
                if let json = value["results"] as? [Any] {
                    for dict in json {
                        if let meetupDict = dict as? [String: Any], let meetup = Meetup.init(json: meetupDict) {
                            
                        }
                    }
                } else {
                    
                }
                completion(value)
            }
        }
        
    }
}
