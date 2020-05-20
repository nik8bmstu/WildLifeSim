//
//  ClassAnimal.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 16.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import Foundation

let demandLevelMax = 100

enum Type: String {
    case cow = "cow"
    case horse = "horse"
    case elephant = "elephant"
    case sheep = "sheep"
    case goat = "goat"
    case tiger = "tiger"
    case chicken = "chicken"
    
    var labelF: String {
        switch self {
        case .cow:
            return "Корова"
        case .horse:
            return "Лошадь"
        case .elephant:
            return "Слониха"
        case .sheep:
            return "Овца"
        case .goat:
            return "Коза"
        case .tiger:
            return "Тигрица"
        case .chicken:
            return "Курица"
        }
    }
    var labelM: String {
        switch self {
        case .cow:
            return "Бык"
        case .horse:
            return "Конь"
        case .elephant:
            return "Слон"
        case .sheep:
            return "Баран"
        case .goat:
            return "Козел"
        case .tiger:
            return "Тигр"
        case .chicken:
            return "Петух"
        }
    }
    var visForward: Int {
        switch self {
        case .cow:
            return 3
        case .horse:
            return 5
        case .elephant:
            return 2
        case .sheep:
            return 3
        case .goat:
            return 4
        case .tiger:
            return 7
        case .chicken:
            return 2
        }
    }
    var visAround: Int {
        switch self {
        case .cow:
            return 2
        case .horse:
            return 2
        case .elephant:
            return 1
        case .sheep:
            return 1
        case .goat:
            return 1
        case .tiger:
            return 0
        case .chicken:
            return 1
        }
    }
}
    
enum SizeType: String {
    case small = "S"
    case medium = "M"
    case large = "L"
    
    var lifeTime: Int {
        switch self {
        case .small:
            return 10
        case .medium:
            return 20
        case .large:
            return 30
        }
    }
    var sleepGrow: Int {
        switch self {
        case .small:
            return 3
        case .medium:
            return 2
        case .large:
            return 1
        }
    }
    var growSize: Int {
        switch self {
        case .small:
            return 1
        case .medium:
            return 2
        case .large:
            return 3
        }
    }
    var initSizeMin: Int {
        switch self {
        case .small:
            return 10
        case .medium:
            return 65
        case .large:
            return 110
        }
    }
    var initSizeMax: Int {
        switch self {
        case .small:
            return 20
        case .medium:
            return 80
        case .large:
            return 130
        }
    }
    var sizeMin: Int {
        switch self {
        case .small:
            return 5
        case .medium:
            return 45
        case .large:
            return 90
        }
    }
    var sizeMax: Int {
        switch self {
        case .small:
            return 25
        case .medium:
            return 85
        case .large:
            return 150
        }
    }
    var description: String {
        switch self {
        case .small:
            return "Маленькое"
        case .medium:
            return "Среднее"
        case .large:
            return "Большое"
        }
    }
}

enum Direction: Int {
    case down = 0
    case up = 1
    case left = 2
    case right = 3
    
    var label: String {
        switch self {
        case .down: return "down"
        case .up: return "up"
        case .left: return "left"
        case .right: return "right"
        }
    }
}

struct Coord {
    var col: Int
    var row: Int
}

enum visObjType: String {
    case danger = "Убежать от хищника"
    case food = "Добыть еды"
    case partner = "Подойти к партнеру"
    case water = "Выпить воды"
    case sleep = "Поспать"
    case lookLeft = "Повернуться налево"
    case lookRight = "Повернуться направо"
    case forward = "Идти дальше"
    case initial = ""
}

struct visibleObject {
    var tile: Coord
    var interestLevel: Int
    var type: visObjType
    var description: String
}


