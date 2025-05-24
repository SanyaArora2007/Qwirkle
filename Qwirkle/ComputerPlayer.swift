//
//  ComputerPlayer.swift
//  Qwirkle
//
//  Created by Sanya Arora on 5/12/25.
//


class ComputerPlayer {
    var gameScene: GameScene
    var displayBoard: DisplayBoardType
    var computerRack: TileRackType = .init()
    var gameBag: Bag
    
    init(board: DisplayBoardType, bag: Bag, game: GameScene) {
        displayBoard = board
        gameBag = bag
        computerRack = TileRackType(bag: gameBag)
        gameScene = game
    }
    
    func play() {
        var tilePlaced = 0
        for tile in computerRack.tiles {
            if tile == nil {
                continue
            }
            for row in 0...displayBoard.TOTAL_NUMBER_OF_TILES - 1 {
                for column in 0...displayBoard.TOTAL_NUMBER_OF_TILES - 1 {
                    if displayBoard.canPlaceTile(tile: tile!, row: row, column: column) {
                        let tileLocation = displayBoard.determinePositionToSnapByRowAndColumn(row: row, column: column)
                        let _ = displayBoard.placeTile(tile: tile!, row: row, column: column)
                        gameScene.displayTile(tile: tile!, center: tileLocation, parent: gameScene)
                        computerRack.remove(index: tile!.indexInRack!)
                        tilePlaced += 1
                        break
                    }
                }
                if tile?.indexInRack == nil {
                    break
                }
            }
        }
        if tilePlaced == 0 {
            let _ = computerRack.replenishAllTiles()
        }
        else {
            let _ = computerRack.replenish()
        }

    }
}
