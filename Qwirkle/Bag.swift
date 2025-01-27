//
//  Bag.swift
//  Qwirkle
//
//  Created by Sanya Arora on 1/21/25.
//

struct Bag {
    var tiles: [TileType] = []
    let numberOfTileOfTheSameColorAndShape = 3
    
    init() {
        for shape in TileType.ShapeType.allCases {
            for color in TileType.ColorType.allCases {
                for _ in 1...numberOfTileOfTheSameColorAndShape {
                    let newTile = TileType(requestedShape: shape, requestedColor: color)
                    tiles.append(newTile)
                }
            }
        }
    }
    
    mutating func pickRandom() -> TileType {
        let randomInt = Int.random(in: 0...tiles.count - 1)
        return tiles.remove(at: randomInt)
    }
}