let maleNames: [String] = ["Ричард", "Сэм", "Томас", "Чак", "Говард", "Игнасио", "Клайд", "Снежок", "Рудольф", "Бильбо", "Имхотеп", "Кеша", "Борис", "Том", "Шанти", "Джон", "Мигель", "Кремень", "Лео", "Джерри"]
let femaleNames: [String] = ["София", "Дейзи", "Кара", "Дора", "Бонни", "Сара", "Мэри", "Люси", "Сюзанна", "Мария", "Ромашка", "Колокольчик", "Лиза", "Эбигейл", "Астра", "Пандора", "Кэт", "Бэт", "Черри", "Роза"]

class Animal {
    // Имя
    var name: String
    var uniqueID: Int
    // Вес
    var sizeType: SizeType = .medium
    var size: Int
    // Тип
    var type: Type = .cow
    var isPredator: Bool = false
    // Возраст
    var age: Int = 0
    var isAlive: Bool = true
    // Нужды
    var hungerDemand: Int = 5
    var thirstDemand: Int = 2
    var sleepDemand: Int = 0
    // Параметры расположения
    var coord: Coord = Coord(col: 0, row: 0)
    var direction: Direction = .down
    // Пол
    var isFemale: Bool
    var isPregnant: Bool = false
    // Очки действий
    var actionPoints: Int = 6
    // Видимые объекты
    var visibleObjects: [visibleObject] = []
    // Текущий целевой объект
    var targetObject: visibleObject = visibleObject(tile: Coord(col: 0, row: 0), interestLevel: 0, type: .initial, description: "")
    // Видимые клетки
    var visibleTiles: [Coord] = []
    // legend
    var legend: String = ""
    // Previos act was successful
    var isActOK: Bool = false
    // Last rotation
    var lastRotate: Direction = .right
    // Настроение
    var mood: Int = 0
    
    /// Init
    init(map: Ground, myType: Type) {
        // Get type
        type = myType
        // Get food type
        switch type {
        case .cow, .elephant, .goat, .sheep, .chicken, .horse:
            isPredator = false
        default:
            isPredator = true
        }
        // Get size
        switch type {
        case .chicken:
            sizeType = .small
        case .elephant:
            sizeType = .large
        default:
            sizeType = .medium
        }
        size = Int.random(in: sizeType.initSizeMin...sizeType.initSizeMax)
        // Chose gender
        isFemale = Bool.random()
        // Chose name
        if isFemale {
            name = femaleNames[Int.random(in: 0..<femaleNames.count)]
        } else {
            name = maleNames[Int.random(in: 0..<maleNames.count)]
        }
        uniqueID = Int.random(in: Int.min...Int.max)
        // Chose direction
        let dir = Int.random(in: 0...3)
        switch dir {
        case 0:
            direction = .down
        case 1:
            direction = .up
        case 2:
            direction = .left
        default:
            direction = .right
        }
        // Randomize demands
        sleepDemand = Int.random(in: 0...30)
        hungerDemand = Int.random(in: 10...40)
        thirstDemand = Int.random(in: 0...25)
        // Get coord
        coord = startCoordRandomize(map: map)
        // Define target and visible tiles
        targetObject = visibleObject(tile: coord, interestLevel: 0, type: .sleep, description: "")
        visibleObjects.append(targetObject)
        visibleObjects.append(visibleObject(tile: coord, interestLevel: 0, type: .lookLeft, description: ""))
        visibleObjects.append(visibleObject(tile: coord, interestLevel: 0, type: .lookRight, description: ""))
        visibleTiles.append(coord)
        // Take own tile
        placeOnGround(earth: map)
    }
    
    func placeOnGround(earth: Ground) {
        earth.tiles[coord.col][coord.row].isEmpty = false
        //print("Animal placed at \(coord)")
    }
    
    
    // Global actions (look, think, act)
    
    /// Look
    func look(map: Ground, neighbors: Environment) {
        legend.append("\"\(name)\" осматривается ")
        // Delete old objects
        visibleObjects.removeAll()
        // Find new objects
        findObjects(map: map, neighbors: neighbors)
        legend.append("и находит следующие возможности:\n")
    }
    
