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
    var animals: [Animal] = []
    
    // Logic step
    func hourStep(map: Ground) {
        //print("Time = \(hour):00")
        hour += 1
        if hour == 24 {
            hour = 0
            day += 1
            calcFood(map: map)
        }
        isDayTime = ((7 < hour) && (hour < 20)) ? true : false
        for i in 0..<animalCount {
            
            //print(animals[i].sayHello())
            switch Int.random(in: 0...1) {
            case 1:
                animals[i].rotateLeft()
            default:
                animals[i].rotateRight()
            }
            animals[i].look(map: earth)
        }
    }
    
    /// Init start animal pool
    func animalsInit() {
        // Place animals
        for i in 0...1 {
            let coord = animalCoordRandomize()
            var newAnimal = Animal(myCoord: coord)
            newAnimal.placeOnGround(earth: earth)
            newAnimal.sizeType = .medium
            newAnimal.id = animalCount
            newAnimal.size = Int.random(in: mediumSizeInitMin...mediumSizeInitMax)
            newAnimal.direction = .down
            newAnimal.type = .horse
            animalCount += 1
            herbivorousCount += 1
            // predatorCount += 1
            animals.append(newAnimal)
        }
        for i in 0...1 {
            let coord = animalCoordRandomize()
            var newAnimal = Animal(myCoord: coord)
            newAnimal.placeOnGround(earth: earth)
            newAnimal.sizeType = .medium
            newAnimal.id = animalCount
            newAnimal.size = Int.random(in: mediumSizeInitMin...mediumSizeInitMax)
            newAnimal.direction = .up
            newAnimal.type = .cow
            animalCount += 1
            herbivorousCount += 1
            // predatorCount += 1
            animals.append(newAnimal)
        }
        for i in 0...1 {
            let coord = animalCoordRandomize()
            var newAnimal = Animal(myCoord: coord)
            newAnimal.placeOnGround(earth: earth)
            newAnimal.sizeType = .medium
            newAnimal.id = animalCount
            newAnimal.size = Int.random(in: mediumSizeInitMin...mediumSizeInitMax)
            newAnimal.direction = .left
            newAnimal.type = .sheep
            animalCount += 1
            herbivorousCount += 1
            // predatorCount += 1
            animals.append(newAnimal)
        }
        for i in 0...1 {
            let coord = animalCoordRandomize()
            var newAnimal = Animal(myCoord: coord)
            newAnimal.placeOnGround(earth: earth)
            newAnimal.sizeType = .medium
            newAnimal.id = animalCount
            newAnimal.size = Int.random(in: mediumSizeInitMin...mediumSizeInitMax)
            newAnimal.direction = .right
            newAnimal.type = .sheep
            animalCount += 1
            //herbivorousCount += 1
            predatorCount += 1
            animals.append(newAnimal)
        }
        currentAnimal = animals.endIndex
    }
    
    /// Find empty location for animal
    func animalCoordRandomize() -> Coord {
        var isOk = false
        var perfectCoord = Coord(col: 0, row: 0)
        while !isOk {
            let col = Int.random(in: 0..<earth.sizeHorizontal)
            let row = Int.random(in: 0..<earth.sizeVertical)
            if (earth.tiles[col][row].isEmpty && earth.tiles[col][row].isAcessable)  {
                isOk = true
                perfectCoord = Coord(col: col, row: row)
            }
        }
        return perfectCoord
    }
    
    /// Return animal index by coord
    func getAnimalIndex(coord: Coord) -> Int {
        for i in 0..<animalCount {
            if animals[i].coord.col == coord.col && animals[i].coord.row == coord.row {
                return i
            }
        }
        return 0
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


