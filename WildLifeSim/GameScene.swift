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
    // tileSprite code
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let view2D:SKSpriteNode
    
    // tileMap code
    let map = SKNode()
    
    // Ground class code
    let countColumns = 10
    let countRows = 5
    let sizeTile = 88
    let earth = Ground()

    // tileSprite code
    override init(size: CGSize) {
        view2D = SKSpriteNode()
        super.init(size: size)
        //self.anchorPoint = CGPoint(x:0.028, y:0.9)
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
    }
    
    /// Main func
    override func didMove(to view: SKView)
    {
        SceneSetting()
        // Ground class code
        earth.sizeHorizontal = countColumns
        earth.sizeVertical = countRows
        earth.sizeTile = sizeTile
        earth.initTiles()
        
        // tileSprite code
        let deviceScale = self.size.width / 6000//667
        view2D.position = CGPoint(x: 0, y: 0)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        placeAllTiles2D()
        
        // tileMap code
        addChild(map)
        map.xScale = 0.4
        map.yScale = 0.4
        
        let tileSet = SKTileSet(named: "textures")!
        let tileSize = CGSize(width: 128, height: 128)
        let sandTiles = tileSet.tileGroups.first  {$0.name == "Sand"}
        let botLayer = SKTileMapNode(tileSet: tileSet, columns: countColumns, rows: countRows, tileSize: tileSize)
        botLayer.fill(with: sandTiles)
        map.addChild(botLayer)
        
        let grassTiles = tileSet.tileGroups.first  {$0.name == "Grass"}
        let waterTiles = tileSet.tileGroups.first  {$0.name == "Water"}
        let topLayer = SKTileMapNode(tileSet: tileSet, columns: countColumns, rows: countRows, tileSize: tileSize)
        
        for column in 0..<countColumns {
            for row in 0..<countRows {
                let tileName = earth.tiles[column][row].type
                print("at \(column), \(row) - \(tileName)")
                switch tileName {
                case "water":
                    topLayer.setTileGroup(waterTiles, forColumn: column, row: row)
                case "forest":
                    topLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                default:
                    _ = 0
                    //topLayer.setTileGroup(tileSet.tileGroups[0], forColumn: column, row: row)
                }
            }
        }
        //topLayer.enableAutomapping = true
        map.addChild(topLayer)
    }
    // tileSprite code
    func placeTile2D(image: String, withPosition: CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: image)
        tileSprite.position = withPosition
        tileSprite.anchorPoint = CGPoint(x: 10.0, y: 10.0)
        view2D.addChild(tileSprite)
        /*guard let tileSet = SKTileSet(named: "testset") else {
            // hint: don't use the filename for named, use the tileset inside
            fatalError()
        }
        let tileSize = tileSet.defaultTileSize // from image size
        let tileMap = SKTileMapNode(tileSet: tileSet, columns: 1, rows: 1, tileSize: tileSize)
        let tileGroup = tileSet.tileGroups.first
        tileMap.fill(with: tileGroup) // fill or set by column/row
        //tileMap.setTileGroup(tileGroup, forColumn: 5, row: 5)
        self.addChild(tileMap)*/
    }
    // tileSprite code
    func placeAllTiles2D() {
        for h in 0..<countColumns {
            for v in 0..<countRows {
                var point = CGPoint(x: (h * sizeTile), y: (v * sizeTile))
                let tileName = earth.tiles[h][v].type
                placeTile2D(image: tileName, withPosition: point)
            }
        }
    }
    /// Settings
    func SceneSetting()
    {
        self.backgroundColor = SKColor.white
        
    }
}
