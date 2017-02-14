//
//  DetailViewController.swift
//  flicks
//
//  Created by John Law on 7/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    var movie: NSDictionary!
    var image: UIImageView!

    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = false

        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true

        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        print (movie)

        let title = movie["title"] as? String
        titleLabel.text = title
        
        let release = movie["release_date"] as? String
        releaseLabel.text = release
        
        let rating = movie["vote_average"] as? Double
        ratingLabel.text = String(format:"%.1f", rating!) + "/10"
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            posterView.setImageWith(imageUrl!)
        }
        
        
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

    @IBAction func clickForDetail(_ sender: Any) {
        let id = movie["id"]
        let url =  URL(string: "https://www.themoviedb.org/movie/\(id!)")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)

    }
}
