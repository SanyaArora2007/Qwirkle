//
//  GameScene.swift
//  Qwirkle
//
//  Created by Sanya Arora on 1/14/25.
//

import SpriteKit

class GameScene: SKScene {
    
    var turnButton: SKLabelNode!
    
    let colors = [UIColor.red, UIColor.blue, UIColor.purple, UIColor.yellow, UIColor.orange, UIColor.green]
    var displayBoard: DisplayBoardType = .init()
    
    var gameBag: Bag = .init()
    var computerRack: TileRackType = .init()
    var playerRack: TileRackType = .init()
    var selectedPlayerTile: DisplayTileType? = nil
    
    let playerRackBox = SKShapeNode(rectOf: CGSize(width: 750, height: 135))
    
    override func didMove(to view: SKView) {
        
        self.computerRack = TileRackType(bag: self.gameBag)
        self.playerRack = TileRackType(bag: self.gameBag)
        
        playerRackBox.position = CGPoint(x: 0, y: -480)
        playerRackBox.fillColor = .lightGray
        addChild(playerRackBox)
        
        displayPlayerRack()
        
        displayTurnButton()
    }
    
    func displayTile(tile: TileType, center: CGPoint, parent: SKNode) {
        let newTile = DisplayTileType(inputTile: tile, location: center)
        parent.addChild(newTile)
    }
    
    func displayPlayerRack() {
        for i in 0...playerRack.MAX_NUMBER_OF_TILES - 1 {
            displayTileInPlayerRack(index: i)
        }
    }
    
    func displayTileInPlayerRack(index: Int) {
        let tile = playerRack.tiles[index]
        
        if tile != nil {
            let x = displayBoard.MINX + 160 + displayBoard.TILESIZE * Double(index)
            displayTile(tile: tile!, center: CGPoint(x: CGFloat(x), y: 20), parent: playerRackBox)
        }
    }
    
    func displayTurnButton() {
        turnButton = SKLabelNode(fontNamed: "Chalkduster")
        turnButton.text = "Done"
        turnButton.position = CGPoint(x: 275, y: -470)
        turnButton.fontSize = 25
        addChild(turnButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let clickLocation = touch.location(in: self)
        
        let nodes = self.nodes(at: clickLocation)
        if nodes.count == 0 {
            // do this when player clicks on game board
            let tileLocation = displayBoard.determinPositionToSnap(clickLocation: clickLocation)
            let (row, column) = displayBoard.determineRowAndColumn(clickLocation: clickLocation)
            if selectedPlayerTile != nil {
                let pickedTile = selectedPlayerTile!.tile
                let wasTilePlaced = displayBoard.placeTile(tile: pickedTile!, row: row, column: column)
                if wasTilePlaced {
                    displayTile(tile: pickedTile!, center: tileLocation, parent: self)
                    playerRackBox.removeChildren(in: [selectedPlayerTile!])
                    playerRack.remove(index: pickedTile!.indexInRack!)
                    selectedPlayerTile = nil
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
                    let replenishedIndices = playerRack.replenish()
                    for index in replenishedIndices {
                        displayTileInPlayerRack(index: index)
                    }
                }
            }
        }
    }
}
