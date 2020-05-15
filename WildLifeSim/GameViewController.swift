//
//  GameViewController.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 14.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

// Ground class code
let countColumns = 30
let countRows = 15
let sizeTile = 90
let earth = Ground()
let env = Environment()

/*extension GameViewController: SKSceneDelegate {
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        if makeNodeModifications {
            makeNodeModifications = false
            
            env.calcFood(map: earth)
        }
    }
}*/

class GameViewController: UIViewController {
    
    /*let queue = DispatchQueue.global()
    var makeNodeModifications = false
    
    func backgroundComputation() {
        queue.async {
            
            //map.removeChildren(in: <#T##[SKNode]#>)
            //drawFood(earth: earth)
            
            self.makeNodeModifications = true
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.preferredFramesPerSecond = 1
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        
        
        // Ground init
        earth.sizeHorizontal = countColumns
        earth.sizeVertical = countRows
        earth.sizeTile = sizeTile
        earth.initTiles()
        scene.drawMap(earth: earth)
        scene.drawFood(earth: earth)
        skView.presentScene(scene)
    }

    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
