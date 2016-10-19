//
//  Network.swift
//  MeetupTech
//
//  Created by Mason Macias on 10/19/16.
//  Copyright © 2016 griffinmacias. All rights reserved.
//

import Foundation

final class Network {
    static let sharedInstance = Network()
    private init() {} //Prevents others from using the default () init
}
