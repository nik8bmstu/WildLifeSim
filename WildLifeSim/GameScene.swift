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
    var animalId = 0
    var isFollow = false
    
    var map = SKNode()
    var foodMap = SKNode()
    var envInfo = SKNode()
    var tileInfo = SKNode()
    var objInfo = SKNode()
    var animalsMap = SKNode()
    var selectFrame = SKNode()
    var button = SKNode()
    
    let defFontStyle = "American Typewriter"
    let defFontSize: CGFloat = 25
    let defFontColor = SKColor.black
    let fontTypeAttribute = [ NSAttributedString.Key.font: UIFont.init(name: "American Typewriter", size: 25)]
    let blackAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
    let greenAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.green ]
    let redAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.red ]

    let statusY: CGFloat = -415
    let statusX: CGFloat = -465

    let tileX: CGFloat = 550
    let tileY: CGFloat = 330
    
    let axisHX: CGFloat = -522
    let axisHY: CGFloat = 363
    
    let axisVX: CGFloat = -550
    let axisVY: CGFloat = 335

    var tapColumn = 0
    var tapRow = 0
    
    // Connect Ground Tile set
    var tileSet = SKTileSet(named: "groundsSet")
    //var tileSize: CGSize = CGSize(width: earth.sizeTile, height: earth.sizeTile)
    var tileSize: CGSize = CGSize(width: 90, height: 90)
    var backgroundTiles: SKTileGroup!
    var grassTiles: SKTileGroup!
    var forestTiles: SKTileGroup!
    var waterTiles: SKTileGroup!
    var mountainTiles: SKTileGroup!
    var selectedTile: SKTileGroup!
    var visibilityTile: SKTileGroup!
    var emptyTile: SKTileGroup!
    
    // Connect Food Tile set
    var foodTileSet = SKTileSet(named: "food")
    var food1: SKTileGroup!
    var food2: SKTileGroup!
    var food3: SKTileGroup!
    
    // Connect Animal Tile set
    var animalTileSet = SKTileSet(named: "animals")
    var animalTileGroup: SKTileGroup!
    
    // Animal layer
    var animalLayer: SKTileMapNode!
    
    // Create map layers
    var botLayer: SKTileMapNode!
    var midLayer: SKTileMapNode!
    var topLayer: SKTileMapNode!
    
    // Selection layer
    var frameLayer: SKTileMapNode!
    
    // Food Layer
    var foodLayer: SKTileMapNode!
    
    // Create labels
    
    // Axis
    var axisHLabels: [SKLabelNode] = []
    var axisVLabels: [SKLabelNode] = []
    
    // Status
    var step = SKLabelNode(text: "ШАГ")
    var day = SKLabelNode(text: "День: 0")
    var time = SKLabelNode(text: "Время: 00:00")
    var food = SKLabelNode(text: "Еды: 0")
    var animals = SKLabelNode(text: "Животных: 1 + 2 = 3")
    var legend = SKLabelNode(text: "Legend")

    // Tile
    var tileLabel = SKLabelNode(text: "Клетка: A1")
    var tileType = SKLabelNode(text: "Поверхность")
    var tileFood = SKLabelNode(text: "Еда: 0")
    var tileAcess = SKLabelNode(text: "Проходима")
    var tileEmpty = SKLabelNode(text: "Свободна")
    
    // Animal
    var animalLabel = SKLabelNode(text: "Животное:")
    var animalName = SKLabelNode(text: "Имя")
    var animalParameters = SKLabelNode(text: "Среднее(50)")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.41, y:0.627)
    }
    
    /// First call func
    override func didMove(to view: SKView)
    {
        SceneSetting()
        mapInit()
        foodMapInit()
        labelInit()
        animalsInit()
        selectInit()
        
        drawMap(earth: earth)
    }
    
    override func update(_ currentTime: TimeInterval) {
        //drawMap(earth: earth)
        drawFood(earth: earth)
        drawEnvParameters(env: env)
        drawCurrentTileParam(earth: earth)
        drawCurrentObjectParam(earth: earth, env: env)
        drawAnimals(env: env)
        drawSelect(col: tapColumn, row: tapRow, animalIndex: env.getAnimalIndex(coord: Coord(col: tapColumn, row: tapRow)))
        follow(env: env)
    }
    
    func follow(env: Environment){
        if isFollow {
            for i in 0..<env.animalCount {
                if env.animals[i].uniqueID == animalId {
                    tapColumn = env.animals[i].coord.col
                    tapRow = env.animals[i].coord.row
                    break
                }
            }
        }
    }
    
    /// Draw environment parameters
    func drawEnvParameters(env: Environment) {
        envInfo.removeAllChildren()
        
        day.text = "День: \(env.day)"
        time.text = "Время: \(env.hour):00"
        food.text = "Еды: \(env.foodCount)"
        // create attributed animals count string
        let herbivorousCount = "\(env.herbivorousCount)"
        let predatorCount = "\(env.predatorCount)"
        let animalsCount = "Животных: \(herbivorousCount) | \(predatorCount)  (\(env.animalCount))"
        let fullRange = NSRange(location: 0, length: animalsCount.count)
        let herbivorousRange = NSRange(location: 10, length: herbivorousCount.count)
        let predatorRange = NSRange(location: 13 + herbivorousCount.count, length: predatorCount.count)
        let fullCount = NSMutableAttributedString(string: animalsCount, attributes: fontTypeAttribute as [NSAttributedString.Key : Any])
        fullCount.addAttributes(blackAttribute, range: fullRange)
        fullCount.addAttributes(greenAttribute, range: herbivorousRange)
        fullCount.addAttributes(redAttribute, range: predatorRange)
        animals.attributedText = fullCount
        
        for i in 0..<earth.sizeHorizontal {
            envInfo.addChild(axisHLabels[i])
        }
        
        for i in 0..<earth.sizeVertical {
            envInfo.addChild(axisVLabels[i])
        }
        
        envInfo.addChild(step)
        envInfo.addChild(day)
        envInfo.addChild(time)
        envInfo.addChild(food)
        envInfo.addChild(animals)
    }
    
    /// Draw current taped tile parameters
    func drawCurrentTileParam(earth: Ground) {
        tileInfo.removeAllChildren()
        
        let addr = transformCoord(col: tapColumn, row: tapRow)
        let curTile = earth.tiles[tapColumn][tapRow]
        tileLabel.text = "Клетка: \(addr)"
        tileType.text = earth.tiles[tapColumn][tapRow].type.rawValue
        tileFood.text = "Еды: " + "\(curTile.foodCount)"
        tileAcess.text = curTile.isAcessable ? "Проходима" : "Не проходима"
        if curTile.isEmpty {
            tileEmpty.text = "Свободна"
        } else if curTile.meatCount == 0 {
            tileEmpty.text = "Занята животным"
        } else {
            tileEmpty.text = "Занята мясом"
        }
        
        tileInfo.addChild(tileFood)
        tileInfo.addChild(tileLabel)
        tileInfo.addChild(tileType)
        tileInfo.addChild(tileAcess)
        tileInfo.addChild(tileEmpty)
    }
    
    /// Draw animals
    func drawAnimals(env: Environment) {
        animalLayer.fill(with: emptyTile)
        animalsMap.removeAllChildren()
        // Place all animals
        for i in 0..<env.animalCount {
            let coord = env.animals[i].coord
            let tileName = env.animals[i].type.rawValue + env.animals[i].direction.label
            animalTileGroup = animalTileSet!.tileGroups.first {$0.name == tileName}
            animalLayer.setTileGroup(animalTileGroup, forColumn: coord.col, row: coord.row)
        }
        animalsMap.addChild(animalLayer)
    }
    
    /// Draw current object param
    func drawCurrentObjectParam(earth: Ground, env: Environment) {
        objInfo.removeAllChildren()
        let curTile = earth.tiles[tapColumn][tapRow]
        if !curTile.isEmpty {
            if curTile.meatCount == 0 {
                let coord = Coord(col: tapColumn, row: tapRow)
                let index = env.getAnimalIndex(coord: coord)
                if index >= 0 {
                    let color = env.animals[index].isFemale ? SKColor.systemPink : SKColor.systemBlue
                    let type = env.animals[index].isFemale ? env.animals[index].type.labelF : env.animals[index].type.labelM
                    animalName.text = env.animals[index].name
                    animalName.fontColor = color
                    
                    var parameters = type + " - " + env.animals[index].sizeType.rawValue + "(" + String(env.animals[index].size) + ")\n"
                    parameters.append("Голод: \(env.animals[index].hungerDemand) / \(demandLevelMax)\n")
                    parameters.append("Жажда: \(env.animals[index].thirstDemand) / \(demandLevelMax)\n")
                    parameters.append("Бодрость: \(demandLevelMax - env.animals[index].sleepDemand) / \(demandLevelMax)\n")
                    parameters.append("Настроение: \(env.animals[index].mood)\n")
                    animalParameters.text = parameters
                    animalParameters = multipleLineText(labelIn: animalParameters, vOffset: 6)
                    objInfo.addChild(animalParameters)
                    
                    objInfo.addChild(animalLabel)
                    objInfo.addChild(animalName)
                    
                    legend.text = env.animals[index].legend
                    legend = multipleLineText(labelIn: legend, vOffset: 0)
                    envInfo.addChild(legend)
                }
            } else {
                
            }
        }
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
                case .water:
                    midLayer.setTileGroup(waterTiles, forColumn: column, row: row)
                case .forest:
                    midLayer.setTileGroup(forestTiles, forColumn: column, row: row)
                case .mountain:
                    midLayer.setTileGroup(mountainTiles, forColumn: column, row: row)
                default:
                    midLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                }
            }
        }
        map.addChild(midLayer)
    }
    
    /// Draw food  map
    func drawFood(earth: Ground) {
        foodLayer.fill(with: emptyTile)
        foodMap.removeAllChildren()
        // Fill map from earth
        for column in 0..<earth.sizeHorizontal {
            for row in 0..<earth.sizeVertical {
                let foodCount = earth.tiles[column][row].foodCount
                //print("at \(column), \(row) - \(tileName)")
                switch foodCount {
                case 1:
                    foodLayer.setTileGroup(food1, forColumn: column, row: row)
                case 2:
                    foodLayer.setTileGroup(food2, forColumn: column, row: row)
                case 3:
                    foodLayer.setTileGroup(food3, forColumn: column, row: row)
                default:
                    _ = 0
                }
            }
        }
        foodMap.addChild(foodLayer)
    }
    
    /// Draw select frame
    func drawSelect(col: Int, row: Int, animalIndex: Int) {
        selectFrame.removeAllChildren()
        frameLayer.fill(with: emptyTile)
        frameLayer.setTileGroup(selectedTile, forColumn: col, row: row)
        if env.getAnimalIndex(coord: Coord(col: col, row: row)) >= 0 {
            for i in 1..<env.animals[animalIndex].visibleTiles.count {
                frameLayer.setTileGroup(visibilityTile, forColumn: env.animals[animalIndex].visibleTiles[i].col, row: env.animals[animalIndex].visibleTiles[i].row)
            }
        }
        selectFrame.addChild(frameLayer)
    }
    
    /// Animals init
    func animalsInit() {
        // Create layer
        animalLayer = SKTileMapNode(tileSet: animalTileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        animalLayer.name = "animalLayer"
    }
    
    /// Selection init
    func selectInit() {
        selectedTile = tileSet!.tileGroups.first  {$0.name == "frame"}!
        visibilityTile = tileSet!.tileGroups.first  {$0.name == "visible"}!
        emptyTile = tileSet!.tileGroups.first  {$0.name == "empty"}!
        frameLayer = SKTileMapNode(tileSet: tileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        frameLayer.name = "frameLayer"
    }
    
    /// Map Init
    func mapInit() {
        // Connect ground tiles
        backgroundTiles = tileSet!.tileGroups.first  {$0.name == "background"}!
        grassTiles = tileSet!.tileGroups.first  {$0.name == "grass"}!
        forestTiles = tileSet!.tileGroups.first  {$0.name == "forest"}!
        waterTiles = tileSet!.tileGroups.first  {$0.name == "water"}!
        mountainTiles = tileSet!.tileGroups.first  {$0.name == "mountain"}!
        // Create map layers
        botLayer = SKTileMapNode(tileSet: tileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        midLayer = SKTileMapNode(tileSet: tileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        topLayer = SKTileMapNode(tileSet: foodTileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        topLayer.name = "topLayer"
        midLayer.name = "midLayer"
        botLayer.name = "botLayer"
        botLayer.fill(with: backgroundTiles)
    }
    
    /// Food map Init
    func foodMapInit() {
        // Connect food
        food1 = foodTileSet!.tileGroups.first  {$0.name == "1"}!
        food2 = foodTileSet!.tileGroups.first  {$0.name == "2"}!
        food3 = foodTileSet!.tileGroups.first  {$0.name == "3"}!
        // Create map layers
        foodLayer = SKTileMapNode(tileSet: foodTileSet!, columns: earth.sizeHorizontal, rows: earth.sizeVertical, tileSize: tileSize)
        foodLayer.name = "foodLayer"
    }
    
    /// Init labels
    func labelInit() {
        // Horizontal axis labelse
        for i in 0..<earth.sizeHorizontal {
            // We must create new label at each iteration
            let label = SKLabelNode(text: "\(i + 1)")
            label.fontName = defFontStyle
            label.fontSize = 15
            label.fontColor = defFontColor
            label.name = "axisHLabels[\(i)]"
            label.position = CGPoint(x: axisHX + 35.95 * CGFloat(i), y: axisHY)
            label.horizontalAlignmentMode = .center
            axisHLabels.append(label)
        }
        
        // Vertical axis labelse
        for i in 0..<earth.sizeVertical {
            // We must create new label at each iteration
            let s = String(UnicodeScalar(UInt8(65 + i)))
            let label = SKLabelNode(text: s)
            label.fontName = defFontStyle
            label.fontSize = 15
            label.fontColor = defFontColor
            label.name = "axisVLabels[\(i)]"
            label.position = CGPoint(x: axisVX, y: axisVY - 35.95 * CGFloat(i))
            label.horizontalAlignmentMode = .center
            axisVLabels.append(label)
        }
        // Button STEP
        step.text = "ШАГ"
        step.fontName = defFontStyle
        step.fontSize = defFontSize
        step.fontColor = SKColor.white
        step.name = "step"
        step.position = CGPoint(x: statusX, y: statusY)
        
        // Status Day
        day.fontName = defFontStyle
        day.fontSize = defFontSize
        day.fontColor = defFontColor
        day.name = "day"
        day.position = CGPoint(x: statusX + 100, y: statusY)
        day.horizontalAlignmentMode = .left
        
        // Status Time
        time.fontName = defFontStyle
        time.fontSize = defFontSize
        time.fontColor = defFontColor
        time.name = "time"
        time.position = CGPoint(x: statusX + 230, y: statusY)
        time.horizontalAlignmentMode = .left
        
        // Status Total food
        food.fontName = defFontStyle
        food.fontSize = defFontSize
        food.fontColor = defFontColor
        food.name = "food"
        food.position = CGPoint(x: statusX + 430, y: statusY)
        food.horizontalAlignmentMode = .left
        
        // Animals count
        animals.fontName = defFontStyle
        animals.fontSize = defFontSize
        animals.fontColor = defFontColor
        animals.name = "animals"
        animals.position = CGPoint(x: statusX + 570, y: statusY)
        animals.horizontalAlignmentMode = .left
        
        // Animal's legend
        legend.fontName = defFontStyle
        legend.fontSize = defFontSize - 7
        legend.fontColor = SKColor.darkGray
        legend.name = "legend"
        legend.position = CGPoint(x: statusX - 75, y: statusY - 50)
        legend.horizontalAlignmentMode = .left
        
        // Tile coord
        tileLabel.fontName = defFontStyle
        tileLabel.fontSize = defFontSize
        tileLabel.fontColor = SKColor.blue
        tileLabel.name = "tileLabel"
        tileLabel.position = CGPoint(x: tileX, y: tileY)
        tileLabel.horizontalAlignmentMode = .left
        
        let rightVertOffset: CGFloat = 30
        
        // Tile Type
        tileType.fontName = defFontStyle
        tileType.fontSize = defFontSize - 5
        tileType.fontColor = defFontColor
        tileType.name = "tileType"
        tileType.position = CGPoint(x: tileX, y: tileY - rightVertOffset * 1)
        tileType.horizontalAlignmentMode = .left
        
        // Tile food
        tileFood.fontName = defFontStyle
        tileFood.fontSize = defFontSize - 5
        tileFood.fontColor = defFontColor
        tileFood.name = "tileFood"
        tileFood.position = CGPoint(x: tileX, y: tileY - rightVertOffset * 2)
        tileFood.horizontalAlignmentMode = .left
        
        // Tile acess
        tileAcess.fontName = defFontStyle
        tileAcess.fontSize = defFontSize - 5
        tileAcess.fontColor = defFontColor
        tileAcess.name = "tileAcess"
        tileAcess.position = CGPoint(x: tileX, y: tileY - rightVertOffset * 3)
        tileAcess.horizontalAlignmentMode = .left
        
        // Tile empty
        tileEmpty.fontName = defFontStyle
        tileEmpty.fontSize = defFontSize - 5
        tileEmpty.fontColor = defFontColor
        tileEmpty.name = "tileEmpty"
        tileEmpty.position = CGPoint(x: tileX, y: tileY - rightVertOffset * 4)
        tileEmpty.horizontalAlignmentMode = .left
        
        // Animal Label
        animalLabel.fontName = defFontStyle
        animalLabel.fontSize = defFontSize
        animalLabel.fontColor = SKColor.orange
        animalLabel.name = "animalLabel"
        animalLabel.position = CGPoint(x: tileX, y: tileY - rightVertOffset * 6)
        animalLabel.horizontalAlignmentMode = .left
        
        // Animal name
        animalName.fontName = defFontStyle
        animalName.fontSize = defFontSize - 5
        animalName.fontColor = defFontColor
        animalName.name = "animalName"
        animalName.position = CGPoint(x: tileX, y: tileY - rightVertOffset * 7)
        animalName.horizontalAlignmentMode = .left
        
        // Animal size
        animalParameters.fontName = defFontStyle
        animalParameters.fontSize = defFontSize - 5
        animalParameters.fontColor = defFontColor
        animalParameters.name = "animalSize"
        animalParameters.position = CGPoint(x: tileX, y: tileY - rightVertOffset * 8)
        animalParameters.horizontalAlignmentMode = .left
    }
    
    /// Settings
    func SceneSetting()
    {
        self.backgroundColor = SKColor.white
        // Create map
        addChild(map)
        map.xScale = 0.4
        map.yScale = 0.4
        // Create food map
        addChild(foodMap)
        foodMap.xScale = 0.4
        foodMap.yScale = 0.4
        // Create environment info labels
        addChild(envInfo)
        envInfo.xScale = 1
        envInfo.yScale = 1
        // Create tile info labels
        addChild(tileInfo)
        tileInfo.xScale = 1
        tileInfo.yScale = 1
        // Create object info labels
        addChild(objInfo)
        objInfo.xScale = 1
        objInfo.yScale = 1
        // Create animal
        addChild(animalsMap)
        animalsMap.xScale = 0.4
        animalsMap.yScale = 0.4
        // Create frame
        addChild(selectFrame)
        selectFrame.xScale = 0.4
        selectFrame.yScale = 0.4
        // Create Step button
        button = SKSpriteNode(color: SKColor.red, size: CGSize(width: 150, height: 50))
        button.position = CGPoint(x: statusX, y:statusY + 9)
        addChild(button)
    }
    
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
        if !earth.tiles[tapColumn][tapRow].isEmpty && earth.tiles[tapColumn][tapRow].meatCount == 0 {
            let index = env.getAnimalIndex(coord: Coord(col: tapColumn, row: tapRow))
            if index >= 0 {
                isFollow = true
                animalId = env.animals[index].uniqueID
            }
        } else {
            isFollow = false
        }
        
        //print("Map tapped at Column: \(tapColumn) Row: \(tapRow)")
    }
    
    /// Check taps
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        //print(touchLocation)
        // Check location of the touch
        if button.contains(touchLocation) {
            stepButtonTapped()
        }
        if map.contains(touchLocation) {
            mapTapped(point: touchLocation)
        }
    }
    
    /// Transform tile coord to Literal-Numeric
    func transformCoord(col: Int, row: Int) -> String {
        let name = String(UnicodeScalar(UInt8(64 - row + earth.sizeVertical))) + "-" + String(col + 1)
        return name
    }
    
    /// Add multiline label
    func multipleLineText(labelIn: SKLabelNode, vOffset: Int) -> SKLabelNode {
        let subStrings:[String] = labelIn.text!.components(separatedBy: "\n")
        var labelOut = SKLabelNode()
        var subStringNumber:Int = 0
        for subString in subStrings {
            let labelTemp = SKLabelNode(fontNamed: labelIn.fontName)
            labelTemp.text = subString
            labelTemp.fontColor = labelIn.fontColor
            labelTemp.fontSize = labelIn.fontSize
            labelTemp.position = labelIn.position
            labelTemp.horizontalAlignmentMode = labelIn.horizontalAlignmentMode
            labelTemp.verticalAlignmentMode = labelIn.verticalAlignmentMode
            let y:CGFloat = CGFloat(subStringNumber) * (labelIn.fontSize + CGFloat(vOffset))
            if subStringNumber == 0 {
                labelOut = labelTemp
                subStringNumber += 1
            } else {
                labelTemp.position = CGPoint(x: 0, y: -y)
                labelOut.addChild(labelTemp)
                subStringNumber += 1
            }
        }
        return labelOut
    }
    
}
