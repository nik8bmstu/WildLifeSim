//
//  GameScene.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 14.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Tile: Int {

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
    
    let view2D:SKSpriteNode

    let tiles = [
                [1, 1, 1, 1, 1, 1],
                [1 ,0, 0, 0, 0, 1],
                [1 ,0, 0, 0, 0, 1],
                [1 ,0, 0, 0, 0, 1],
                [1 ,0, 0, 0, 0, 1],
                [1, 1, 1, 1, 1, 1]
                ]
    let tileSize = (width:20, height:20)
    
    override init(size: CGSize) {
        view2D = SKSpriteNode()
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
    }
    
    override func didMove(to view: SKView)
    {
        SceneSetting()
        let deviceScale = self.size.width/667
        view2D.position = CGPoint(x:-self.size.width*0.45, y:self.size.height*0.17)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        placeAllTiles2D()
    }

    func placeTile2D(image:String, withPosition:CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: image)
        tileSprite.position = withPosition
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        view2D.addChild(tileSprite)
    }
    
    func placeAllTiles2D() {
            for i in 0..<tiles.count {
                let row = tiles[i];
                for j in 0..<row.count {
                    let tileInt = row[j]
                    let tile = Tile(rawValue: tileInt)!
                    var point = CGPoint(x: (j * tileSize.width), y: -(i * tileSize.height))
                    placeTile2D(image: tile.image, withPosition: point)
                }
            }
    }
    
    func SceneSetting()
    {
        self.backgroundColor = SKColor.orange // изменяем цвет сцены на оранжевый
        
    }
}
