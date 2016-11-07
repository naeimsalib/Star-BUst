//
//  GameViewController.swift
//  StarBust_
//
//  Created by naeim on 10/27/16.
//  Copyright © 2016 naeim. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import iAd
import GoogleMobileAds

var admobDelegate = AdMobDelegate()
var currentVc: UIViewController!

class GameViewController: UIViewController,GADBannerViewDelegate,GADInterstitialDelegate {


   
    
    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()


        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-1782852253088296/3170701568"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        
        
        
        
        currentVc = self
       
        
    
        
        if let view = self.view as! SKView? {
            
            
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = StartMenu(fileNamed: "StartMenu") {
                
               admobDelegate.
                 admobDelegate.showAd()
                
               let skView = self.view as! SKView
                scene.size = skView.bounds.size 
                
                skView.ignoresSiblingOrder = true
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                
            }
            
            view.ignoresSiblingOrder = true
            
          //  view.showsFPS = true
          //  view.showsNodeCount = true
         //   view.showsPhysics = true
        }
    }

   
}



    

    
    
    

