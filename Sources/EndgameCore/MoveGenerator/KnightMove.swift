//
//  KnightMove.swift
//  
//
//  Created by Jorge Elizondo on 1/19/20.
//

import Foundation


class KightMove {
   var move: String
   var asciiBoard: ASCIIBoard
   var isWhiteMove = true
   var piece: Character { isWhiteMove ? "N" : "n" }
   
   init(move: String, isWhiteMove: Bool, board: ASCIIBoard) {
      self.move = move
      self.isWhiteMove = isWhiteMove
      self.asciiBoard = board
   }
   
   func execute() throws -> (piece: Character, from: Notation, to: Notation) {
      return try knightDefault(move: move)
   }
   
   
   func knightDefault(move: String) throws -> (Character,Notation,Notation) {
      let move = move.replacingOccurrences(of: "x", with: "")
                     .replacingOccurrences(of: "+", with: "")

      let newPos = Notation(rawValue: String(move.suffix(2)))!
      var oldPos: Notation
      
      if move.count > 3 {
         oldPos = try searchForKnightInColOrRow(newPos: newPos)
      } else {
         oldPos = try searchForKnight(newPos: newPos)
      }
      
      return (piece,oldPos,newPos)
   }
   
   func searchForKnight(newPos: Notation) throws -> Notation {
      let squares = [newPos.offset(1,2),
                     newPos.offset(1,-2),
                     newPos.offset(-1,-2),
                     newPos.offset(-1,2),
                     newPos.offset(2,1),
                     newPos.offset(2,-1),
                     newPos.offset(-2,1),
                     newPos.offset(-2,-1)]
      
      for square in squares where square != nil {
         if asciiBoard.getChar(at: square!) == piece {
            return square!
         }
      }
      
      throw InterprterError(move: self.move)
   }
   
   func searchForKnightInColOrRow(newPos: Notation) throws -> Notation {
      let aux: [Character] = move.replacingOccurrences(of: "x", with: "")
                                 .replacingOccurrences(of: "+", with: "")
                                 .dropFirst()
                                 .dropLast(2)
      
      // Column
      if aux[0].isLetter {
         return try searchKnightInCol(from: newPos, aux: aux)
      }
      
      // Row
      if aux[0].isNumber {
         return try searchKnightInRow(from: newPos, aux: aux)
      }
      
      throw InterprterError(move: move)
   }
   
   func searchKnightInCol(from notation: Notation, aux: [Character]) throws -> Notation {
      let left = Int(notation.rawValue.first!.asciiValue!)
      let right = Int(aux[0].asciiValue!)
      
      let side = right - left
      let a = abs(side) == 1 ? 2 : 1
      
      if let pos = notation.offset(side, a), asciiBoard.getChar(at: pos) == piece {
         return pos
      } else if let pos = notation.offset(side, a * -1), asciiBoard.getChar(at: pos) == piece {
         return pos
      }
      
      throw InterprterError(move: self.move)
   }
   
   func searchKnightInRow(from notation: Notation, aux: [Character]) throws -> Notation {
      let right = notation.rawValue.last!.wholeNumberValue!
      let left = aux[0].wholeNumberValue!
      
      let y = left - right
      let x = abs(y) == 1 ? 2 : 1

      if let pos = notation.offset(x,y), asciiBoard.getChar(at: pos) == piece {
         return pos
      } else if let pos = notation.offset(x * -1,y), asciiBoard.getChar(at: pos) == piece {
         return pos
      }
      
      throw InterprterError(move: self.move)
   }
   
}
