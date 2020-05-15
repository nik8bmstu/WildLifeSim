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
    let countColumns = 30
    let countRows = 25
    let sizeTile = 90
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
        
        drawMap()
        
        
        // tileSprite code
        /*let deviceScale = self.size.width / 6000//667
        view2D.position = CGPoint(x: 0, y: 0)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        placeAllTiles2D()*/
        
        // tileMap code
        
    }
    
    func drawMap() {
        // Create map
        addChild(map)
        map.xScale = 0.4
        map.yScale = 0.4
        // Connect Ground Tile set
        let tileSet = SKTileSet(named: "groundsSet")!
        let tileSize = CGSize(width: sizeTile, height: sizeTile)
        let backgroundTiles = tileSet.tileGroups.first  {$0.name == "background"}
        let grassTiles = tileSet.tileGroups.first  {$0.name == "grass"}
        let forestTiles = tileSet.tileGroups.first  {$0.name == "forest"}
        let waterTiles = tileSet.tileGroups.first  {$0.name == "water"}
        let mountainTiles = tileSet.tileGroups.first  {$0.name == "mountain"}
        // Create bottom layer
        let botLayer = SKTileMapNode(tileSet: tileSet, columns: countColumns, rows: countRows, tileSize: tileSize)
        botLayer.fill(with: backgroundTiles)
        map.addChild(botLayer)
        // Create middle layer
        let midLayer = SKTileMapNode(tileSet: tileSet, columns: countColumns, rows: countRows, tileSize: tileSize)
        // Fill map from earth
        for column in 0..<countColumns {
            for row in 0..<countRows {
                let tileName = earth.tiles[column][row].type
                //print("at \(column), \(row) - \(tileName)")
                switch tileName {
                case "water":
                    midLayer.setTileGroup(waterTiles, forColumn: column, row: row)
                case "forest":
                    midLayer.setTileGroup(forestTiles, forColumn: column, row: row)
                case "mountain":
                    midLayer.setTileGroup(mountainTiles, forColumn: column, row: row)
                default:
                    midLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                }
            }
        }
        map.addChild(midLayer)
        // Connect Food Tile set
        let foodTileSet = SKTileSet(named: "food")!
        let food1 = foodTileSet.tileGroups.first  {$0.name == "1"}
        let food2 = foodTileSet.tileGroups.first  {$0.name == "2"}
        let food3 = foodTileSet.tileGroups.first  {$0.name == "3"}
        // Create top layer
        let topLayer = SKTileMapNode(tileSet: foodTileSet, columns: countColumns, rows: countRows, tileSize: tileSize)
        // Fill map from earth
        for column in 0..<countColumns {
            for row in 0..<countRows {
                let foodCount = earth.tiles[column][row].foodCount
                //print("at \(column), \(row) - \(tileName)")
                switch foodCount {
                case 1:
                    topLayer.setTileGroup(food1, forColumn: column, row: row)
                case 2:
                    topLayer.setTileGroup(food2, forColumn: column, row: row)
                case 3:
                    topLayer.setTileGroup(food3, forColumn: column, row: row)
                default:
                    _ = 0
                }
            }
        }
        map.addChild(topLayer)
    }
    
    /*
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
    }*/
    /// Settings
    func SceneSetting()
    {
        self.backgroundColor = SKColor.white
        
    }
}
