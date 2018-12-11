//
//  Result.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/5/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
