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
            foodCount = map.calcFood()
        }
        isDayTime = ((7 < hour) && (hour < 20)) ? true : false
        animals.shuffle()
        var deadAnimals: Int = 0
        predatorCount = 0
        herbivorousCount = 0
        for i in 0..<animalCount {
            animals[i].legend = ""
            // Act from previous step is first for correct environment
            animals[i].act(map: earth, neighbors: self)
            foodCount = map.getFoodCount()
            animals[i].demandsGrow()
            animals[i].look(map: earth, neighbors: self)
            animals[i].think(map: earth, neighbors: self)
            if !animals[i].isAlive {
                deadAnimals += 1
            }
            if animals[i].isPredator {
                predatorCount += 1
            } else {
                herbivorousCount += 1
            }
                
            if animals[i].isPregnant {
                animals[i].pregnantTime += 1
                if animals[i].pregnantTime >= animals[i].sizeType.pregnantTime {
                    let birthTileCoord = animals[i].giveBirth(map: earth)
                    if birthTileCoord.col != -1 {
                        newAnimalBirth(birthTile: birthTileCoord, parent: animals[i])
                    }
                }
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
        let randomPlace = Coord(col: -1, row: -1)
        let initCount = earth.sizeHorizontal * earth.sizeVertical / 50
        // Place animals
        for _ in 0..<initCount {
            animals.append(Animal(map: earth, place: randomPlace, myType: generateAnimalType()))
        }
        animalCount = animals.count
        totalAnimalCount = animalCount
        for i in 0..<animalCount {
            animals[i].defineVisibleTiles(map: earth)
        }
    }
    
    /// Type generator
    func generateAnimalType() -> Type {
        return Type.allCases[Int.random(in: 0..<Type.allCases.count)]
    }
    
    /// New animal birth
    func newAnimalBirth(birthTile: Coord, parent: Animal) {
        let newAnimal = Animal(map: earth, place: birthTile, myType: parent.type)
        newAnimal.defineVisibleTiles(map: earth)
        newAnimal.generation = parent.generation + 1
        animals.append(newAnimal)
        animalCount = animals.count
        totalAnimalCount += 1
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
    

}


