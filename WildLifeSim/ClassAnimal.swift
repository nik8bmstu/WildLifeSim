//
//  ClassAnimal.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 16.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import Foundation

let mediumSizeMin = 50
let mediumSizeMax = 75

enum SizeType: String {
    case small
    case medium
    case big
    
    var rawValue: String {
        switch self {
        case .small: return "Маленькое "
        case .medium: return "Среднее "
        case .big: return "Большое "
        }
    }
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

let maleNames: [String] = ["Ричард", "Сэм", "Томас", "Чак"]
let femaleNames: [String] = ["София", "Дейзи", "Кара", "Дора"]

class Animal {
    var id: Int = 1
    var name: String
    var size: Int = 50
    var sizeType: SizeType = .medium
    var age: Int = 0
    var coord: Coord
    var direction: Direction = .down
    var isFemale: Bool
    
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
}
