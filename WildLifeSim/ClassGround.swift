//
//  ClassGround.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 14.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import Foundation
import UIKit


struct Tile {
    var type: String
    var foodCount: Int
    var waterHere: Bool
}

/// Ground class
class Ground {
    var sizeHorizontal: Int = 20
    var sizeVertical: Int = 20
    var sizeTile: Int = 20
    var tiles: [[Tile]] = []
    var offset: Int = 11
    
    let tileDefault = Tile(type: "grass", foodCount: 0, waterHere: false)
    
    func initTiles() {
        self.tiles = Array(repeating: Array(repeating: tileDefault, count: sizeVertical), count: sizeHorizontal)
        for h in 0..<sizeHorizontal {
        for v in 0..<sizeVertical {
            let rand = Int.random(in: 0..<50)
            switch rand {
            case 0, 1:
                let food = Int.random(in: 0...3)
                self.tiles[h][v] = Tile(type: "forest", foodCount: food, waterHere: false)
            case 2:
                self.tiles[h][v] = Tile(type: "mountain", foodCount: 0, waterHere: false)
            case 3:
                self.tiles[h][v] = Tile(type: "rock", foodCount: 0, waterHere: false)
            case 4:
                self.tiles[h][v] = Tile(type: "water", foodCount: 0, waterHere: true)
            default:
                self.tiles[h][v] = tileDefault
            }
            }
        }
    }
    
    
}
