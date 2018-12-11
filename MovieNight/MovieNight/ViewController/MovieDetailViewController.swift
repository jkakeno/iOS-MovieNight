//
//  MovieDetailController.swift
//  MovieNight
//
//  Created by Jun Kakeno on 12/7/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {


    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var vote: UILabel!
    @IBOutlet weak var overview: UITextView!
    
    var movie:Movie?
    var movieImage:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = self.movie, let movieImage = self.movieImage else {
            return
        }
        
        
        movieTitle.text = movie.title
        releaseDate.text = movie.release
        vote.text = String(format:"%f", movie.vote)
        overview.text = movie.overview
        imageView.image = UIImage(data:movieImage)
        
        print("Movie image is: \(movie.posterPath)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
