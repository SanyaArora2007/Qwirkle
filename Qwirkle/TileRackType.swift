//
//  TileRackType.swift
//  Qwirkle
//
//  Created by Sanya Arora on 2/8/25.
//

class TileRackType {
    let MAX_NUMBER_OF_TILES = 6
    var tiles = [TileType?]()
    var gameBag: Bag? = nil

    init(bag: Bag) {
        tiles = [TileType?](repeating: nil, count: MAX_NUMBER_OF_TILES)
        gameBag = bag
        let _ = replenish()
    }
    
    init() {
    }
    
    func remove(index: Int) {
        if index < MAX_NUMBER_OF_TILES {
            tiles[index]?.indexInRack = nil
            tiles[index] = nil
        }
    }
    
    func replenish() -> [Int] {
        var replenishedIndices: [Int] = []
        if gameBag != nil {
            for index in 0...MAX_NUMBER_OF_TILES - 1 {
                if tiles[index] == nil {
                    tiles[index] = gameBag!.pickRandom()
                    tiles[index]!.indexInRack = index
                    replenishedIndices.append(index)
                }
            }
        }
        return replenishedIndices
    }
}
