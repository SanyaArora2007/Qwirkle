//
//  DisplayTileType.swift
//  Qwirkle
//
//  Created by Sanya Arora on 2/16/25.
//
import SpriteKit

class DisplayTileType: SKShapeNode {
    var tile: TileType? = nil
    var glow: SKEffectNode? = nil
    
    convenience init(inputTile: TileType, location: CGPoint) {
        self.init(rectOf: CGSize(width: 59, height: 59))
        self.tile = inputTile
        
        self.position = location
        self.fillColor = .black
        self.strokeColor = .lightGray
        self.lineWidth = 2

        let imageName = "\(tile!.color.rawValue)\(tile!.shape.rawValue)"
        let tileShown = SKSpriteNode(imageNamed: imageName)
        tileShown.size = CGSize(width: tile!.width, height: tile!.height)
        self.addChild(tileShown)
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGlow() {
        self.lineWidth = 5
        self.strokeColor = .white
    }
    
    func removeGlow() {
        self.lineWidth = 2
        self.strokeColor = .lightGray
    }
}
