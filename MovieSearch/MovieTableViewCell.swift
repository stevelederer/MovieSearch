//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Steve Lederer on 12/14/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieSummaryTextView: UITextView!
    @IBOutlet weak var cellView: UIView!
    
    // MARK: - Dependency
    
    var movie: Movie? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCells()
    }
    
    // MARK: - Setup
    
    func updateViews() {
        guard let movie = movie else { return }
        DispatchQueue.main.async {
            self.movieTitleLabel.text = movie.title
            self.movieRatingLabel.text = "Rating: \(movie.rating)"
            self.movieSummaryTextView.text = movie.summary
        }
        MovieController.fetchPosterImage(with: movie) { (image) in
            DispatchQueue.main.async {
                self.movieImageView.image = image
            }
        }
    }
    
    
    func setupCells() {
        self.backgroundColor = .clear
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowOpacity = 0.4
        cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cellView.layer.shadowRadius = 7
        cellView.layer.shadowOffset = CGSize(width: 0, height: 2)
        movieImageView.clipsToBounds = true
        self.movieImageView.layer.cornerRadius = 10
    }
}

