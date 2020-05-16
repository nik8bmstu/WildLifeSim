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

enum SizeType {
    case small
    case medium
    case big
}

struct Coord {
    var col: Int
    var row: Int
}

class Animal {
    var id: Int = 1
    var name: String
    var size: Int = 50
    var sizeType: SizeType = .medium
    var age: Int = 0
    var coord: Coord
    
    init(myName: String, myCoord: Coord) {
        coord = myCoord
        name = myName
    }
    
    func placeOnGround(earth: Ground) {
        earth.tiles[coord.col][coord.row].isEmpty = false
        print("Animal placed at \(coord)")
    }
}
