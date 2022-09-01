

import UIKit

class WatchListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MovieController.watchListUpdateNotification, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieController.shared.watchlist.movieItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WatchItem", for: indexPath)
        let movieItem = MovieController.shared.watchlist.movieItems[indexPath.row]
        cell.textLabel?.text = movieItem.title
        
        if let url = movieItem.posterURL{
        MovieController.shared.fetchImage(url: URL(string: "https://image.tmdb.org/t/p/w200" + url)!)
           { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for:
                   cell),
                    currentIndexPath != indexPath {
                    return
                }
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MovieController.shared.watchlist.movieItems.remove(at: indexPath.row)
        }
    }

}
