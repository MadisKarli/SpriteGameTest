//
//  GameViewController.swift
//  SpriteGameTest
//
//  Created by Madis-Karli Koppel on 10/08/16.
//  Copyright (c) 2016 Papple Inc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
 

    override func viewDidLoad() {
        super.viewDidLoad()

        /*if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }*/
    }
    
    override func viewWillLayoutSubviews() {
        let skView: SKView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.multipleTouchEnabled = false        
        
        let scene:SKScene = GameScene(size: skView.bounds.size)
        //TODO: muuda suurust
        //let scene:SKScene = GameScene(size: cgSize())
        scene.scaleMode = SKSceneScaleMode.AspectFill
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
