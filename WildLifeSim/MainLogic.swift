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
    var totalAnimalCount: Int = 0
    var animalCount: Int = 0
    var herbivorousCount: Int = 0
    var predatorCount: Int = 0
    var animals: [Animal] = []
    
    // Logic step: act, look, think, repeat ;)
    func hourStep(map: Ground) {
        hour += 1
        if hour == 24 {
            hour = 0
            day += 1
            calcFood(map: map)
        }
        isDayTime = ((7 < hour) && (hour < 20)) ? true : false
        animals.shuffle()
        var deadAnimals: Int = 0
        for i in 0..<animalCount {
            animals[i].legend = ""
            // Act from previous step is first for correct environment
            animals[i].act(map: earth, neighbors: self)
            animals[i].demandsGrow()
            animals[i].look(map: earth, neighbors: self)
            animals[i].think(map: earth, neighbors: self)
            if !animals[i].isAlive {
            deadAnimals += 1
            }
            if hour == 0 {
                animals[i].birthday()
            }
        }
        while deadAnimals > 0 {
            for i in 0..<animals.count {
                if !animals[i].isAlive {
                    map.tiles[animals[i].coord.col][animals[i].coord.row].meatCount = animals[i].size / 10
                    animals.remove(at: i)
                    deadAnimals -= 1
                    break
                }
            }
        }
        animalCount = animals.count
    }
    
    /// Init start animal pool
    func animalsInit() {
        // Place animals
        for _ in 0...1 {
            animals.append(Animal(map: earth, myType: .sheep))
            animals.append(Animal(map: earth, myType: .cow))
            animals.append(Animal(map: earth, myType: .horse))
            animals.append(Animal(map: earth, myType: .goat))
            animals.append(Animal(map: earth, myType: .chicken))
        }
        animalCount = animals.count
        totalAnimalCount = animalCount
        for i in 0..<animalCount {
            animals[i].defineVisibleTiles(map: earth)
        }
    }
    
    
    
    /// Return animal index by coord
    func getAnimalIndex(coord: Coord) -> Int {
        for i in 0..<animalCount {
            if animals[i].coord.col == coord.col && animals[i].coord.row == coord.row {
                return i
            }
        }
        return -1
    }
    
    /// Calc food count
    func calcFood(map: Ground) {
        foodCount = 0
        for column in 0..<map.sizeHorizontal {
            for row in 0..<map.sizeVertical {
                let currentTileFood = map.tiles[column][row].foodCount
                let currentTileType = map.tiles[column][row].type
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
                    foodCount += newTileFood
                    map.tiles[column][row].foodCount = newTileFood
                }
            }
        }
        print("FOOD = \(foodCount)")
    }
}


