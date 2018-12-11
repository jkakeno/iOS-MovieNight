//
//  ActorDataSource.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/6/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class ActorDataSource:NSObject,UITableViewDataSource{
    
    private var actors = [Actor]()
    //Make image data an optional because image data depends of actors
    private var images: [Data]?
    let client = MovieDBClient()
    
    override init() {
        super.init()
    }
    
    func update(withActors actors: [Actor], withImages images: [Data]) {
        self.actors = actors
        self.images = images
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActorCell", for: indexPath)
        //Get an artist from the artist array
        let actor = actors[indexPath.row]
        //Display the artist name in the prototype cell of the table view
        cell.textLabel?.text = actor.name
        
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
    
    //Helper to get a actor from the list
    func actor(at indexPath: IndexPath) -> Actor {
        return actors[indexPath.row]
    }
}
