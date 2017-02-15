//
//  UseViewController.swift
//  flicks
//
//  Created by John Law on 13/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftGifOrigin

class UseViewController: UIViewController {

    var avPlayer: AVPlayer!

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "walkthrough.gif", withExtension: nil)!)
        self.imageView.image = UIImage.gif(data: imageData)
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
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        let videoURL = Bundle.main.url(forResource: "walkthrough.mov", withExtension: nil)!
        avPlayer = AVPlayer(url: videoURL as URL)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.layer.addSublayer(playerLayer)
        avPlayer.play()
        */
    }
}
