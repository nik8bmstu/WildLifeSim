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
}

/// Ground class
class Ground {
    var sizeHorizontal: Int = 20
    var sizeVertical: Int = 20
    var sizeTile: Int = 20
    var tiles: [[Tile]] = []
    var offset: Int = 11
    
    let tileDefault = Tile(type: "ground", foodCount: 0)
    
    func initTiles() {
        self.tiles = Array(repeating: Array(repeating: tileDefault, count: sizeVertical), count: sizeHorizontal)
        for h in 0..<sizeHorizontal {
        for v in 0..<sizeVertical {
            let rand = Int.random(in: 0 ..< 10)
            switch rand {
            case 0:
                self.tiles[h][v] = Tile(type: "forest", foodCount: 4)
            case 1:
                self.tiles[h][v] = Tile(type: "grass", foodCount: 2)
            default:
                self.tiles[h][v] = tileDefault
            }
            }
        }
    }
    
    
}