    /// Think
    func think(map: Ground, neighbors: Environment) {
        var decide = 0
        var decideLevel = 0
        if !isActOK {
            mood -= 1
            targetObject.interestLevel = 0
        } else {

        }
        // Reduce target level if it is not a danger
        if targetObject.type != .danger {
            targetObject.interestLevel /= 4
        }
        for i in 0..<visibleObjects.count {
            let tileCoord = Coord(col: visibleObjects[i].tile.col, row: visibleObjects[i].tile.row)
            let way = wayLength(target: tileCoord)
            switch visibleObjects[i].type {
            case .food:
                if visibleObjects[i].interestLevel == 3 {
                    mood += 1
                }
                if targetObject.type == .food && !isActOK {
                    visibleObjects[i].interestLevel = 0
                } else {
                    visibleObjects[i].interestLevel = visibleObjects[i].interestLevel * hungerDemand * 3 - way * way * 3 + (sizeType.sizeMax - size)
                }
            case .water:
                if targetObject.type == .water && !isActOK {
                    visibleObjects[i].interestLevel = 0
                } else {
                    visibleObjects[i].interestLevel = thirstDemand * 3 - way * 3 - Int.random(in: 0...abs(mood))
                }
            case .partner:
                if !isPregnant {
                    visibleObjects[i].interestLevel = 20 / way - thirstDemand - hungerDemand - sleepDemand + age + mood
                    mood += 1
                } else {
                    visibleObjects[i].interestLevel = 0
                }
                mood += 1
            case .danger:
                visibleObjects[i].interestLevel = 100 / way
                mood -= 10
            case .forward:
                if targetObject.type == .forward {
                    targetObject.interestLevel = 0
                    if canForward(map: map) {
                        visibleObjects[i].interestLevel = hungerDemand * 2 - sleepDemand * 2 - Int.random(in: 0...10)
                    }
                } else if canForward(map: map) {
                    visibleObjects[i].interestLevel = (thirstDemand + hungerDemand) * 2 - sleepDemand * 3  + Int.random(in: 0...10)
                }
            case .lookLeft:
                visibleObjects[i].interestLevel = thirstDemand + hungerDemand - sleepDemand + Int.random(in: 0...10)
                if targetObject.type == .lookRight {
                    visibleObjects[i].interestLevel = 0
                }
            case .lookRight:
                visibleObjects[i].interestLevel = thirstDemand + hungerDemand - sleepDemand + Int.random(in: 0...10)
                if targetObject.type == .lookLeft {
                    visibleObjects[i].interestLevel = 0
                }
            case .sleep:
                visibleObjects[i].interestLevel = sleepDemand * 4 - hungerDemand - thirstDemand - Int.random(in: 0...abs(mood))
            default:
                print("Default switch")
            }
            if visibleObjects[i].interestLevel < 0 {
                visibleObjects[i].interestLevel = 0
            }
            
            if visibleObjects[i].interestLevel > decideLevel {
                decideLevel = visibleObjects[i].interestLevel
                decide = i
            }
            // Print objects of interest list
            var stringCoord = ""
            if tileCoord.col != coord.col || tileCoord.row != coord.row {
                stringCoord = " на клетке \(transformCoord(col: tileCoord.col, row: tileCoord.row))"
            }
            visibleObjects[i].description = "- \(visibleObjects[i].type.rawValue)" + stringCoord + " - (\(visibleObjects[i].interestLevel))\n"
            legend.append(visibleObjects[i].description)
        }
        if targetObject.interestLevel < decideLevel {
            targetObject = visibleObjects[decide]
            legend.append("\"\(name)\" решает " + targetObject.description)
        } else {
            legend.append("\"\(name)\" решает не менять цель")
            legend.append(targetObject.description)
        }
    }
    
