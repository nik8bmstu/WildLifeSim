//
//  ClassGround.swift
//  WildLifeSim
//
//  Created by Николай Соломатин on 14.05.2020.
//  Copyright © 2020 Николай Соломатин. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var ground: UIColor  { return UIColor(red: 140.0/255.0, green: 140.0/255.0, blue: 90.0/255.0, alpha: 1.0) }
    static var grass: UIColor { return UIColor(red: 115.0/255.0, green: 230.0/255.0, blue: 120.0/255.0, alpha: 1.0) }
    static var forest: UIColor { return UIColor(red: 80.0/255.0, green: 140.0/255.0, blue: 100.0/255.0, alpha: 1.0) }
}


struct Tile {
    var type: UIColor
    var foodCount: Int
}

/// Ground class
class Ground {
    var sizeHorizontal: Int = 20
    var sizeVertical: Int = 20
    var sizeTile: Int = 20
    var tiles: [[Tile]] = []
    var offset: Int = 11
    
    let tileDefault = Tile(type: UIColor.ground, foodCount: 0)
    
    func initTiles() {
        self.tiles = Array(repeating: Array(repeating: tileDefault, count: sizeVertical), count: sizeHorizontal)
        for h in 0..<sizeHorizontal {
        for v in 0..<sizeVertical {
            let rand = Int.random(in: 0 ..< 10)
            switch rand {
            case 0:
                self.tiles[h][v] = Tile(type: UIColor.forest, foodCount: 4)
            case 1:
                self.tiles[h][v] = Tile(type: UIColor.grass, foodCount: 2)
            default:
                self.tiles[h][v] = tileDefault
            }
            }
        }
    }
    
    func draw() -> UIView {
        let groundView = UIView()
        
        groundView.backgroundColor = .white
        for h in 0..<sizeHorizontal {
            for v in 0..<sizeVertical {
                //let boundRect = CGRect(x: h * sizeTile + offset, y: v * sizeTile + offset, width: sizeTile, height: sizeTile)
                //var tempView = DrawTitle(frame: boundRect)
                //tempView.tile = tiles[h][v]
                //tempView.backgroundColor = .black
                //groundView.addSubview(tempView)
            }
        }
        
        return groundView
    }
    
}
