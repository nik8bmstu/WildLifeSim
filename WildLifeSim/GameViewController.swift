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
let iPadCountColumns = 30
let iPadCountRows = 20

let macCountColumns = 60
let macCountRows = 26

let iPhoneCountColumns = 15
let iPhoneCountRows = 6

let earth = Ground()
let env = Environment()

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Ground init
        earth.sizeHorizontal = iPadCountColumns
        earth.sizeVertical = iPadCountRows
        
        #if targetEnvironment(macCatalyst)
        // Code for Mac.
        earth.sizeHorizontal = macCountColumns
        earth.sizeVertical = macCountRows
        #endif
        
        if view.bounds.size.height == 375 {
            // Iphone 11 Pro
            earth.sizeHorizontal = iPhoneCountColumns
            earth.sizeVertical = iPhoneCountRows
        }
        
        earth.initTiles()
        // Env init
        env.foodCount = earth.initFoodCount
        env.animalsInit()
        
        // Scene init
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.preferredFramesPerSecond = 30
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        
        // Enable scene
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
