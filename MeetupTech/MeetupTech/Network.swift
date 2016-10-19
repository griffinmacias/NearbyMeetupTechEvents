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
    func getTechEvents(completion: @escaping (Any) -> Void)  {
        Alamofire.request(Api.url, parameters: ["key": Api.key, "category": Api.tech, "lat": 40.650002, "lon": -73.949997, "radius": 5])
        .validate()
        .responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error while fetching results: \(response.result.error)")
                return
            }
            if let value = response.result.value {
                print("Value is in! \(value)")
                completion(value)
            }
        }
        
    }
}
