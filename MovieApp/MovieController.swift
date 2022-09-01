

import Foundation
import UIKit

class MovieController {

    static let shared = MovieController()
    
    var watchlist = WatchList(){
        didSet {
            NotificationCenter.default.post(name: MovieController.watchListUpdateNotification, object: nil)
        }
    }
    
    static let watchListUpdateNotification = Notification.Name("MenuController.watchListUpdated")

    
    let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    let apiKey = "ada15e0325b53c9af38ad4b0db239241"

    func fetchMovieItems(forSearchKey searchKey: String, completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        let initialSearchURL = baseURL.appendingPathComponent("search").appendingPathComponent("movie")
        
        var components = URLComponents(url: initialSearchURL,
            resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "api_key",
            value: apiKey), URLQueryItem(name: "query", value: searchKey)]
        let searchURL = components.url!
        
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
        if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let searchResponse = try
                       jsonDecoder.decode(SearchResponse.self,
                       from: data)
                    completion(.success(searchResponse.results))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchMovieDetail(forMovieId movieId: Int, completion: @escaping (Result<MovieDetailItem, Error>) -> Void){
        let initialSearchURL = baseURL.appendingPathComponent("movie").appendingPathComponent("\(movieId)")
        print(initialSearchURL)
        
        var components = URLComponents(url: initialSearchURL,
            resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "api_key",
            value: apiKey)]
        let detailURL = components.url!
        print(detailURL)
        let task = URLSession.shared.dataTask(with: detailURL) { (data, response, error) in
        if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let Response = try
                       jsonDecoder.decode(MovieDetailItem.self,
                       from: data)
                    completion(.success(Response))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?)
       -> Void) {
        let task = URLSession.shared.dataTask(with: url)
           { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
}
