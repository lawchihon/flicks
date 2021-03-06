//
//  PosterViewController.swift
//  flicks
//
//  Created by John Law on 2/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class PosterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var endpoint: String!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkErrorView: UIView!
    
    lazy var refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        collectionView.refreshControl = self.refreshControl
        
       // collectionView.insertSubview(refreshControl, at: 0)

        networkErrorView.isHidden = true
        loadDataFromNetwork()
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
                  //  self.refreshControl.endRefreshing()

                    self.collectionView.reloadData()

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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = filteredMovies![indexPath.row]
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let originalBase = "https://image.tmdb.org/t/p/original"

        let imageUrl = URL(string: baseUrl + posterPath)
        let originalUrl = URL(string: originalBase + posterPath)

        let imageRequest = URLRequest(url: imageUrl!)
        let originalRequest = URLRequest(url: originalUrl!)

        //cell.posterView.setImageWith(imageUrl!)

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
                        }, completion: { (sucess) -> Void in

                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            cell.posterView.setImageWith(
                                originalRequest,
                                placeholderImage: image,
                                success: { (originalImageRequest, originalImageResponse, originalImage) -> Void in
                                    
                                    cell.posterView.image = originalImage;
                                    
                            },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
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
        filteredMovies = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let title = movie["title"] as! String
            
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        collectionView.reloadData()
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
            let cell = sender as! PosterCell
            let indexPath = collectionView.indexPath(for: cell)
            let movie = filteredMovies![(indexPath?.row)!]

            detailViewController.movie = movie
            
            detailViewController.image = cell.posterView
        }
        else if let tableViewController = segue.destination as? MovieViewController {
            tableViewController.endpoint = endpoint
        }
    }

}
