//
//  ClassAnimal.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 16.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import Foundation

let smallSizeMin = 1
let smallSizeMax = 25
let smallSizeInitMin = 10
let smallSizeInitMax = 20

let mediumSizeMin = 50
let mediumSizeMax = 90
let mediumSizeInitMin = 65
let mediumSizeInitMax = 80

let largeSizeMin = 90
let largeSizeMax = 150
let largeSizeInitMin = 110
let largeSizeInitMax = 130


let initFoodInterest = 10
let initWaterInterest = 5

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
}
    
enum SizeType: String {
    case small = "S"
    case medium = "M"
    case large = "L"
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
    case danger = "Избежать опасности"
    case food = "Добыть еды"
    case partner = "Найти партнера"
    case water = "Выпить воды"
    case sleep = "Поспать"
    case look = "Осмотреться"
}

struct visibleObject {
    var tile: Coord
    var interestLevel: Int
    var type: visObjType
}


let maleNames: [String] = ["Ричард", "Сэм", "Томас", "Чак", "Говард", "Игнасио", "Клайд", "Снежок", "Рудольф", "Бильбо", "Имхотеп", "Кеша", "Борис", "Том", "Шанти", "Джон", "Мигель", "Кремень", "Лео", "Джерри"]
let femaleNames: [String] = ["София", "Дейзи", "Кара", "Дора", "Бонни", "Сара", "Мэри", "Люси", "Сюзанна", "Мария", "Ромашка", "Колокольчик", "Лиза", "Эбигейл", "Астра", "Пандора", "Кэт", "Бэт", "Черри", "Роза"]

class Animal {
    // Имя
    var name: String
    // Вес
    var size: Int = mediumSizeInitMax
    var sizeType: SizeType = .medium
    // Тип
    var type: Type = .cow
    var isPredator: Bool = false
    // Возраст
    var age: Int = 0
    // Параметры расположения
    var coord: Coord
    var direction: Direction = .down
    // Пол
    var isFemale: Bool
    // Очки действий
    var actionPoints: Int = 6
    // Поле видимости
    var visibilityForward: Int = 5
    var visibilityAround: Int = 2
    // Видимые объекты
    var visibleObjects: [visibleObject] = []
    // Текущий целевой объект
    var targetObject: visibleObject
    // Видимые клетки
    var visibleTiles: [Coord] = []
    // legend
    var legend: String = ""
    
    /// Init
    init(myCoord: Coord, myType: Type) {
        // Get type
        type = myType
        // Get food type
        switch type {
        case .cow, .elephant, .goat, .horse, .sheep:
            isPredator = false
        default:
            isPredator = true
        }
        // Get size
        switch type {
        case .chicken:
            sizeType = .small
            size = Int.random(in: smallSizeInitMin...smallSizeInitMax)
        case .elephant:
            sizeType = .large
            size = Int.random(in: largeSizeInitMin...largeSizeInitMax)
        default:
            sizeType = .medium
            size = Int.random(in: mediumSizeInitMin...mediumSizeInitMax)
        }
        // Chose gender
        isFemale = Bool.random()
        // Get coord
        coord = myCoord
        // Chose name
        if isFemale {
            name = femaleNames[Int.random(in: 0..<femaleNames.count)]
        } else {
            name = maleNames[Int.random(in: 0..<maleNames.count)]
        }
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
        // define target and visible tiles
        targetObject = visibleObject(tile: myCoord, interestLevel: 0, type: .sleep)
        visibleObjects.append(targetObject)
        visibleObjects.append(visibleObject(tile: myCoord, interestLevel: 0, type: .look))
        visibleTiles.append(myCoord)
        legend = sayHello()
    }
    
    func placeOnGround(earth: Ground) {
        earth.tiles[coord.col][coord.row].isEmpty = false
        print("Animal placed at \(coord)")
    }
    
    
    // Global actions (look, think, act)
    
    /// Look
    func look(map: Ground) {
        print(" ")
        print("\"\(name)\" осматривается...")
        // Delete old objects excepting sleep and look
        if visibleObjects.count > 2 {
            let count = visibleObjects.count
            for _ in 2..<count {
                visibleObjects.remove(at: 2)
            }
        }
        // Find new objects
        findObjects(map: map)
        print("\"\(name)\" находит следующие возможности:")
        // Print new object list
        for i in 0..<visibleObjects.count {
            print("\(visibleObjects[i].type.rawValue) на клетке \(transformCoord(col: visibleObjects[i].tile.col, row: visibleObjects[i].tile.row))")
        }
    }
    
    // Actions
    
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
    }
    
    
    // Stuff functions
    
    /// Find objects
    func findObjects(map: Ground) {
        defineVisibleTiles(map: map)
        for i in 1..<visibleTiles.count {
            let currentCoord = Coord(col: visibleTiles[i].col, row: visibleTiles[i].row)
            let tile = map.tiles[currentCoord.col][currentCoord.row]
            if (tile.foodCount > 0) && !isPredator {
                let object = visibleObject(tile: currentCoord, interestLevel: initFoodInterest * tile.foodCount, type: .food)
                visibleObjects.append(object)
            }
            if tile.waterHere {
                let object = visibleObject(tile: currentCoord, interestLevel: initWaterInterest, type: .water)
                visibleObjects.append(object)
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
        var visibleTilesString = "\"\(name)\" видит следующие клетки: "
        visibleTilesString.append("\(transformCoord(col: visibleTiles[0].col, row: visibleTiles[0].row))")
        if visibleTiles.count > 1 {
            for i in 1..<visibleTiles.count {
                visibleTilesString.append(", \(transformCoord(col: visibleTiles[i].col, row: visibleTiles[i].row))")
            }
        }
        print(visibleTilesString)
    }
    
    /// Define visible tiles around
    func defineVisibleTilesAround(map: Ground) {
        let limitCoord = Coord(col: map.sizeHorizontal, row: map.sizeVertical)
         for row in (coord.row - visibilityAround)...(coord.row + visibilityAround) {
            for col in (coord.col - visibilityAround)...(coord.col + visibilityAround) {
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
            visDown = visibilityForward
            visUp = 0
        case .left:
            visLeft = visibilityForward
            visRight = 0
        case .right:
            visRight = visibilityForward
            visLeft = 0
        default: // .up
            visUp = visibilityForward
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
    
    /// Is tile exist
    func isTileAlreadyVisible(coord: Coord) -> Bool {
        for i in 0..<visibleTiles.count {
            if ((visibleTiles[i].col == coord.col) && (visibleTiles[i].row == coord.row)) {
                return true
            }
        }
        return false
    }
    
    
    /// Transform tile coord to Literal-Numeric
    func transformCoord(col: Int, row: Int) -> String {
        let name = String(UnicodeScalar(UInt8(64 - row + earth.sizeVertical))) + "-" + String(col + 1)
        return name
    }
    
    /// Say hello
    func sayHello() -> String {
        let typeLabel = isFemale ? type.labelF : type.labelM
        let helloString = "Меня зовут \"\(name)\", я - \(typeLabel), мой возраст \(age), мой вес \(size)\n"
        return helloString
    }
}
