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
            return "Корова "
        case .horse:
            return "Лошадь "
        case .elephant:
            return "Слониха "
        case .sheep:
            return "Овца "
        }
    }
    var labelM: String {
        switch self {
        case .cow:
            return "Бык "
        case .horse:
            return "Конь "
        case .elephant:
            return "Слон "
        case .sheep:
            return "Баран "
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

let maleNames: [String] = ["Ричард", "Сэм", "Томас", "Чак", "Говард", "Игнасио", "Клайд", "Снежок", "Рудольф", "Бильбо", "Имхотеп", "Кеша", "Борис", "Том", "Шанти", "Джон", "Мигель", "Кремень", "Лео", "Джерри"]
let femaleNames: [String] = ["София", "Дейзи", "Кара", "Дора", "Бонни", "Сара", "Мэри", "Люси", "Сюзанна", "Мария", "Ромашка", "Колокольчик", "Лиза", "Эбигейл", "Астра", "Пандора", "Кэт", "Бэт", "Черри", "Роза"]

class Animal {
    var id: Int = 1
    var name: String
    var size: Int = mediumSizeInitMax
    var sizeType: SizeType = .medium
    var type: Type = .cow
    var age: Int = 0
    var coord: Coord
    var direction: Direction = .down
    var isFemale: Bool
    var actionPoints: Int = 6
    
    init(myCoord: Coord) {
        isFemale = Bool.random()
        coord = myCoord
        if isFemale {
            name = femaleNames[Int.random(in: 0..<femaleNames.count)]
        } else {
            name = maleNames[Int.random(in: 0..<maleNames.count)]
        }
    }
    
    func placeOnGround(earth: Ground) {
        earth.tiles[coord.col][coord.row].isEmpty = false
        print("Animal placed at \(coord)")
    }
    
    // Actions
    
    ///Rotate left
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
    
    ///Rotate right
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
}
