//
//  GenreViewController.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/1/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class GenresViewController: UITableViewController {
    
    let dataSource = GenreDataSource()
    let client = MovieDBClient()
    var user1Preference:UserPreference?
    var user2Preference:UserPreference?
    
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
        //Call API to get genre list
        client.genres(){[weak self] result in
            switch result{
            case .success(let genres):
                self?.dataSource.update(with:genres)
                self?.tableView.reloadData()
            case .failure(let error):
                print("Genres view controller : \(error)")
                self?.showAlert(type:.error,message: "\(error.localizedDescription)")
            }
        }
        tableView.dataSource = dataSource
    }
    

    //Detect selected row from list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let genre = dataSource.genre(at: indexPath)
            switch button{
            case .user1:
                //Store genre id to user 1 preference
                user1Preference?.genreId = genre.id
            case .user2:
                //Store genre id to user 2 preference
                user2Preference?.genreId = genre.id
            case .none: return
            }
        }else{
            print("Can't get index path")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch button{
        case .user1:
            if user1Preference?.genreId == nil{
                showAlert(type:.alert,message: "Select a genre")
                return false
            }else{
                return true
            }
        case .user2:
            if user2Preference?.genreId == nil{
                showAlert(type:.alert,message: "Select a genre")
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
        if segue.identifier == "actors" {
            //Get a navigation controller
            let navigationController = segue.destination as! UINavigationController
            //Get the task controller
            let actorsViewController = navigationController.topViewController as! ActorsViewController
            
            switch button{
            case .user1:
                //Pass user 1 preference to actor view controller
                actorsViewController.button = .user1

            case .user2:
                //Pass user 2 preference to actor view controller
                actorsViewController.button = .user2
                
            case .none: return
            }
            actorsViewController.user1Preference = user1Preference
            actorsViewController.user2Preference = user2Preference
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
