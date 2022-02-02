//
//  PieceNode.swift
//  WOR - Witch On Rescue
//
//  Created by Daniella Onishi on 02/02/22.
//

import Foundation
import SpriteKit

class PieceNode {
    internal init(piece: Piece, container: SKNode, startingZPosition: Int) {
        self.piece = piece
        self.container = container
        self.startingZPosition = startingZPosition
        
        render()
    }
    
    var piece: Piece
    let container: SKNode // Stores all the smaller nodes
    let startingZPosition: Int // Minimum zIndex this piece uses
    
    let matrixSize = 4 // Static, might need to be changed if pieces change size
    let blockSize: (width: CGFloat, height: CGFloat) = (width: 100, height: 140) // The width and height of an individual block
    
    func render() { // Builds SKSpriteNodes from the `piece`
        
        func calculateOffset(i: Int, j: Int) -> (CGFloat, CGFloat) {
            let defaultHeightOffset = CGFloat(blockSize.height) * 1.5 // 1.5 is a full block plus half a block
            let offsetHeightChange = CGFloat(i) * -blockSize.height
            let finalHeightOffset = defaultHeightOffset + offsetHeightChange
            
            let defaultWidthOffset = -CGFloat(blockSize.width) * 1.5 // 1.5 is a full block plus half a block
            let offsetWidthChange = CGFloat(j) * blockSize.width
            let finalWidthOffset = defaultWidthOffset + offsetWidthChange
            
            return (finalWidthOffset, finalHeightOffset)
        }
        
        print("[render] Generating piece: \(piece)")
        
        for (i, blockRow) in piece.pieceMatrix.enumerated() { // Checking each row of the piece (which is a matrix)
            for (j, block)  in blockRow.enumerated() {
                switch block {
                case .empty: continue
                case .block, .target:
                    
                    print("[render] Generating for i: \(i), j: \(j)")
                    
                    let node = createBlockNode(type: block)
                    
                    let offset = calculateOffset(i: i, j: j)
                    
                    print("[render] offset: \(offset)")
                    
                    node.position = CGPoint(x: offset.0, y: offset.1)
                    
                    container.addChild(node)
                    
                    node.zPosition = CGFloat(startingZPosition - ((matrixSize - 1) - i)) // We basically need to assign the smallest zposition to the most close to the bottom rows
                }
            }
        }
        
    }
    
    func rotate() { // Rotates the piece node (and the underlying piece)
        print("[rotate] Removing all children")
        container.removeAllChildren()
        
        print("[rotate] Rotating piece...")
        piece = piece.rotated()
        
        print("[rotate] Rotated piece!")
        
        print("[rotate] Rerendering...")
        render()
    }
    
    private func createBlockNode(type: PieceState) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "block")
        node.name = "rotatable_piece"
        node.size = CGSize(width: blockSize.width, height: blockSize.height)
        return node
    }
}
