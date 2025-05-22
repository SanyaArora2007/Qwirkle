//
//  DisplayBoard.swift
//  Qwirkle
//
//  Created by Sanya Arora on 1/26/25.
//

import SwiftUI

class DisplayBoardType {
    
    struct Coordinate {
        var row: Int = 0
        var column: Int = 0
        
        init(row: Int, column: Int) {
            self.row = row
            self.column = column
        }
    }
    
    let MINX: Double = -375.0
    let MAXX: Double = 375.0
    let MINY: Double = -397.0
    let MAXY: Double = 397.0
    let TILESIZE: Double = 60
    let NUMROWS: Int = 14
    let NUMCOLUMNS: Int = 12
    var squares = [[TileType?]]()
    var isBoardEmpty: Bool = true
    var playerScore: Int = 0
    var computerScore: Int = 0
    var tilesInCurrentTurn: [TileType] = []
    
    init() {
        let rowOfSquares = [TileType?](repeating: nil, count: NUMCOLUMNS)
        squares = [[TileType?]](repeating: rowOfSquares, count: NUMROWS)
    }
    
    func tileToLeft(row: Int, column: Int) -> TileType? {
        if column == 0 {
            return nil
        }
        return squares[row][column - 1]
    }
    
    func tileToRight(row: Int, column: Int) -> TileType? {
        if column == NUMCOLUMNS - 1 {
            return nil
        }
        return squares[row][column + 1]
    }
    
    func tileAbove(row: Int, column: Int) -> TileType? {
        if row == NUMROWS - 1 {
            return nil
        }
        return squares[row + 1][column]
    }
    
