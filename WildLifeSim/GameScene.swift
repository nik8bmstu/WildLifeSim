//
//  GameScene.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 14.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    var map = SKNode()
    var envInfo = SKNode()
    var tileInfo = SKNode()
    var button = SKNode()
    
    let defFontStyle = "American Typewriter"
    let defFontSize: CGFloat = 25
    let defFontColor = SKColor.black

    let upRowY: CGFloat = -329
    let leftColX: CGFloat = -465

    let rightColX: CGFloat = 620
    let rightColY: CGFloat = 245

    var tapColumn = 0
    var tapRow = 0
    
    // Connect Ground Tile set
    var tileSet = SKTileSet(named: "groundsSet")
    var tileSize: CGSize = CGSize(width: earth.sizeTile, height: earth.sizeTile)
    var backgroundTiles: SKTileGroup!
    var grassTiles: SKTileGroup!
    var forestTiles: SKTileGroup!
    var waterTiles: SKTileGroup!
    var mountainTiles: SKTileGroup!
    
    // Connect Food Tile set
    var foodTileSet = SKTileSet(named: "food")
    var food1: SKTileGroup!
    var food2: SKTileGroup!
    var food3: SKTileGroup!
    
    // Create map layers
    var botLayer: SKTileMapNode!
    var midLayer: SKTileMapNode!
    var topLayer: SKTileMapNode!
    
    // Create labels
    var step = SKLabelNode(text: "ШАГ")
    var day = SKLabelNode(text: "День: 0")
    var time = SKLabelNode(text: "Время: 00:00")
    var food = SKLabelNode(text: "Еда: 0")
    var tileLabel = SKLabelNode(text: "Клетка: 0, 0")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {
        super.init(size: size)
        
        SceneSetting()
        mapInit()
        labelInit()
        self.anchorPoint = CGPoint(x:0.41, y:0.719)
    }
    
    /// First call func
    override func didMove(to view: SKView)
    {
        //SceneSetting()
        //mapInit()
        //labelInit()
        //drawEnvParameters(env: env)
        //drawCurrentTileParam(earth: earth)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        drawMap(earth: earth)
        drawFood(earth: earth)
        drawEnvParameters(env: env)
        drawCurrentTileParam(earth: earth)
    }
    
    /// Draw environment parameters
    func drawEnvParameters(env: Environment) {
        envInfo.removeAllChildren()
        
        day.text = "День: \(env.day)"
        time.text = "Время: \(env.hour):00"
        food.text = "Еда: \(env.foodCount)"
        
        envInfo.addChild(step)
        envInfo.addChild(day)
        envInfo.addChild(time)
        envInfo.addChild(food)
    }
    
    /// Draw current taped tile parameters
    func drawCurrentTileParam(earth: Ground) {
        tileInfo.removeAllChildren()
        
        tileLabel.text = "Клетка: \(tapColumn), \(tapRow)"
        
        tileInfo.addChild(tileLabel)
    }
    
    /// Draw earth map
    func drawMap(earth: Ground) {
        map.removeAllChildren()
        map.addChild(botLayer)
        // Fill middle map layer from earth
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
    func drawFood (earth: Ground) {
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
    
    /// Map Init
    func mapInit() {
        // Connect ground tiles
        backgroundTiles = tileSet!.tileGroups.first  {$0.name == "background"}!
        grassTiles = tileSet!.tileGroups.first  {$0.name == "grass"}!
        forestTiles = tileSet!.tileGroups.first  {$0.name == "forest"}!
        waterTiles = tileSet!.tileGroups.first  {$0.name == "water"}!
        mountainTiles = tileSet!.tileGroups.first  {$0.name == "mountain"}!
        // Connect food
        food1 = foodTileSet!.tileGroups.first  {$0.name == "1"}!
        food2 = foodTileSet!.tileGroups.first  {$0.name == "2"}!
        food3 = foodTileSet!.tileGroups.first  {$0.name == "3"}!
        // Create map layers
        botLayer = SKTileMapNode(tileSet: tileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        midLayer = SKTileMapNode(tileSet: tileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        topLayer = SKTileMapNode(tileSet: foodTileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        topLayer.name = "topLayer"
        midLayer.name = "midLayer"
        botLayer.name = "botLayer"
        botLayer.fill(with: backgroundTiles)
    }
    
    /// Init labels
    func labelInit() {
        step.text = "ШАГ"
        step.fontName = defFontStyle
        step.fontSize = defFontSize
        step.fontColor = SKColor.white
        step.name = "step"
        step.position = CGPoint(x: leftColX, y: upRowY)
        
        day.fontName = defFontStyle
        day.fontSize = defFontSize
        day.fontColor = SKColor.red
        day.name = "day"
        day.position = CGPoint(x: leftColX + 130, y: upRowY)
        
        time.fontName = defFontStyle
        time.fontSize = defFontSize
        time.fontColor = SKColor.red
        time.name = "time"
        time.position = CGPoint(x: leftColX + 285, y: upRowY)
        
        food.fontName = defFontStyle
        food.fontSize = defFontSize
        food.fontColor = defFontColor
        food.name = "food"
        food.position = CGPoint(x: leftColX + 430, y: upRowY)
        
        tileLabel.fontName = defFontStyle
        tileLabel.fontSize = defFontSize
        tileLabel.fontColor = defFontColor
        tileLabel.name = "tileLabel"
        tileLabel.position = CGPoint(x: rightColX, y: rightColY)
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
        // Create tile info labels
        addChild(tileInfo)
        tileInfo.xScale = 1
        tileInfo.yScale = 1
        // Create Step button
        button = SKSpriteNode(color: SKColor.red, size: CGSize(width: 150, height: 50))
        button.position = CGPoint(x: leftColX, y:upRowY + 9)
        addChild(button)
    }
    /*
    /// Prepare map
    func prepareMap(earth: Ground) {
        let newLayer = SKTileMapNode(tileSet: tileSet, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        newLayer.fill(with: backgroundTiles)
        map.addChild(newLayer)
    }*/
    
    /// Step button tap function
    func stepButtonTapped() {
        env.hourStep(map: earth)
    }
    
    /// Map tap function
    func mapTapped(point: CGPoint) {
        let pointResized = CGPoint(x: point.x / map.xScale, y: point.y / map.yScale)
        let layer = map.childNode(withName: "botLayer")! as! SKTileMapNode
        tapColumn = layer.tileColumnIndex(fromPosition: pointResized)
        tapRow = layer.tileRowIndex(fromPosition: pointResized)
        //print("Map tapped at Column: \(tapColumn) Row: \(tapRow)")
    }
    
    /// Check taps
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
            // Check location of the touch
            if button.contains(touchLocation) {
                stepButtonTapped()
            }
        if map.contains(touchLocation) {
            mapTapped(point: touchLocation)
        }
    }
}
