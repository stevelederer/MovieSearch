//
//  MovieController.swift
//  MovieSearch
//
//  Created by Steve Lederer on 12/14/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class MovieController {
    static let baseMovieURL = URL(string: "https://api.themoviedb.org/")
    static let baseImageURL = URL(string: "https://image.tmdb.org")
    
    private static let apiKey = "aa6a29c725f049d265eb3253d907d147"
    
    // MARK: - Fetching
    // URL SHOULD LOOK LIKE THIS: https://api.themoviedb.org/3/search/movie?api_key=aa6a29c725f049d265eb3253d907d147&query=Jack+Reacher
    static func fetchMovie(with searchTerm: String, completion: @escaping ([Movie]?) -> Void) {
        // URL
        guard let url = baseMovieURL?.appendingPathComponent("3").appendingPathComponent("search").appendingPathComponent("movie") else { completion(nil); return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: apiKey)
        let searchTermQueryItem = URLQueryItem(name: "query", value: searchTerm)
        components?.queryItems = [apiKeyQueryItem, searchTermQueryItem]
        
        guard let requestURL = components?.url else { completion(nil) ; return }
        
        print("📡📡📡 Movie URL: \(requestURL.absoluteString) 📡📡📡")
        
        // REQUEST
        let request = URLRequest(url: requestURL)
        
        // DataTask + RESUME
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("❌ There was an error in \(#function) ; \(error.localizedDescription) ❌")
                completion (nil)
                return
            }
            //            print(response ?? "no response for movie")
            
            guard let data = data else { completion(nil) ; return }
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                let movies = topLevelDictionary.results
                completion(movies)
            } catch {
                print("❌ There was an error in \(#function) ; \(error.localizedDescription)❌")
                completion(nil)
                return
            }
            }.resume()
    }
    
    static func fetchPosterImage(with movie: Movie, completion: @escaping (UIImage?) -> Void) {
        
        // URL
        // URL SHOULD LOOK LIKE THIS: https://image.tmdb.org/t/p/w500//38bmEXmuJuInLs9dwfgOGCHmZ7l.jpg
        if let posterPath = movie.posterPath {
            guard let imageURL = baseImageURL?.appendingPathComponent("t").appendingPathComponent("p").appendingPathComponent("w500").appendingPathComponent(posterPath) else { completion(nil) ; return }
            print("📡📡📡 Image URL:\(imageURL.absoluteString) 📡📡📡")
            
            let request = URLRequest(url: imageURL)
            
            URLSession.shared.dataTask(with: request) { (imageData, response, error) in
                if let error = error {
                    print("❌ There was an error in \(#function) ; \(error.localizedDescription) ❌")
                    completion(nil)
                    return
                }
                //            print(response ?? "no response for poster image")
                
                guard let imageData = imageData else { completion(nil) ; return }
                
                let posterImage = UIImage(data: imageData)
                
                completion(posterImage)
            }.resume()
        } else {
            completion(UIImage(named: "none"))
//            print("no image found")
            return
        }
    }
}
