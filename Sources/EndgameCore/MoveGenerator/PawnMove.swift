//
//  PawnMove.swift
//  
//
//  Created by Jorge Elizondo on 1/18/20.
//

import Foundation

class PawnMove {
   var move: String
   var asciiBoard: ASCIIBoard
   var isWhiteMove = true
   var directiton: Int { isWhiteMove ? -1 : 1 }
   var piece: Character { isWhiteMove ? "P" : "p" }
   
   init(move: String, isWhiteMove: Bool, board: ASCIIBoard) {
      self.move = move
      self.isWhiteMove = isWhiteMove
      self.asciiBoard = board
   }
   
   func execute() -> (piece: Character, from: Notation, to: Notation) {
      let isCapture = move.contains("x")
      let isPromotion = move.contains("=")

      switch move {
         case _ where isPromotion:
            return pawnPromotion(move: move)
         case _ where isCapture:
            return pawnCapture(move: move)
         default:
            return pawnDefault(move: move)
            
      }
      
   }
   
   func pawnPromotion(move: String) -> (Character ,Notation, Notation) {
      let components = move.split(separator: "=")
      let move = String(components.first!)
      let promotedPiece = isWhiteMove ? Character(String(components.last!)) : Character(String(components.last!).capitalized)
      let pieceMovement: (Character,Notation,Notation)
      
      if self.move.contains("x") {
         pieceMovement = pawnCapture(move: move)
      } else {
         pieceMovement = pawnDefault(move: move)
      }
      
      return (promotedPiece,pieceMovement.1,pieceMovement.2)
      
   }
   
   func pawnCapture(move: String) -> (Character,Notation,Notation) {
      let components = move.split(separator: "x")
      let newPos = String(components[1])
      let oldPos = String(components[0]) + String(newPos.last!.wholeNumberValue!+directiton)
      
      return (piece,Notation(rawValue: oldPos)!,Notation(rawValue: newPos)!)
   }
   
   func pawnDefault(move: String) -> (Character,Notation,Notation) {
      let move = move.replacingOccurrences(of: "+", with: "")
      let newPos = Notation(rawValue: move)!
      let oldPos: Notation
      let behindPawn = newPos.offset(0,directiton)!
      if asciiBoard.getChar(at: behindPawn ) == "1" {
         oldPos = behindPawn.offset(0,directiton)!
      } else {
         oldPos = behindPawn
      }
      
      return (piece,oldPos,newPos)
   }
   
}
