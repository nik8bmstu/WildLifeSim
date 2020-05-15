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

class GameViewController: UIViewController {

    // Ground class code
    let countColumns = 30
    let countRows = 15
    let sizeTile = 90
    let earth = Ground()
    let env = Environment()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        //scene.scaleMode = .resizeFill
        
        // Ground init
        earth.sizeHorizontal = countColumns
        earth.sizeVertical = countRows
        earth.sizeTile = sizeTile
        earth.initTiles()
        for i in 0...1000 {
            let scene = GameScene(size: view.bounds.size)
            scene.drawMap(earth: earth)
            env.hourStep(map: earth)
            skView.presentScene(scene)
        }
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
