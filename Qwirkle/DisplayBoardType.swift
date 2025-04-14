//
//  DisplayBoard.swift
//  Qwirkle
//
//  Created by Sanya Arora on 1/26/25.
//

import SwiftUI

struct DisplayBoardType {
    let MINX: Double = -375.0
    let MAXX: Double = 375.0
    let MINY: Double = -667.0
    let MAXY: Double = 667.0
    let TILESIZE: Double = 70
    let TOTAL_NUMBER_OF_TILES: Int = 108
    var squares = [[TileType?]]()
    var isBoardEmpty: Bool = true
    
    init() {
        let rowOfSquares = [TileType?](repeating: nil, count: TOTAL_NUMBER_OF_TILES)
        squares = [[TileType?]](repeating: rowOfSquares, count: TOTAL_NUMBER_OF_TILES)
    }
    
    func tileToLeft(row: Int, column: Int) -> TileType? {
        if column == 0 {
            return nil
        }
        return squares[row][column - 1]
    }
    
    func tileToRight(row: Int, column: Int) -> TileType? {
        if column == TOTAL_NUMBER_OF_TILES - 1 {
            return nil
        }
        return squares[row][column + 1]
    }
    
    func tileAbove(row: Int, column: Int) -> TileType? {
        if row == 0 {
            return nil
        }
        return squares[row + 1][column]
    }
    
    func tileBelow(row: Int, column: Int) -> TileType? {
        if row == TOTAL_NUMBER_OF_TILES - 1 {
            return nil
        }
        return squares[row - 1][column]
    }
    
    func leftNeighbors(row: Int, column: Int) -> [TileType] {
        var neighbors = [TileType]()
        var nextColumn = column
        while let tile = tileToLeft(row: row, column: nextColumn) {
            neighbors.append(tile)
            nextColumn -= 1
        }
        print("left neighbors: \(neighbors)")
        return neighbors
    }
    
    func rightNeighbors(row: Int, column: Int) -> [TileType] {
        var neighbors = [TileType]()
        var nextColumn = column
        while let tile = tileToRight(row: row, column: nextColumn) {
            neighbors.append(tile)
            nextColumn += 1
        }
        print("right neighbors: \(neighbors)")
        return neighbors
    }
    
    func aboveNeighbors(row: Int, column: Int) -> [TileType] {
        var neighbors = [TileType]()
        var nextRow = row
        while let tile = tileAbove(row: nextRow, column: column) {
            neighbors.append(tile)
            nextRow += 1
        }
        print("up neighbors: \(neighbors)")
        return neighbors
    }
    
    func belowNeighbors(row: Int, column: Int) -> [TileType] {
        var neighbors = [TileType]()
        var nextRow = row
        while let tile = tileBelow(row: nextRow, column: column) {
            neighbors.append(tile)
            nextRow -= 1
        }
        print("down neighbors: \(neighbors)")
        return neighbors
    }
    
    mutating func placeTile(tile: TileType, row: Int, column: Int) -> Bool {
        if row >= TOTAL_NUMBER_OF_TILES {
            return false
        }
        
        if column >= TOTAL_NUMBER_OF_TILES {
            return false
        }
        
        if squares[row][column] != nil {
            return false
        }
        
        let left = tileToLeft(row: row, column: column)
        let right = tileToRight(row: row, column: column)
        let above = tileAbove(row: row, column: column)
        let below = tileBelow(row: row, column: column)
        
        if left == nil && right == nil && above == nil && below == nil && !isBoardEmpty {
            return false
        }
        
        if left != nil && (
            (left!.color == tile.color && left!.shape == tile.shape) ||
            (left!.color != tile.color && left!.shape != tile.shape)
        ) {
            return false
        }
        
        if right != nil && (
            (right!.color == tile.color && right!.shape == tile.shape) ||
            (right!.color != tile.color && right!.shape != tile.shape)
        ) {
            return false
        }
        
        if above != nil && (
            (above!.color == tile.color && above!.shape == tile.shape) ||
            (above!.color != tile.color && above!.shape != tile.shape)
        ) {
            return false
        }
        
        if below != nil && (
            (below!.color == tile.color && below!.shape == tile.shape) ||
            (below!.color != tile.color && below!.shape != tile.shape)
        ) {
            return false
        }
        
        for neighbor in leftNeighbors(row: row, column: column) {
            if neighbor.color == tile.color && neighbor.shape == tile.shape {
                return false
            }
        }
        
        for neighbor in rightNeighbors(row: row, column: column) {
            if neighbor.color == tile.color && neighbor.shape == tile.shape {
                return false
            }
        }
        
        for neighbor in aboveNeighbors(row: row, column: column) {
            if neighbor.color == tile.color && neighbor.shape == tile.shape {
                return false
            }
        }
        
        for neighbor in belowNeighbors(row: row, column: column) {
            if neighbor.color == tile.color && neighbor.shape == tile.shape {
                return false
            }
        }
        
        squares[row][column] = tile
        isBoardEmpty = false
        
        print("row: \(row), column: \(column)")
                
        return true
    }
    
    func determinPositionToSnap(clickLocation: CGPoint) -> CGPoint {
        let (row, column) = determineRowAndColumn(clickLocation: clickLocation)
        let snapx = MINX + (TILESIZE / 2) + (TILESIZE * Double(column))
        let snapy = MINY + (TILESIZE / 2) + (TILESIZE * Double(row))
        let snapLocation = CGPoint(x: snapx, y: snapy)
        
        return snapLocation
    }
    
    func determineRowAndColumn(clickLocation: CGPoint) -> (Int, Int) {
        let column = Int((clickLocation.x - MINX) / TILESIZE)
        let row = Int((clickLocation.y - MINY) / TILESIZE)
        return (row, column)
    }
}
