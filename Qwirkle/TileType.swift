//
//  Tile.swift
//  Qwirkle
//
//  Created by Sanya Arora on 1/21/25.
//

class TileType: CustomStringConvertible, Equatable {
    static func == (lhs: TileType, rhs: TileType) -> Bool {
        return lhs.color == rhs.color && lhs.shape == rhs.shape
    }
    
    enum ShapeType: String, CaseIterable {
        case square = "Square",
             circle = "Circle",
             diamond = "Diamond",
             star4 = "4Star",
             star8 = "8Star",
             clover = "Clover"
    }
    enum ColorType: String, CaseIterable {
        case red = "red",
             blue = "blue",
             yellow = "yellow",
             green = "green",
             purple = "purple",
             orange = "orange"
    }
    
    let shapeSizes = [
                    ShapeType.star4: (95, 95),
                    ShapeType.square: (35, 35),
                    ShapeType.diamond: (55, 55),
                    ShapeType.circle: (40, 40),
                    ShapeType.star8: (45, 45),
                    ShapeType.clover: (50, 50)
                ]
    
    var shape: ShapeType
    var color: ColorType
    var width: Int = 50
    var height: Int = 50
    var indexInRack: Int? = nil
    var positionOnGameBoard: DisplayBoardType.Coordinate? = nil
    
    init(requestedShape: ShapeType, requestedColor: ColorType) {
        shape = requestedShape
        color = requestedColor
        (width, height) = (shapeSizes[requestedShape])!
    }
    
    var description: String {
        return "\(shape), \(color)"
    }
}
