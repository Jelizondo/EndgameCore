//
//  File.swift
//  
//
//  Created by Jorge Elizondo on 1/24/20.
//

import Foundation

class KingMove {
   var move: String
   var asciiBoard: ASCIIBoard
   var isWhiteMove = true
   var piece: Character { isWhiteMove ? "K" : "k" }
   
   init(move: String, isWhiteMove: Bool, board: ASCIIBoard) {
      self.move = move
      self.isWhiteMove = isWhiteMove
      self.asciiBoard = board
   }
   
   func execute() throws -> (piece: Character, from: Notation, to: Notation) {
      let move = self.move.replacingOccurrences(of: "+", with: "")
      let newPos = Notation(rawValue: String(move.suffix(2)))!
   
      let squares = [newPos.offset(1, 1),
                     newPos.offset(1,-1),
                     newPos.offset(-1, 1),
                     newPos.offset(-1,-1),
                     newPos.offset(0, 1),
                     newPos.offset(1, 0),
                     newPos.offset(0, -1),
                     newPos.offset(-1, 0)]
      
      for square in squares where square != nil {
         if asciiBoard.getChar(at: square!) == piece {
            return (piece: piece, from: square!, to: newPos)
         }
      }
      
      throw InterprterError(move: move)

   }
      
}
