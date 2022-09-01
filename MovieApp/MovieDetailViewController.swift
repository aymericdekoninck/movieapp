

import UIKit

class MovieDetailViewController: UIViewController {

    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieSummary: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var score: UILabel!
    
    let movieItem: MovieItem
    
    init?(coder: NSCoder, movieItem: MovieItem){
        self.movieItem = movieItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieController.shared.fetchMovieDetail(forMovieId: movieItem.movieId)
        {(result) in
            switch result {
            case .success(let movieDetailItem):
                self.updateUI(with: movieDetailItem)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch details for movie with id \(self.movieItem.movieId)")
            }
        }
    }
    
    @IBAction func AddToWatchList(_ sender: UIButton) {
        MovieController.shared.watchlist.movieItems.append(movieItem)
    }
    
    func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message:
                   error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style:
                   .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    func updateUI(with movieDetailItem: MovieDetailItem) {
            DispatchQueue.main.async {
                self.movieTitle.text = movieDetailItem.title
                self.movieSummary.text = movieDetailItem.description
                self.status.text = movieDetailItem.status
                self.score.text = String(movieDetailItem.score)
                MovieController.shared.fetchImage(url: URL(string: "https://image.tmdb.org/t/p/w200" + movieDetailItem.backdrop)!)
                   { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        self.posterImageView.image = image
                    }
                }
            }
        }
}
