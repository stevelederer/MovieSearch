//
//  MoviesTableViewController.swift
//  MovieSearch
//
//  Created by Steve Lederer on 12/14/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    // MARK: - Properties
    var movies: [Movie] = [] //source of truth
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .words
        searchController.searchBar.autocorrectionType = .yes
        searchController.searchBar.placeholder = "Search a movie..."
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
}

extension MoviesTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        
        MovieController.fetchMovie(with: searchTerm) { (movies) in
            guard let fetchedMovies = movies else { return }
            self.movies = fetchedMovies
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.hidesSearchBarWhenScrolling = true
                searchBar.text = nil
            }
        }
    }
}
