//
//  MovieDBClient.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/5/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

//This class implements APIClient protocol to make REST API call specific to the service (TheMovieDB).
class MovieDBClient: APIClient{

    var session: URLSession
    
    //APIClient init
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    //Convinience init method init API with default configuration
    convenience init() {
        self.init(configuration: .default)
    }
    
    //Get genres from API
    func genres(completion: @escaping (Result<[Genre],APIError>) -> Void){
        let endPoint = MovieDB.genres
        let request = endPoint.request
        print("Endpoint is: \(endPoint)")
        print("Request is: \(request)")
        
        //Fetch genres
        fetch(with: request, parse: { json -> [Genre] in
            guard let genres = json["genres"] as? [[String:Any]] else {return []}
            return genres.compactMap { Genre(json:$0) }
        },completion: completion)
    }
    
    func actors(completion: @escaping (Result<[Actor],APIError>)->Void){
        let endPoint = MovieDB.actors
        let request = endPoint.request
        print("Endpoint is: \(endPoint)")
        print("Request is: \(request)")
        
        //Fetch actors
        fetch(with: request, parse: { json -> [Actor] in
        guard let genres = json["results"] as? [[String:Any]] else {return []}
        return genres.compactMap { Actor(json:$0) }
        },completion: completion)
    }
    
    //MARK - Commonize the release date convention accross the app to releaseDateGTE and releaseDateLTE
    
    func movies(releaseDateGTE:String,releaseDateLTE:String,user1Genre:Int,user2Genre: Int, user1Actor:Int,user2Actor:Int,completion: @escaping (Result<[Movie],APIError>)->Void){
        let endPoint = MovieDB.movies(releaseDateGTE: releaseDateGTE, releaseDateLTE: releaseDateLTE, user1Genre: user1Genre,user2Genre: user2Genre,user1Actor: user1Actor,user2Actor: user2Actor)
        let request = endPoint.request
        print("Endpoint is: \(endPoint)")
        print("Request is: \(request)")
        
        //Fetch actors
        fetch(with: request, parse: { json -> [Movie] in
            guard let movies = json["results"] as? [[String:Any]] else {return []}
            return movies.compactMap { Movie(json:$0) }
        },completion: completion)
    }
}
