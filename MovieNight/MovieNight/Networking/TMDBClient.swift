//
//  TMDBClient.swift
//  MovieNight
//
//  Created by Jun Kakeno on 12/7/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

class TMDBClient{
    
    init(){
    }
    
    func fetchImage(from url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        //Create the request url
        let endPoint = TMDB.image(image: url)
        let request = endPoint.request
        print("Image request is: \(request)")
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
}
