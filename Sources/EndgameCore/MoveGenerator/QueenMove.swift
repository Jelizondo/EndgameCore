//
//  File.swift
//  
//
//  Created by Jorge Elizondo on 1/21/20.
//

import Foundation

class QueenMove {
   var move: String
   var asciiBoard: ASCIIBoard
   var isWhiteMove = true
   var piece: Character { isWhiteMove ? "Q" : "q" }
   
   init(move: String, isWhiteMove: Bool, board: ASCIIBoard) {
      self.move = move
      self.isWhiteMove = isWhiteMove
      self.asciiBoard = board
   }
   
   func execute() throws -> (piece: Character, from: Notation, to: Notation) {
      return try queenDefault(move: move)
   }
   
   
   func queenDefault(move: String) throws -> (Character,Notation,Notation) {
      let move = move.replacingOccurrences(of: "+", with: "")
      let newPos = Notation(rawValue: String(move.suffix(2)))!
      var oldPos: Notation?
      
      //Two possibilities of Queen moves
      let aux: [Character] = move.replacingOccurrences(of: "x", with: "").dropFirst().dropLast(2)
      if let component = aux.first {
         if component.isLetter {
            oldPos = Notation(rawValue: "\(component)\(move.last!)")
         } else {
            oldPos = Notation(rawValue: "\(Array(move)[move.count-2])\(component)")
         }
         return (piece,oldPos!,newPos)
      }
      
      
      loop: for i in 1...7 {
         let squares = [newPos.offset(i, i),
                        newPos.offset(i, i * -1),
                        newPos.offset(i * -1, i),
                        newPos.offset(i * -1, i * -1),
                        newPos.offset(0, i),
                        newPos.offset(i, 0),
                        newPos.offset(0, i * -1),
                        newPos.offset(i * -1, 0)]
         
         for square in squares where square != nil {
            if asciiBoard.getChar(at: square!) == piece {
               oldPos = square
               break loop
            }
         }
      }
      
      guard oldPos != nil else {
         throw InterprterError(description: "Could not interpret queen move")
      }
      
      return (piece,oldPos!,newPos)
   }
   
}
