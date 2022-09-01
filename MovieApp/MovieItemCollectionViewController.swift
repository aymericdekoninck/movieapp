
import UIKit

private let reuseIdentifier = "Poster"

class MovieItemCollectionViewController: UICollectionViewController, UISearchResultsUpdating {

    let searchController = UISearchController()
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, MovieItem >!

    enum Section: CaseIterable {
        case main
    }
    
    var movieItems = [MovieItem]()
    
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Section, MovieItem> {
            var snapshot = NSDiffableDataSourceSnapshot<Section, MovieItem>()
        
        snapshot.appendSections([.main])
            snapshot.appendItems(movieItems)
        
            return snapshot
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        createDataSource()
    }
    
    
    @IBSegueAction func ShowMovieDetail(_ coder: NSCoder, sender: Any?) -> MovieDetailViewController? {
        
        guard let cell = sender as? UICollectionViewCell,
              let indexPath = collectionView.indexPath(for:cell)
        else{
            return nil
        }
        let movieItem = movieItems[indexPath.row]
        return MovieDetailViewController(coder: coder, movieItem: movieItem )
    }
    
    func createDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, MovieItem>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieItemCollectionViewCell
            
            
            if let url = item.posterURL{
            MovieController.shared.fetchImage(url: URL(string: "https://image.tmdb.org/t/p/w200" + url)!)
               { (image) in
                guard let image = image else { return }
                   DispatchQueue.main.async {
                       cell.moviePoster.image = image
                   }
               }
            }
                
            
            return cell
                                                                                          }
        )
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchMovieItems), object: nil)
        perform(#selector(fetchMovieItems), with: nil, afterDelay: 0.3)
    }
    
    @objc func fetchMovieItems() {
        let searchTerm = searchController.searchBar.text ?? ""
        guard searchTerm.isEmpty == false else {
            movieItems = []
            collectionViewDataSource.apply(filteredItemsSnapshot, animatingDifferences: true)
            return
        }
        
        MovieController.shared.fetchMovieItems(forSearchKey: searchTerm){ (result) in
            DispatchQueue.main.async {
                guard searchTerm == self.searchController.searchBar.text else {
                    return
                }
                switch result {
                case .success(let items):
                    self.movieItems = items
                case .failure(let error):
                    self.displayError(error, title: "Failed to fetch movies")
                }
                self.collectionViewDataSource.apply(self.filteredItemsSnapshot, animatingDifferences: true)
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
               message: error.localizedDescription,preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Dismiss",
                     style: .default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
        }
    }

    private func generateLayout() -> UICollectionViewLayout {
        let itemSize =
           NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
           heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize =
           NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
           heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
           groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8,
           bottom: 8, trailing: 8)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
