//
//  MoviesViewController.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/7/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController {

    let dataSource = MovieDataSource()
    let client = MovieDBClient()
    let clientTMDB = TMDBClient()
    var combinedPreference:UserPreference?
    var movies:[Movie]=[]
    var images:[Data]=[]
    var movie:Movie?
    var movieImage:Data?
    
    enum AlertType {
        case error
        case alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let combinedPreference = combinedPreference, let user1Genre = combinedPreference.user1Genre, let user2Genre = combinedPreference.user2Genre, let user1Actor = combinedPreference.user1Actor, let user2Actor = combinedPreference.user2Actor,let releaseMax = combinedPreference.maxReleaseYear, let releaseMin = combinedPreference.minReleaseYear else {
            return
        }
        
        //Call API to get movie list
        client.movies(releaseDateGTE: releaseMin, releaseDateLTE: releaseMax, user1Genre: user1Genre, user2Genre: user2Genre, user1Actor: user1Actor, user2Actor: user2Actor){[weak self] result in
            switch result{
            case .success(let movies):
                print("Movies array size: \(movies.count)")
                for movie in movies{
                    self?.clientTMDB.fetchImage(from: movie.posterPath){ data, response, error in
                        guard let imageData = data else { return }
                        print(movie.title)
                        self?.movies.append(movie)
                        print("Image Download \(imageData) Finished")
                        self?.images.append(imageData)
                        
                        guard let movies = self?.movies,let images = self?.images else {
                            return
                        }
                        
                        print("Movie image array size: \(images.count)")
                        
                        DispatchQueue.main.async() {
                            self?.dataSource.update(withMovies:movies, withImages: images)
                            self?.tableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print("Movies view controller : \(error)")
                self?.showAlert(type:.error,message: "\(error.localizedDescription)")
            }
        }
        tableView.dataSource = dataSource
    }

    //Detect selected row from list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            movie = dataSource.movie(at: indexPath)
            movieImage = dataSource.movieImage(at: indexPath)
            guard let movie = movie, let movieImage = movieImage else {
                return
            }
            print("Selected Movie title: \(movie.title)")
            
            //Navigate to MovieDetailViewController and pass the movie and the movie image
            let movieDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
            movieDetailViewController.movie = movie
            movieDetailViewController.movieImage = movieImage
            
        }else{
            print("Can't get index path")
        }
    }

    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //Get the segue that was speficied in story board
//        if segue.identifier == "movieDetail" {
//            print("Passed \(String(describing: movie?.title)) to movie detail view controller")
//            //Get a navigation controller
//            let movieDetailViewController = segue.destination as! MovieDetailViewController
//            movieDetailViewController.movie = self.movie
//        }
//    }
    
    func showAlert(type: AlertType, message:String){
        let alert:UIAlertController
        switch type {
        case .error:
            alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("\"OK\" button was pressed on alert.")
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