    /// Act
    func act(map: Ground, neighbors: Environment) {
        isActOK = false
        switch targetObject.type {
        case .lookLeft:
            rotateLeft()
            isActOK = true
        case .lookRight:
            rotateRight()
            isActOK = true
        case .sleep:
            sleep()
            mood += 1
            isActOK = true
        case .food:
            if wayLength(target: targetObject.tile) == 1 {
                eat(tile: targetObject.tile, map: map)
            } else {
                findWay(tile: targetObject.tile, map: map)
            }
        case .water:
            if wayLength(target: targetObject.tile) == 1 {
                drink(tile: targetObject.tile, map: map)
            } else {
                findWay(tile: targetObject.tile, map: map)
            }
        case .forward:
            goForward(map: map)
        case .partner:
            if wayLength(target: targetObject.tile) == 1 {
                continueLine()
            } else {
                findWay(tile: targetObject.tile, map: map)
            }
        default:
            isActOK = false
        }
        if isActOK {
            legend.append("\"\(name)\" успешно выполнил задуманное\n")
        } else {
            legend.append("\"\(name)\" не смог выполнить задуманное\n")
        }
        
    }
    
    // Actions
    
    /// Find way - MOST important func... but not now
    func findWay(tile: Coord, map: Ground) {
        goForward(map: map)
        if !isActOK {
            switch Int.random(in: 0...1) {
            case 0:
                rotateLeft()
            default:
                rotateRight()
            }
        }
    }
    
    /// Rotate left
    func rotateLeft() {
        switch direction {
        case .down:
            direction = .right
        case .right:
            direction = .up
        case .up:
            direction = .left
        default:
            direction = .down
        }
        lastRotate = .left
    }
    
    /// Rotate right
    func rotateRight() {
        switch direction {
        case .down:
            direction = .left
        case .right:
            direction = .down
        case .up:
            direction = .right
        default:
            direction = .up
        }
        lastRotate = .right
    }
    
    /// Go forward
    func goForward(map: Ground) {
        isActOK = false
        let targetCoord: Coord = forwardCoord()
        if canForward(map: map) {
            map.tiles[coord.col][coord.row].isEmpty = true
            coord = targetCoord
            map.tiles[coord.col][coord.row].isEmpty = false
            isActOK = true
        }
    }
    
    /// Check, can I go forward
    func canForward(map: Ground) -> Bool {
        let targetCoord = forwardCoord()
        let limitCoord = Coord(col: map.sizeHorizontal, row: map.sizeVertical)
        if isTileExist(coord: targetCoord, limit: limitCoord) {
            let tile = map.tiles[targetCoord.col][targetCoord.row]
            if tile.isEmpty && tile.isAcessable {
                return true
            }
        }
        return false
    }
    
    /// Get Forward tile coord
    func forwardCoord() -> Coord {
        var targetCoord: Coord = coord
        switch direction {
        case .down:
            targetCoord.row -= 1
        case .right:
            targetCoord.col += 1
        case .up:
            targetCoord.row += 1
        case .left:
            targetCoord.col -= 1
        }
        return targetCoord
    }
    
    /// Eat
    func eat(tile: Coord, map: Ground) {
        if map.tiles[tile.col][tile.row].foodCount > 0 {
            map.tiles[tile.col][tile.row].foodCount -= 1
            if hungerDemand > 10 {
                switch sizeType {
                case .small:
                    hungerDemand = 0
                case .medium:
                    hungerDemand -= demandLevelMax / 2
                case .large:
                    hungerDemand -= demandLevelMax / 3
                }
            } else {
                hungerDemand = 0
                if size <= (sizeType.sizeMax - sizeType.growSize) {
                    size += sizeType.growSize
                }
            }
            hungerDemand = hungerDemand < 0 ? 0 : hungerDemand
            isActOK = true
            mood += 1
        }
    }
    
    /// Eat
    func drink(tile: Coord, map: Ground) {
        if map.tiles[tile.col][tile.row].waterHere {
            switch sizeType {
            case .small:
                thirstDemand -= demandLevelMax / 3
            case .medium:
                thirstDemand -= demandLevelMax / 2
            case .large:
                thirstDemand = 0
            }
            thirstDemand = thirstDemand < 0 ? 0 : thirstDemand
            isActOK = true
            mood += 1
        }
    }
    
