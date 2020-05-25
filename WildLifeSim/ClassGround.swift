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
    var type: TileType
    var foodCount: Int
    var waterHere: Bool
    var isEmpty: Bool
    var isAcessable: Bool
    var meatCount: Int
}

enum TileType: String {
    case forest
    case mountain
    case water
    case grass
    
    var rawValue: String {
        switch self {
            case .forest: return "Лес"
            case .mountain: return "Гора"
            case .water: return "Вода"
            case .grass: return "Трава"
        }
    }
}

/// Ground class
class Ground {
    var sizeHorizontal: Int = 20
    var sizeVertical: Int = 20
    var sizeTile: Int = 90
    var tiles: [[Tile]] = []
    var initFoodCount: Int = 0
    var totalFoodCount: Int = 0
    
    let tileDefault = Tile(type: .grass, foodCount: 0, waterHere: false, isEmpty: true, isAcessable: true, meatCount: 0)
    
    func initTiles() {
        self.tiles = Array(repeating: Array(repeating: tileDefault, count: sizeVertical), count: sizeHorizontal)
        for h in 0..<sizeHorizontal {
        for v in 0..<sizeVertical {
            let rand = Int.random(in: 0..<50)
            switch rand {
            case 0, 1:
                let food = Int.random(in: 0...3)
                initFoodCount += food
                self.tiles[h][v] = Tile(type: .forest, foodCount: food, waterHere: false, isEmpty: true, isAcessable: false, meatCount: 0)
            case 2:
                self.tiles[h][v] = Tile(type: .mountain, foodCount: 0, waterHere: false, isEmpty: true, isAcessable: false, meatCount: 0)
            case 3:
                self.tiles[h][v] = Tile(type: .water, foodCount: 0, waterHere: true, isEmpty: true, isAcessable: false, meatCount: 0)
            default:
                self.tiles[h][v] = tileDefault
            }
            }
        }
    }
    
    func getFoodCount() -> Int {
        totalFoodCount = 0
        for column in 0..<sizeHorizontal {
        for row in 0..<sizeVertical {
            totalFoodCount += tiles[column][row].foodCount
            }
        }
        return totalFoodCount
    }
    
    /// Calc food count
    func calcFood() -> Int {
        totalFoodCount = 0
        for column in 0..<sizeHorizontal {
            for row in 0..<sizeVertical {
                let currentTileFood = tiles[column][row].foodCount
                let currentTileType = tiles[column][row].type
                if currentTileType == .forest {
                    var newTileFood = 0
                    let chance = Int.random(in: 0...100)
                    switch currentTileFood {
                    case 1:
                        switch chance {
                        case 0...10:
                            newTileFood = 2
                        case 11...70:
                            newTileFood = 1
                        default:
                            newTileFood = 0
                        }
                    case 2:
                        switch chance {
                        case 0...10:
                            newTileFood = 3
                        case 11...60:
                            newTileFood = 2
                        default:
                            newTileFood = 1
                        }
                    case 3:
                        switch chance {
                        case 0...60:
                            newTileFood = 2
                        default:
                            newTileFood = 3
                        }
                    default:
                        switch chance {
                        case 0...60:
                            newTileFood = 1
                        default:
                            newTileFood = 0
                        }
                    }
                    totalFoodCount += newTileFood
                    tiles[column][row].foodCount = newTileFood
                }
            }
        }
        //print("FOOD = \(totalFoodCount)")
        return totalFoodCount
    }
}
