

import Foundation

struct MovieDetailItem: Codable {
    
    var title: String
    var description: String
    var score: Double
    var status: String
    var backdrop: String
    
    enum CodingKeys: String, CodingKey{
        case title
        case description = "overview"
        case score = "vote_average"
        case status
        case backdrop = "backdrop_path"
    }
    
}
