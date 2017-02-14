//
//  MovieViewController.swift
//  flicks
//
//  Created by John Law on 1/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var movies: [NSDictionary] = []
    var filteredMovies: [NSDictionary] = []
    var endpoint: String!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var networkErrorView: UIView!
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        networkErrorView.isHidden = true

        loadDataFromNetwork()
        //filteredMovies = movies
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest `myRequest` ...
        loadDataFromNetwork()
        refreshControl.endRefreshing()
    }
    
    func loadDataFromNetwork() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // Showing a progress HUDEdit PagePage History by MBProgressHUD
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //print(dataDictionary)
                    self.networkErrorView.isHidden = true

                    self.movies = (dataDictionary["results"] as! [NSDictionary])
                    self.filteredMovies = self.movies
                    self.tableView.reloadData()
                }
                
            }
            if error != nil {
                self.networkErrorView.isHidden = false
                /*
                let alertController = UIAlertController(title: "Error", message:
                    error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                */
                //print (error.debugDescription)
                //print (error?.localizedDescription as Any)
            }
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
        */
        return filteredMovies.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let imageUrl = URL(string: baseUrl + posterPath)
        let imageRequest = URLRequest(url: imageUrl!)

        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWith(imageUrl!)
        
        cell.posterView.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: {
                (imageRequest, imageResponse, image) -> Void in
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    //print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animate(withDuration: 0.3, animations: {
                        () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                }
                else {
                    //print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
        },
            
            failure: { (imageRequest, imageResponse, error) -> Void in
                
            }
        )

        //cell.selectionStyle = .none

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 224/255.0, green: 215/255.0, blue: 247/255.0, alpha: 1.00)
        cell.selectedBackgroundView = backgroundView
        

        return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredMovies = searchText.isEmpty ? movies : movies.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let title = movie["title"] as! String
            
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailViewController = segue.destination as? DetailViewController {
            let cell = sender as! MovieCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = filteredMovies[(indexPath?.row)!]
            
            detailViewController.movie = movie
            
            detailViewController.image = cell.posterView
        }
        else if let posterViewController = segue.destination as? PosterViewController {
            posterViewController.endpoint = endpoint
        }
    }
}