    /// Sleep
    func sleep() {
        sleepDemand -= sizeType.sleepGrow * 6
        sleepDemand = sleepDemand < 0 ? 0 : sleepDemand
    }
    
    /// Continue the line
    func continueLine() {
        if isFemale {
            isPregnant = true
            legend.append("\"\(name)\" беременна\n")
        } else {
            
        }
        isActOK = true
        mood += 10
    }
    
    /// Grow demands
    func demandsGrow() {
        if sleepDemand <= (demandLevelMax - sizeType.sleepGrow) {
            sleepDemand += sizeType.sleepGrow
        } else {
            sleepDemand = demandLevelMax
            size -= 1
            mood -= 1
        }
        if hungerDemand < demandLevelMax {
            hungerDemand += 1
        } else {
            size -= 1
            mood -= 1
        }
        if thirstDemand < demandLevelMax {
            thirstDemand += 1
        } else {
            size -= 1
            mood -= 1
        }
        if size < sizeType.sizeMin {
            die()
        }
    }
    
    /// Find objects
    func findObjects(map: Ground, neighbors: Environment) {
        visibleObjects.append(visibleObject(tile: coord, interestLevel: 0, type: .sleep, description: ""))
        visibleObjects.append(visibleObject(tile: coord, interestLevel: 0, type: .lookLeft, description: ""))
        visibleObjects.append(visibleObject(tile: coord, interestLevel: 0, type: .lookRight, description: ""))
        if canForward(map: map) {
            visibleObjects.append(visibleObject(tile: coord, interestLevel: 0, type: .forward, description: ""))
        }
        defineVisibleTiles(map: map)
        // 0 is animal position, so i from 1
        for i in 1..<visibleTiles.count {
            let currentCoord = Coord(col: visibleTiles[i].col, row: visibleTiles[i].row)
            let tile = map.tiles[currentCoord.col][currentCoord.row]
            if (tile.foodCount > 0) && !isPredator {
                visibleObjects.append(visibleObject(tile: currentCoord, interestLevel: tile.foodCount, type: .food, description: ""))
            }
            if tile.waterHere {
                visibleObjects.append(visibleObject(tile: currentCoord, interestLevel: 0, type: .water, description: ""))
            }
            if !tile.isEmpty {
                let index = neighbors.getAnimalIndex(coord: currentCoord)
                // if animal not dead
                if index >= 0 {
                    // If it alive
                    if neighbors.animals[index].isAlive {
                        // I i am not a predator
                        if !isPredator {
                            // If it is a predator and bigger than me
                            if (neighbors.animals[index].isPredator && neighbors.animals[index].size > size) {
                                visibleObjects.append(visibleObject(tile: currentCoord, interestLevel: 0, type: .danger, description: ""))
                            } else if ((neighbors.animals[index].isFemale != isFemale) && (neighbors.animals[index].type == type)) {
                                // Same type, but another gender
                                if (!neighbors.animals[index].isPregnant && !isPregnant) {
                                    // No one is pregnant
                                    visibleObjects.append(visibleObject(tile: currentCoord, interestLevel: 0, type: .partner, description: ""))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Define available tiles
    func defineVisibleTiles(map: Ground) {
        // Delete old
        visibleTiles.removeAll()
        visibleTiles.append(coord)
        defineVisibleTilesAround(map: map)
        defineVisibleTilesForward(map: map)
        /*var visibleTilesString = "\"\(name)\" видит следующие клетки: "
        visibleTilesString.append("\(transformCoord(col: visibleTiles[0].col, row: visibleTiles[0].row))")
        if visibleTiles.count > 1 {
            for i in 1..<visibleTiles.count {
                visibleTilesString.append(", \(transformCoord(col: visibleTiles[i].col, row: visibleTiles[i].row))")
            }
        }
        print(visibleTilesString)*/
    }
    
    /// Define visible tiles around
    func defineVisibleTilesAround(map: Ground) {
        let limitCoord = Coord(col: map.sizeHorizontal, row: map.sizeVertical)
        for row in (coord.row - type.visAround)...(coord.row + type.visAround) {
            for col in (coord.col - type.visAround)...(coord.col + type.visAround) {
                let checkCoord = Coord(col: col, row: row)
                if isTileExist(coord: checkCoord, limit: limitCoord) {
                    if !isTileAlreadyVisible(coord: checkCoord) {
                        visibleTiles.append(checkCoord)
                    }
                }
            }
        }
    }
    
    /// Define visible tiles forward
    func defineVisibleTilesForward(map: Ground) {
        let limitCoord = Coord(col: map.sizeHorizontal, row: map.sizeVertical)
        var visLeft = 1
        var visRight = 1
        var visUp = 1
        var visDown = 1
        switch direction {
        case .down:
            visDown = type.visForward
            visUp = 0
        case .left:
            visLeft = type.visForward
            visRight = 0
        case .right:
            visRight = type.visForward
            visLeft = 0
        default: // .up
            visUp = type.visForward
            visDown = 0
        }
        
        for row in (coord.row - visDown)...(coord.row + visUp) {
            for col in (coord.col - visLeft)...(coord.col + visRight) {
                let checkCoord = Coord(col: col, row: row)
                if isTileExist(coord: checkCoord, limit: limitCoord) {
                    if !isTileAlreadyVisible(coord: checkCoord) {
                        visibleTiles.append(checkCoord)
                    }
                }
            }
        }
         
    }
    
    /// Is tile exist
    func isTileExist(coord: Coord, limit: Coord) -> Bool {
        if ((coord.col >= 0) && (coord.col < limit.col) && (coord.row >= 0)  && (coord.row < limit.row)) {
            return true
        }
        return false
    }
    
    /// Is tile visible
    func isTileAlreadyVisible(coord: Coord) -> Bool {
        for i in 0..<visibleTiles.count {
            if ((visibleTiles[i].col == coord.col) && (visibleTiles[i].row == coord.row)) {
                return true
            }
        }
        return false
    }
    
    /// Calculate stright way length
    func wayLength(target: Coord) -> Int {
        var actions = 0
        actions = abs(target.col - coord.col) + abs(target.row - coord.row) // Method does not take into account obstacles
        return actions
    }
    
    /// Transform tile coord to Literal-Numeric
    func transformCoord(col: Int, row: Int) -> String {
        let name = String(UnicodeScalar(UInt8(64 - row + earth.sizeVertical))) + "-" + String(col + 1)
        return name
    }
    
    /// Find empty location for animal
    func startCoordRandomize(map: Ground) -> Coord {
        var isOk = false
        var perfectCoord = Coord(col: 0, row: 0)
        while !isOk {
            let col = Int.random(in: 0..<map.sizeHorizontal)
            let row = Int.random(in: 0..<map.sizeVertical)
            if (map.tiles[col][row].isEmpty && map.tiles[col][row].isAcessable) {
                isOk = true
                perfectCoord = Coord(col: col, row: row)
            }
        }
        return perfectCoord
    }
    
    /// Say hello
    func sayHello() -> String {
        let typeLabel = isFemale ? type.labelF : type.labelM
        let helloString = "Меня зовут \"\(name)\", я - \(typeLabel), мой возраст \(age), мой вес \(size)\n"
        return helloString
    }
    
    /// Birthday
    func birthday() {
        age += 1
        let chanceDie = Int.random(in: 0...age)
        print("\(name) - chance of die \(chanceDie) / \(sizeType.lifeTime)")
        if chanceDie > sizeType.lifeTime {
            die()
        }
    }
    
    /// Die
    func die() {
        isAlive = false
        print("\(name) DIED")
    }
}
