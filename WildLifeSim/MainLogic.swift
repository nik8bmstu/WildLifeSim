//
//  MainLogic.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 15.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import Foundation

class Environment {
    var hour: Int = 0
    var day: Int = 0
    var isDayTime: Bool = false
    var foodCount: Int = 0
    var animalCount: Int = 0
    var herbivorousCount: Int = 0
    var predatorCount: Int = 0
    var currentAnimal: Int = 0
    
    // Logic step
    func hourStep(map: Ground) {
        calcFood(map: map)
    }
    
    /// Calc food count
    func calcFood(map: Ground) {
        foodCount = 0
        for column in 0..<map.sizeHorizontal {
            for row in 0..<map.sizeVertical {
                let currentTileFood = map.tiles[column][row].foodCount
                let currentTileType = map.tiles[column][row].type
                if currentTileType == "forest" {
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
                    foodCount += newTileFood
                }
            }
        }
        print("FOOD = \(foodCount)")
    }
}


