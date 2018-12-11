//
//  GenreDataSource.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/2/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class GenreDataSource:NSObject,UITableViewDataSource{

    private var genres = [Genre]()
    
    override init() {
        super.init()
    }
    
    func update(with genres: [Genre]) {
        self.genres = genres
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath)
        //Get an artist from the artist array
        let genre = genres[indexPath.row]
        //Display the artist name in the prototype cell of the table view
        cell.textLabel?.text = genre.name
        //return the cell to the table view
        return cell
    }
    
    //Helper to get a genre from the list
    func genre(at indexPath: IndexPath) -> Genre {
        return genres[indexPath.row]
    }
}