    func tileBelow(row: Int, column: Int) -> TileType? {
        if row == 0 {
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
        return neighbors
    }
    
    func rightNeighbors(row: Int, column: Int) -> [TileType] {
        var neighbors = [TileType]()
        var nextColumn = column
        while let tile = tileToRight(row: row, column: nextColumn) {
            neighbors.append(tile)
            nextColumn += 1
        }
        return neighbors
    }

    func aboveNeighbors(row: Int, column: Int) -> [TileType] {
        var neighbors = [TileType]()
        var nextRow = row
        while let tile = tileAbove(row: nextRow, column: column) {
            neighbors.append(tile)
            nextRow += 1
        }
        return neighbors
    }
    
    func belowNeighbors(row: Int, column: Int) -> [TileType] {
        var neighbors = [TileType]()
        var nextRow = row
        while let tile = tileBelow(row: nextRow, column: column) {
            neighbors.append(tile)
            nextRow -= 1
        }
        return neighbors
    }
    
    func isShapeMatching(neighbors: [TileType]) -> Bool {
        if neighbors.count < 2 {
            return true
        }
        for index in 1...neighbors.count - 1 {
            if neighbors[index].shape != neighbors[index - 1].shape {
                return false
            }
        }
        return true
    }
    
    func isColorMatching(neighbors: [TileType]) -> Bool {
        if neighbors.count < 2 {
            return true
        }
        for index in 1...neighbors.count - 1 {
            if neighbors[index].color != neighbors[index - 1].color {
                return false
            }
        }
        return true
    }
    
    func checkDirection(neighbors: [TileType], tile: TileType) -> Bool {
        if neighbors.isEmpty {
            return true
        }
        if neighbors.count == 1 {
            if neighbors[0].color != tile.color && neighbors[0].shape != tile.shape {
                return false
            }
        }
        else {
            if isColorMatching(neighbors: neighbors) {
                if neighbors[0].color != tile.color {
                    return false
                }
            }
            else if isShapeMatching(neighbors: neighbors) {
                if neighbors[0].shape != tile.shape {
                    return false
                }
            }
            else {
                return false
            }
        }
        return true
    }
    
    func canPlaceTile(tile: TileType, row: Int, column: Int) -> Bool {
        if row >= NUMROWS {
            return false
        }
        
        if column >= NUMCOLUMNS {
            return false
        }
        
        if squares[row][column] != nil {
            return false
        }
        
        let left = tileToLeft(row: row, column: column)
        let right = tileToRight(row: row, column: column)
        let above = tileAbove(row: row, column: column)
        let below = tileBelow(row: row, column: column)
        
        let leftTiles = leftNeighbors(row: row, column: column)
        let rightTiles = rightNeighbors(row: row, column: column)
        let aboveTiles = aboveNeighbors(row: row, column: column)
        let belowTiles = belowNeighbors(row: row, column: column)
        
        if left == nil && right == nil && above == nil && below == nil && !isBoardEmpty {
            return false
        }
        
        for neighbor in leftTiles {
            if neighbor.color == tile.color && neighbor.shape == tile.shape {
                return false
            }
        }
        
        for neighbor in rightTiles {
            if neighbor.color == tile.color && neighbor.shape == tile.shape {
                return false
            }
        }
        
        for neighbor in aboveTiles {
            if neighbor.color == tile.color && neighbor.shape == tile.shape {
                return false
            }
        }
        
        for neighbor in belowTiles {
            if neighbor.color == tile.color && neighbor.shape == tile.shape {
                return false
            }
        }
        
        if !checkDirection(neighbors: leftTiles, tile: tile) {
            return false
        }
        
        if !checkDirection(neighbors: rightTiles, tile: tile) {
            return false
        }
        
        if !checkDirection(neighbors: aboveTiles, tile: tile) {
            return false
        }
        
        if !checkDirection(neighbors: belowTiles, tile: tile) {
            return false
        }
        return true
    }
    
    func placeTile(tile: TileType ,row: Int, column: Int, playersTurn: Bool) -> Bool {
        if !canPlaceTile(tile: tile, row: row, column: column) {
            return false
        }
        tile.positionOnGameBoard = Coordinate(row: row, column: column)
        tile.placedInCurrentTurn = true
        if playersTurn == true {
            updatePlayerScore(row: row, column: column)
        }
        else {
            updateComputerScore(row: row, column: column)
        }
        squares[row][column] = tile
        tilesInCurrentTurn.append(tile)
        isBoardEmpty = false
        
        print("(\(row), \(column))")
        
        return true
    }
      
    
    func calculateScore(row: Int, column: Int) -> Int {
        var numberOfPreviousLeftNeighbors = 0
        var score = 0
        let leftNeighbors = leftNeighbors(row: row, column: column)
        for neighbor in leftNeighbors {
            if neighbor.placedInCurrentTurn == false {
                numberOfPreviousLeftNeighbors += 1
            }
            else {
                break
            }
        }
        if numberOfPreviousLeftNeighbors > 0  {
            score += (numberOfPreviousLeftNeighbors + 1)
        }
            
        var numberOfPreviousRightNeighbors = 0
        let rightNeighbors = rightNeighbors(row: row, column: column)
        for neighbor in rightNeighbors {
            if neighbor.placedInCurrentTurn == false {
                numberOfPreviousRightNeighbors += 1
            }
            else {
                break
            }
        }
        if numberOfPreviousRightNeighbors > 0  {
            score += (numberOfPreviousRightNeighbors + 1)
        }
        
        var numberOfPreviousAboveNeighbors = 0
        let aboveNeighbors = aboveNeighbors(row: row, column: column)
        for neighbor in aboveNeighbors {
            if neighbor.placedInCurrentTurn == false {
                numberOfPreviousAboveNeighbors += 1
            }
            else {
                break
            }
        }
        if numberOfPreviousAboveNeighbors > 0  {
            score += (numberOfPreviousAboveNeighbors + 1)
        }
        
        var numberOfPreviousBelowNeighbors = 0
        let belowNeighbors = belowNeighbors(row: row, column: column)
        for neighbor in belowNeighbors {
            if neighbor.placedInCurrentTurn == false {
                numberOfPreviousBelowNeighbors += 1
            }
            else {
                break
            }
        }
        if numberOfPreviousBelowNeighbors > 0  {
            score += (numberOfPreviousBelowNeighbors + 1)
        }
            
        if numberOfPreviousLeftNeighbors == 0 &&
            numberOfPreviousRightNeighbors == 0 &&
            numberOfPreviousAboveNeighbors == 0 &&
            numberOfPreviousBelowNeighbors == 0 {
            score += 1
        }
        
        if leftNeighbors.count == 5 {
            score += 6
        }
        
        if rightNeighbors.count == 5 {
            score += 6
        }
        
        if aboveNeighbors.count == 5 {
            score += 6
        }
        
        if belowNeighbors.count == 5 {
            score += 6
        }
        return score
    }
    
    func updatePlayerScore(row: Int, column: Int) {
        playerScore += calculateScore(row: row, column: column)
    }
    
    func updateComputerScore(row: Int, column: Int) {
        computerScore += calculateScore(row: row, column: column)
    }
    
    func turnCompleted() {
        for tile in tilesInCurrentTurn {
            tile.placedInCurrentTurn = false
        }
        tilesInCurrentTurn.removeAll()
    }
    
    func determinPositionToSnap(clickLocation: CGPoint) -> CGPoint {
        let (row, column) = determineRowAndColumn(clickLocation: clickLocation)
        return determinePositionToSnapByRowAndColumn(row: row, column: column)
    }
    
    func determinePositionToSnapByRowAndColumn(row: Int, column: Int) -> CGPoint {
        let snapx = MINX + (TILESIZE / 2) + (TILESIZE * Double(column))
        let snapy = MINY + (TILESIZE / 2) + (TILESIZE * Double(row))
        let snapLocation = CGPoint(x: snapx, y: snapy)
        
        print("coordinatE: \(snapLocation)")
        
        return snapLocation
    }
    
    func determineRowAndColumn(clickLocation: CGPoint) -> (Int, Int) {
        let column = Int((clickLocation.x - MINX) / TILESIZE)
        let row = Int((clickLocation.y - MINY) / TILESIZE)
        return (row, column)
    }
}
