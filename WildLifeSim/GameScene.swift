//
//  GameScene.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 14.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import SpriteKit
import GameplayKit

let upRowY: CGFloat = -329
let LeftColX: CGFloat = -465

class GameScene: SKScene {
    let map = SKNode()
    let envInfo = SKNode()
    var button = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.41, y:0.719)
    }
    
    /// First call func
    override func didMove(to view: SKView)
    {
        SceneSetting()
        drawEnvParameters(env: env)
    }
    
    override func update(_ currentTime: TimeInterval) {
        map.removeAllChildren()
        drawMap(earth: earth)
        drawFood(earth: earth)
        drawEnvParameters(env: env)
    }
    
    func drawEnvParameters(env: Environment) {
        let defFontStyle = "Chalkboard SE Bold"
        let defFontSize: CGFloat = 25
        let defFontColor = SKColor.black
        
        
        envInfo.removeAllChildren()
        
        let step = SKLabelNode(text: "STEP")
        step.fontName = defFontStyle
        step.fontSize = defFontSize
        step.fontColor = SKColor.white
        step.name = "step"
        step.position = CGPoint(x: LeftColX, y: upRowY)
        
        let day = SKLabelNode(text: "Day: \(env.day)")
        day.fontName = defFontStyle
        day.fontSize = defFontSize
        day.fontColor = SKColor.red
        day.name = "day"
        day.position = CGPoint(x: LeftColX + 120, y: upRowY)
        
        let time = SKLabelNode(text: "Time: \(env.hour):00")
        time.fontName = defFontStyle
        time.fontSize = defFontSize
        time.fontColor = SKColor.red
        time.name = "time"
        time.position = CGPoint(x: LeftColX + 260, y: upRowY)
        
        let food = SKLabelNode(text: "Food: \(env.foodCount)")
        food.fontName = defFontStyle
        food.fontSize = defFontSize
        food.fontColor = defFontColor
        food.name = "food"
        food.position = CGPoint(x: LeftColX + 410, y: upRowY)
        
        envInfo.addChild(step)
        envInfo.addChild(day)
        envInfo.addChild(time)
        envInfo.addChild(food)
    }
    
    /// Draw earth map
    func drawMap(earth: Ground) {
        // Connect Ground Tile set
        let tileSet = SKTileSet(named: "groundsSet")!
        let tileSize = CGSize(width: earth.sizeTile, height: earth.sizeTile)
        let backgroundTiles = tileSet.tileGroups.first  {$0.name == "background"}
        let grassTiles = tileSet.tileGroups.first  {$0.name == "grass"}
        let forestTiles = tileSet.tileGroups.first  {$0.name == "forest"}
        let waterTiles = tileSet.tileGroups.first  {$0.name == "water"}
        let mountainTiles = tileSet.tileGroups.first  {$0.name == "mountain"}
        // Create bottom layer
        let botLayer = SKTileMapNode(tileSet: tileSet, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        botLayer.name = "botLayer"
        botLayer.fill(with: backgroundTiles)
        map.addChild(botLayer)
        // Create middle layer
        let midLayer = SKTileMapNode(tileSet: tileSet, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        // Fill map from earth
        for column in 0..<earth.sizeHorizontal {
            for row in 0..<earth.sizeVertical {
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
        
    }
    /// Draw food on map
    func drawFood (earth: Ground){
        // Connect Food Tile set
        let tileSize = CGSize(width: earth.sizeTile, height: earth.sizeTile)
        let foodTileSet = SKTileSet(named: "food")!
        let food1 = foodTileSet.tileGroups.first  {$0.name == "1"}
        let food2 = foodTileSet.tileGroups.first  {$0.name == "2"}
        let food3 = foodTileSet.tileGroups.first  {$0.name == "3"}
        // Create top layer
        let topLayer = SKTileMapNode(tileSet: foodTileSet, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        topLayer.name = "topLayer"
        // Fill map from earth
        for column in 0..<earth.sizeHorizontal {
            for row in 0..<earth.sizeVertical {
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
    
    /// Settings
    func SceneSetting()
    {
        self.backgroundColor = SKColor.white
        // Create map
        addChild(map)
        map.xScale = 0.4
        map.yScale = 0.4
        // Create environment info labels
        addChild(envInfo)
        envInfo.xScale = 1
        envInfo.yScale = 1
        // Create Step button
        button = SKSpriteNode(color: SKColor.red, size: CGSize(width: 150, height: 50))
        button.position = CGPoint(x: LeftColX, y:upRowY + 9)
        addChild(button)
    }
    
    /// Step button tap function
    func stepButtonTapped() {
        env.hourStep(map: earth)
    }
    
    /// Check taps
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
            // Check location of the touch
            if button.contains(touchLocation) {
                stepButtonTapped()
            }

    }
}
