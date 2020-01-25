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
   
   func execute() -> (piece: Character, from: Notation, to: Notation) {
      return knightDefault(move: move)
   }

   
   func knightDefault(move: String) -> (Character,Notation,Notation) {
      let move = move.replacingOccurrences(of: "+", with: "")
      let newPos = Notation(rawValue: String(move.suffix(2)))!
      var oldPos: Notation?
      
      
      //Two possibilities of kight moves, if this is empty then there is only one possibility
      let aux: [Character] = move.replacingOccurrences(of: "x", with: "").dropFirst().dropLast(2)
      
      // Column or Row where the piece is located
      if let component = aux.first {
         // Column
         if component.isLetter {
            let left = Int(newPos.rawValue.first!.asciiValue!)
            let right = Int(component.asciiValue!)
            
            let side = right - left
            let a = abs(side) == 1 ? 2 : 1
            
            if let pos = newPos.offset(side, a), asciiBoard.getChar(at: pos) == piece {
               oldPos = newPos.offset(side, a)
            } else if let pos = newPos.offset(side, a * -1), asciiBoard.getChar(at: pos) == piece {
               oldPos = newPos.offset(side, a * -1)
            }
            
         }
         
         // Row
         if component.isNumber {
            let left = newPos.rawValue.last!.wholeNumberValue!
            let right = component.wholeNumberValue!
            let side = left - right
            
            if let pos = newPos.offset(side, 2), asciiBoard.getChar(at: pos) == piece {
               oldPos = newPos.offset(side, 2)
            } else if let pos = newPos.offset(side, -2), asciiBoard.getChar(at: pos) == piece {
               oldPos = newPos.offset(side, -2)
            }
         }
          return (piece,oldPos!,newPos)
      }
      
      //One possibility
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
            oldPos = square
            break
         }
      }
      
      guard oldPos != nil else {
         fatalError("Unable to parse knight move \(move)")
      }
      
      return (piece,oldPos!,newPos)
   }
   

   
}



