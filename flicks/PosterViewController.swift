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

class PosterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var movies: [NSDictionary]?
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)

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
        
        // ... Create the URLRequest `myRequest` ...
        loadDataFromNetwork()
        refreshControl.endRefreshing()
    }

    func loadDataFromNetwork() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // Showing a progress HUDEdit PagePage History by MBProgressHUD
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //print(dataDictionary)
                    
                    self.movies = (dataDictionary["results"] as! [NSDictionary])
                    self.collectionView.reloadData()
                }
                
            }
            if error != nil {
                let alertController = UIAlertController(title: "Error", message:
                    error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                //print (error.debugDescription)
                //print (error?.localizedDescription as Any)
            }
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies![indexPath.row]
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        let imageUrl = URL(string: baseUrl + posterPath)
        cell.posterView.setImageWith(imageUrl!)
        
        return cell
    }
}
