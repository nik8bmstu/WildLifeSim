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

enum Type: String {
    case cow = "cow"
    case horse = "horse"
    case elephant = "elephant"
    case sheep = "sheep"
    
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
        }
    }
}
    
enum SizeType: String {
    case small = "S"
    case medium = "M"
    case large = "L"
}

enum Direction: String {
    case down
    case up
    case left
    case right
    
    var rawValue: String {
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
    // Идентификатор
    var id: Int = 1
    // Имя
    var name: String
    // Вес
    var size: Int = mediumSizeInitMax
    var sizeType: SizeType = .medium
    // Тип
    var type: Type = .cow
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
    var visibilityForward: Int = 4
    var visibilityAround: Int = 2
    // Видимые объекты
    var visibleObjects: [visibleObject] = []
    // Текущий целевой объект
    var targetObject: visibleObject
    // Видимые клетки
    var visibleTiles: [Coord] = []
    
    
    /// Init
    init(myCoord: Coord) {
        isFemale = Bool.random()
        coord = myCoord
        if isFemale {
            name = femaleNames[Int.random(in: 0..<femaleNames.count)]
        } else {
            name = maleNames[Int.random(in: 0..<maleNames.count)]
        }
        targetObject = visibleObject(tile: myCoord, interestLevel: 0, type: .sleep)
        visibleObjects.append(targetObject)
        visibleObjects.append(visibleObject(tile: myCoord, interestLevel: 0, type: .look))
        visibleTiles.append(myCoord)
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
            for i in 2..<visibleObjects.count {
                visibleObjects.remove(at: i)
            }
        }
        // Find new objects
        findObjects(map: map)
        print("\"\(name)\" находит следующие возможности:")
        // Print new object list
        for i in 0..<visibleObjects.count {
            print("\(visibleObjects[i].type.rawValue) на клетке \(transformCoord(col: coord.col, row: coord.row))")
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
        
    }
    
    /// Define available tiles
    func defineVisibleTiles(map: Ground) {
        defineVisibleTilesAround(map: map)
        
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
    
    /// Is tile exist
    func isTileExist(coord: Coord, limit: Coord) -> Bool {
        if ((coord.col >= 0) && (coord.col < limit.col) && (coord.row >= 0)  && (coord.row < limit.row)) {
            return true
        }
        return false
    }
    
    /// Is tile exist
    func isTileAlreadyVisible(coord: Coord) -> Bool {
        
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
        let helloString = "Меня зовут \"\(name)\", я - \(typeLabel), мой возраст \(age), мой вес \(size)"
        return helloString
    }
}
