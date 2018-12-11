//
//  MovieDataSource.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/7/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class MovieDataSource:NSObject,UITableViewDataSource{
    
    private var movies = [Movie]()
    //Make image data an optional because image data depends of movies
    private var images: [Data]?
    
    override init() {
        super.init()
    }
    
    func update(withMovies movies: [Movie], withImages images: [Data]) {
        self.movies = movies
        self.images = images
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        //Get an artist from the artist array
        let movie = movies[indexPath.row]
        //Display the artist name in the prototype cell of the table view
        cell.textLabel?.text = movie.title
        
        guard let imageData = self.images else {
            return cell
        }
        //Only populate the images to the image view when the number of images are more than the available rows to avoid out of index error
        if indexPath.row < imageData.count {
            cell.imageView?.image = UIImage(data:imageData[indexPath.row])
        }
        
        //return the cell to the table view
        return cell
    }
    
    //Helper to get a movie from the list
    func movie(at indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }
    
    //Helper to get a movie from the list
    func movieImage(at indexPath: IndexPath) -> Data {
        return images![indexPath.row]
    }
}
