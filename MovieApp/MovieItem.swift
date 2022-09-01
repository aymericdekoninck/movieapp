

import Foundation

struct MovieItem: Codable, Hashable {
    
    var movieId: Int
    var posterURL: String?
    var title: String
    
    enum CodingKeys: String, CodingKey{
        case movieId = "id"
        case posterURL = "poster_path"
        case title = "original_title"
    }
}

struct SearchResponse: Codable {
    let results: [MovieItem]
}
