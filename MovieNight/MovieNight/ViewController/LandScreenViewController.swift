//
//  ViewController.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/1/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class LandScreenViewController: UIViewController {

    @IBOutlet weak var user1: UIButton!
    @IBOutlet weak var user2: UIButton!
    @IBOutlet weak var viewResults: UIButton!
    var user1Preference:UserPreference?
    var user2Preference:UserPreference?
    let client = MovieDBClient()
    var user1PreferenceIsSet:Bool = false
    var user2PreferenceIsSet:Bool = false
    
    enum Button{
        case user1
        case user2
        case none
    }
    
    var button:Button = .none
    
    @IBAction func user1(_ sender: UIButton) {
        //Create user 1 preference
        user1Preference = UserPreference(genreId: nil, actorId: nil, minReleaseYear: nil, maxReleaseYear: nil)
        button = Button.user1
    }
    @IBAction func user2(_ sender: UIButton) {
        //Create user 2 preference
        user2Preference = UserPreference(genreId: nil, actorId: nil, minReleaseYear: nil, maxReleaseYear: nil)
        button = Button.user2
    }
    @IBAction func viewResults(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewResults.isHidden = true

        //Get user 1 preferences
        if let user1Preference = user1Preference, let user1GenrePreference = user1Preference.genreId, let user1ActorPreference = user1Preference.actorId, let user1MinReleaseYearPreference = user1Preference.minReleaseYear, let user1MaxReleaseYearPreference = user1Preference.maxReleaseYear{
            print("User 1 genre preference: \(user1GenrePreference)")
            print("User 1 actor preference: \(user1ActorPreference)")
            print("User 1 min release year preference: \(user1MinReleaseYearPreference)")
            print("User 1 max release year preference: \(user1MaxReleaseYearPreference)")
            
            //Remove user 1 default image
            user1.setBackgroundImage(nil, for: .normal)
            //Set user 1 new image
            user1.setImage(UIImage(named: "BubbleSelected"), for: UIControl.State.normal)
         
            user1PreferenceIsSet = true
        }
        
        //Get user 2 preferences
        if let user2Preference = user2Preference, let user2GenrePreference = user2Preference.genreId, let user2ActorPreference = user2Preference.actorId, let user2MinReleaseYearPreference = user2Preference.minReleaseYear, let user2MaxReleaseYearPreference = user2Preference.maxReleaseYear{
            print("User 2 genre preference: \(user2GenrePreference)")
            print("User 2 actor preference: \(user2ActorPreference)")
            print("User 2 min release year preference: \(user2MinReleaseYearPreference)")
            print("User 2 max release year preference: \(user2MaxReleaseYearPreference)")
            
            //Remove user 1 default image
            user2.setBackgroundImage(nil, for: .normal)
            //Set user 1 new image
            user2.setImage(UIImage(named: "BubbleSelected"), for: UIControl.State.normal)
            
            user2PreferenceIsSet = true
        }
        
        
        if user1PreferenceIsSet && user2PreferenceIsSet{
            viewResults.isHidden = false
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the segue that was speficied in story board
        if segue.identifier == "genres" {
            //Get a navigation controller
            let navigationController = segue.destination as! UINavigationController
            //Get the task controller
            let genresViewController = navigationController.topViewController as! GenresViewController

            switch button{
            case .user1:
                //Pass user 1 preference to genre view controller
                genresViewController.button = .user1

            case .user2:
                //Pass user 2 preference to genre view controller
                genresViewController.button = .user2

            case .none:return
            }
            
            genresViewController.user1Preference = user1Preference
            genresViewController.user2Preference = user2Preference
            
        }else if segue.identifier == "movies" {
            //Get a navigation controller
            let navigationController = segue.destination as! UINavigationController
            //Get the task controller
            let moviesViewController = navigationController.topViewController as! MoviesViewController
            guard let user1Genre = user1Preference?.genreId else{
                return
            }
            guard let user2Genre = user2Preference?.genreId else{
                return
            }
            guard let user1Actor = user1Preference?.actorId else{
                return
            }
            guard let user2Actor = user2Preference?.actorId else{
                return
            }
            guard let user1PreferenceMinReleaseYear = user1Preference?.minReleaseYear else{
                return
            }
            guard let user2PreferenceMinReleaseYear = user2Preference?.minReleaseYear else{
                return
            }
            guard let user1PreferenceMaxReleaseYear = user1Preference?.maxReleaseYear else{
                return
            }
            guard let user2PreferenceMaxReleaseYear = user2Preference?.maxReleaseYear else{
                return
            }
            let minReleaseYear = min(user1PreferenceMinReleaseYear,user2PreferenceMinReleaseYear)
            let maxReleaseYear = max(user1PreferenceMaxReleaseYear,user2PreferenceMaxReleaseYear)
            let combinedPreference = UserPreference(user1Genre: user1Genre, user2Genre: user2Genre, user1Actor: user1Actor, user2Actor: user2Actor, minReleaseYear: minReleaseYear, maxReleaseYear: maxReleaseYear)
            
            //Pass both user's preferences to movie view controller
            moviesViewController.combinedPreference = combinedPreference
            
            print("Combined preference genre: \(user1Genre), \(user2Genre)")
            print("Combined preference actor: \(user1Actor), \(user2Actor)")
            print("Combined preference min release year: \(minReleaseYear)")
            print("Combined preference max release year: \(maxReleaseYear)")
            }
        }
    }


