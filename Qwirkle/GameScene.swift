//
//  GameScene.swift
//  Qwirkle
//
//  Created by Sanya Arora on 1/14/25.
//

import SpriteKit
import AVKit

class GameScene: SKScene {
    
    var turnButton: SKLabelNode!
    var restartGameButton: SKLabelNode!
    var playerScoreLabel: SKLabelNode!
    var computerScoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    let colors = [UIColor.red, UIColor.blue, UIColor.purple, UIColor.yellow, UIColor.orange, UIColor.green]
    var displayBoard: DisplayBoardType? = nil
    
    var gameBag: Bag? = nil
    var playerRack: TileRackType? = nil
    var selectedPlayerTile: DisplayTileType? = nil
    var computer: ComputerPlayer? = nil
    
    var playerRackBox: SKShapeNode? = nil
    
    override func didMove(to view: SKView) {
        startGame()
    }
    
    func startGame() {
        self.displayBoard = DisplayBoardType()
        self.gameBag = Bag()
        self.selectedPlayerTile = nil
        
        self.computer = ComputerPlayer(board: self.displayBoard! ,bag: self.gameBag!, game: self)
        self.playerRack = TileRackType(bag: self.gameBag!)
        
        playerRackBox = SKShapeNode(rectOf: CGSize(width: 750, height: 135))
        self.playerRackBox!.position = CGPoint(x: 0, y: -480)
        self.playerRackBox!.fillColor = .lightGray
        addChild(playerRackBox!)
        
        displayPlayerRack()
        displayTurnButton()
        displayPlayerScoreLabel()
        displayComputerScoreLabel()
    }
    
    
    func displayTile(tile: TileType, center: CGPoint, parent: SKNode) {
        let newTile = DisplayTileType(inputTile: tile, location: center)
        parent.addChild(newTile)
    }
    
    func displayPlayerRack() {
        for i in 0...playerRack!.MAX_NUMBER_OF_TILES - 1 {
            displayTileInPlayerRack(index: i)
        }
    }
    
    func displayTileInPlayerRack(index: Int) {
        let tile = playerRack!.tiles[index]
        
        if tile != nil {
            let x = displayBoard!.MINX + 170 + displayBoard!.TILESIZE * Double(index)
            displayTile(tile: tile!, center: CGPoint(x: CGFloat(x), y: 20), parent: playerRackBox!)
        }
    }
    
    func displayTurnButton() {
        turnButton = SKLabelNode(fontNamed: "Chalkduster")
        turnButton.text = "Done"
        turnButton.position = CGPoint(x: 275, y: -470)
        turnButton.fontSize = 25
        addChild(turnButton)
    }
    
    func displayRestartButton() {
        restartGameButton = SKLabelNode(fontNamed: "Chalkduster")
        restartGameButton.text = "Start New Game"
        restartGameButton.fontColor = .cyan
        restartGameButton.position = CGPoint(x: 0, y: -200)
        restartGameButton.fontSize = 35
        addChild(restartGameButton)
    }
    
    func displayPlayerScoreLabel() {
        playerScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        playerScoreLabel.text = "Your Score: \(displayBoard!.playerScore)"
        playerScoreLabel.position = CGPoint(x: 240, y: 460)
        playerScoreLabel.fontSize = 25
        addChild(playerScoreLabel)
    }
    
    func displayComputerScoreLabel() {
        computerScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        computerScoreLabel.text = "Computer Score: \(displayBoard!.computerScore)"
        computerScoreLabel.position = CGPoint(x: -230, y: 460)
        computerScoreLabel.fontSize = 25
        addChild(computerScoreLabel)
    }
    
    func updatePlayerScoreLabel() {
        playerScoreLabel.text = "Your Score: \(displayBoard!.playerScore)"
    }
    
    func updateComputerScoreLabel() {
        computerScoreLabel.text = "Computer Score: \(displayBoard!.computerScore)"

    }
    
    func gameOver() {
        self.removeAllChildren()
        playerScoreLabel.text = "Your Score: \(displayBoard!.playerScore)"
        playerScoreLabel.fontSize = 30
        playerScoreLabel.position = CGPoint(x: 200, y: 0)
        addChild(playerScoreLabel)
        computerScoreLabel.text = "Computer Score: \(displayBoard!.computerScore)"
        computerScoreLabel.fontSize = 30
        computerScoreLabel.position = CGPoint(x: -175, y: 0)
        addChild(computerScoreLabel)
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontColor = .red
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint(x: 0, y: 200)
        addChild(gameOverLabel)
        displayRestartButton()
        if displayBoard!.playerScore > displayBoard!.computerScore {
            AudioServicesPlaySystemSound(SystemSoundID(1027))
        }
        else {
            AudioServicesPlaySystemSound(SystemSoundID(1024))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let clickLocation = touch.location(in: self)
        
        let nodes = self.nodes(at: clickLocation)
        if nodes.count == 0 {
            // do this when player clicks on game board
            let tileLocation = displayBoard!.determinPositionToSnap(clickLocation: clickLocation)
            let (row, column) = displayBoard!.determineRowAndColumn(clickLocation: clickLocation)
            if selectedPlayerTile != nil {
                let pickedTile = selectedPlayerTile!.tile
                let wasTilePlaced = displayBoard!.placeTile(tile: pickedTile!, row: row, column: column, playersTurn: true)
                if wasTilePlaced {
                    displayTile(tile: pickedTile!, center: tileLocation, parent: self)
                    playerRackBox!.removeChildren(in: [selectedPlayerTile!])
                    playerRack!.remove(index: pickedTile!.indexInRack!)
                    selectedPlayerTile = nil
                    updatePlayerScoreLabel()
                }
            }
        }
            
        else {
            // do this when player clicks on tile rack
            for node in nodes {
                let displayTile = node as? DisplayTileType
                if displayTile != nil && displayTile!.parent == playerRackBox {
                    selectedPlayerTile?.removeGlow()
                    selectedPlayerTile = displayTile
                    selectedPlayerTile!.addGlow(radius: 30)
                }
                else if node == turnButton {
                    var replenishedIndices = playerRack!.replenish()
                    if replenishedIndices.count == 0 && gameBag!.tiles.count != 0 {
                        playerRackBox!.removeAllChildren()
                        replenishedIndices = playerRack!.replenishAllTiles()
                        displayBoard!.playerScore -= 5
                        updatePlayerScoreLabel()
                    }
                    displayBoard!.turnCompleted()
                    for index in replenishedIndices {
                        displayTileInPlayerRack(index: index)
                    }
                    computer?.play()
                    displayBoard!.turnCompleted()
                }
                else if node == restartGameButton {
                    removeAllChildren()
                    startGame()
                }
            }
        }
        
        if gameBag!.tiles.count == 0 {
            gameOver()
        }
    }
}
