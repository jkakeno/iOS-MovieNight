//
//  JSONDecodable.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/5/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

protocol JSONDecodable {
//Potocole to enable models that adopt this protocole to be initialized by passing a json
    init?(json: [String: Any])
}
