//
//  UseViewController.swift
//  flicks
//
//  Created by John Law on 13/2/2017.
//  Copyright © 2017 Chi Hon Law. All rights reserved.
//

import UIKit
import AVFoundation

class UseViewController: UIViewController {

    var avPlayer: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        //let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        //let videoURL = NSURL(fileURLWithPath: "/Users/johnlaw/Projects/CodePath/flicks/flicks/walkthrough.mov")
        let videoURL = NSURL(fileURLWithPath: "Use")
        avPlayer = AVPlayer(url: videoURL as URL)
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.layer.addSublayer(playerLayer)
        avPlayer.play()
    }
}
