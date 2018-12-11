//
//  ActorsViewController.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/6/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class ActorsViewController: UITableViewController {

    let dataSource = ActorDataSource()
    let client = MovieDBClient()
    let clientTMDB = TMDBClient()
    var user1Preference: UserPreference?
    var user2Preference:UserPreference?
    var actors:[Actor]=[]
    var images:[Data]=[]
    

    enum Button{
        case user1
        case user2
        case none
    }
    
    enum AlertType {
        case error
        case alert
    }
    
    var button:Button = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call API to get actor list
        client.actors(){[weak self] result in
            switch result{
            case .success(let actors):
                print("Actor array size: \(actors.count)")
                for actor in actors{
                    self?.clientTMDB.fetchImage(from: actor.imageUrl){ data, response, error in
                        guard let imageData = data else { return }
                        print(actor.name)
                        self?.actors.append(actor)
                        print("Image Download \(imageData) Finished")
                        self?.images.append(imageData)
                        
                        guard let actors = self?.actors,let images = self?.images else {
                            return
                        }
                        
                        print("Actor image array size: \(images.count)")

                        DispatchQueue.main.async() {
                            self?.dataSource.update(withActors:actors, withImages: images)
                            self?.tableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print("Actors view controller : \(error)")
                self?.showAlert(type:.error,message: "\(error.localizedDescription)")
            }
        }
        tableView.dataSource = dataSource
    }

    //Detect selected row from list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let actor = dataSource.actor(at: indexPath)
            
            switch button{
            case .user1:
                //Store actor id to user 1 preference
                user1Preference?.actorId = actor.id
            case .user2:
                //Store actor id to user 2 preference
                user2Preference?.actorId = actor.id
            case .none: return
            }
            
        }else{
            print("Can't get index path")
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch button{
        case .user1:
            if user1Preference?.actorId == nil{
                showAlert(type:.alert,message: "Select an actor")
                return false
            }else{
                return true
            }
        case .user2:
            if user2Preference?.actorId == nil{
                showAlert(type:.alert,message: "Select an actor")
                return false
            }else{
                return true
            }
        case .none: return false
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the segue that was speficied in story board
        if segue.identifier == "releaseYear" {
            //Get a navigation controller
            let navigationController = segue.destination as! UINavigationController
            //Get the task controller
            let releaseYearViewController = navigationController.topViewController as! ReleaseYearViewController

            switch button{
            case .user1:
                //Pass user 1 preference to release year view controller
                releaseYearViewController.button = .user1
                
            case .user2:
                //Pass user 2 preference to release year view controller
                releaseYearViewController.button = .user2
                
            case .none: return
            }
            releaseYearViewController.user1Preference = user1Preference
            releaseYearViewController.user2Preference = user2Preference
        }
    }
    
    func showAlert(type: AlertType, message:String){
        let alert:UIAlertController
        switch type {
        case .error:
            alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("\"OK\" button was pressed on alert.")
                self.dismiss(animated: true, completion: nil)
            }))
        case .alert:
            alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("\"OK\" button was pressed on alert.")
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

