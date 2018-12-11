//
//  Client.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/5/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed! Please check your internet connection."
        case .invalidData: return "Invalid Data! Please try again later."
        case .responseUnsuccessful: return "Response Unsuccessful! Please try again later."
        case .jsonParsingFailure: return "JSON Parsing Failure! There's no data available matching the current user preference. Please make a different selection and try again."
        case .jsonConversionFailure: return "JSON Conversion Failure! Please try again later."
        }
    }
}

protocol APIClient {
    var session: URLSession { get }
}

//This protocol has methods to make asynchronos task. It makes REST API call and gets the response from the server.
extension APIClient{
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (JSON?, APIError?) -> Void
    
    //Asynchronos network call
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        //Make a call to API
        let task = session.dataTask(with: request) { data, response, error in
            
            //Get a HTTP response by casting the generic response to HTTPURLResponse.
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                
                return
            }
            
            //Check that the API call response is ok
            if httpResponse.statusCode == 200 {
                //Get the data from the data task.
                if let data = data {
                    do {
                        //Get the json from the call response
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    //Fetch single item
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        
        //Execute asynchronos network call
        let task = jsonTask(with: request) { json, error in
            //Switch to main thread once json is obtained
            DispatchQueue.main.async {
                //Handle errors
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
                //Parse json into model
                if let value = parse(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
    //Fetch array of items
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) -> [T], completion: @escaping (Result<[T], APIError>) -> Void) {
        
        //Execute asynchronos network call
        let task = jsonTask(with: request) { json, error in
            //Switch to main thread once json is obtained
            DispatchQueue.main.async {
                //Handle errors
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
                //Parse json into model
                let value = parse(json)
                if !value.isEmpty {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
}
