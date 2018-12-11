//
//  Enpoint.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/5/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation
//API Key 3fbfeaf8eef9df5036f08387a9b24695
//https://api.themoviedb.org/3/genre/movie/list?api_key=3fbfeaf8eef9df5036f08387a9b24695
//https://api.themoviedb.org/3/person/popular?api_key=3fbfeaf8eef9df5036f08387a9b24695
//https://api.themoviedb.org/3/discover/movie?api_key=3fbfeaf8eef9df5036f08387a9b24695&primary_release_date.gte=1990&primary_release_date.lte=2010&with_genres=28%7C12&with_people=27205%7C49026
//or
//https://api.themoviedb.org/3/discover/movie?api_key=3fbfeaf8eef9df5036f08387a9b24695&primary_release_date.gte=1990&primary_release_date.lte=2010&with_genres=28|12&with_people=27205|49026
//Resource: https://www.swiftbysundell.com/posts/constructing-urls-in-swift


protocol Endpoint {
    //Base url
    var base: String { get }
    //Path for the API call
    var path: String { get }
}

extension Endpoint {
    //Create the url containing base and path
    var url:URL{
        let url = URL(string: base + path)!
        return url
    }
    
    //Create the url request
    var request: URLRequest{
        let url = self.url
        return URLRequest(url:url)
    }
}

//MovieDB call categories
enum MovieDB {
    case genres
    case actors
    case movies(releaseDateGTE: String, releaseDateLTE: String, user1Genre: Int, user2Genre: Int,user1Actor: Int, user2Actor: Int)
}

//Return the endpoint for each MovieDB categories
extension MovieDB:Endpoint{
    var base: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .genres:
            return "/3/genre/movie/list?api_key=3fbfeaf8eef9df5036f08387a9b24695"
        case .actors:
            return "/3/person/popular?api_key=3fbfeaf8eef9df5036f08387a9b24695"
        case .movies(let releaseDateGTE, let releaseDateLTE, let user1Genre, let user2Genre, let user1Actor, let user2Actor):
            return "/3/discover/movie?api_key=3fbfeaf8eef9df5036f08387a9b24695&primary_release_date.gte=\(releaseDateGTE)&primary_release_date.lte=\(releaseDateLTE)&with_genres=\(user1Genre)%7C\(user2Genre)&with_people=\(user1Actor)%7C\(user2Actor)"
        }
    }
}

enum TMDB{
    case image(image:String)
}

extension TMDB:Endpoint{
    var base: String {
        return "https://image.tmdb.org/t/p/w500"
    }
    
    var path: String{
        switch self {
        case .image(let image):
            return "\(image)"
        }
    }
}

