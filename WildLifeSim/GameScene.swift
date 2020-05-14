//
//  GameScene.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 14.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Tiled: Int {

    case Ground
    case Wall

    var description:String {
        switch self {
        case .Ground:
            return "Ground"
        case .Wall:
            return "Wall"
        }
    }

    var image:String {
        switch self {
        case .Ground:
            return "ground"
        case .Wall:
            return "wall"

        }
    }
}

class GameScene: SKScene {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let sizeHorizontal = 30
    let sizeVertical = 20
    let sizeTile = 100
    
    let view2D:SKSpriteNode
    
    let earth = Ground()

    override init(size: CGSize) {
        view2D = SKSpriteNode()
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.028, y:0.9)
    }
    
    /// Main func
    override func didMove(to view: SKView)
    {
        SceneSetting()
        
        
        earth.sizeHorizontal = sizeHorizontal
        earth.sizeVertical = sizeVertical
        earth.sizeTile = sizeTile
        earth.initTiles()
        
        let deviceScale = self.size.width / 4000//667
        view2D.position = CGPoint(x: 0, y: 0)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        placeAllTiles2D()
    }

    func placeTile2D(image: String, withPosition: CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: image)
        tileSprite.position = withPosition
        tileSprite.anchorPoint = CGPoint(x: 0, y: 0)
        view2D.addChild(tileSprite)
    }
    
    func placeAllTiles2D() {
        for h in 0..<sizeHorizontal {
            for v in 0..<sizeVertical {
                var point = CGPoint(x: (h * sizeTile), y: -(v * sizeTile))
                let tileName = earth.tiles[h][v].type
                placeTile2D(image: tileName, withPosition: point)
            }
        }
    }
    
    func SceneSetting()
    {
        self.backgroundColor = SKColor.orange
        
    }
}