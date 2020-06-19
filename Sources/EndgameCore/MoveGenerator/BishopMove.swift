//
//  BishopMove.swift
//  
//
//  Created by Jorge Elizondo on 1/20/20.
//

import Foundation

class BishopMove {
   var move: String
   var asciiBoard: ASCIIBoard
   var isWhiteMove = true
   var piece: Character { isWhiteMove ? "B" : "b" }
   
   init(move: String, isWhiteMove: Bool, board: ASCIIBoard) {
      self.move = move
      self.isWhiteMove = isWhiteMove
      self.asciiBoard = board
   }
   
   func execute() throws -> (piece: Character, from: Notation, to: Notation) {
      return try bishopDefault(move: move)
   }
   
   
   func bishopDefault(move: String) throws -> (Character,Notation,Notation) {
      let move = move.replacingOccurrences(of: "+", with: "")
      let newPos = Notation(rawValue: String(move.suffix(2)))!
      var oldPos: Notation?
      

      loop: for i in 1...7 {
         let corners = [newPos.offset(i, i),
                        newPos.offset(i, i * -1),
                        newPos.offset(i * -1, i),
                        newPos.offset(i * -1, i * -1)]
         
         for corner in corners where corner != nil {
            if asciiBoard.getChar(at: corner!) == piece {
               oldPos = corner
               break loop
            }
         }
      }
      
      guard oldPos != nil else {
         throw InterprterError(move: move)
      }
      
      return (piece,oldPos!,newPos)
   }
}

