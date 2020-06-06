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
   
   func execute() throws -> (piece: Character, from: Notation, to: Notation) {
      let move = self.move.replacingOccurrences(of: "+", with: "")
      let isCapture = move.contains("x")
      let isPromotion = move.contains("=")

      switch move {
         case _ where isPromotion:
            return try pawnPromotion(move: move)
         case _ where isCapture:
            return try pawnCapture(move: move)
         default:
            return try pawnDefault(move: move)
            
      }
      
   }
   
   func pawnPromotion(move: String) throws -> (Character ,Notation, Notation) {
      let components = move.split(separator: "=")
      let move = String(components.first!)
      let promotedPiece = isWhiteMove ? Character(String(components.last!)) : Character(String(components.last!).capitalized)
      let pieceMovement: (Character,Notation,Notation)
      
      if self.move.contains("x") {
         pieceMovement = try pawnCapture(move: move)
      } else {
         pieceMovement = try pawnDefault(move: move)
      }
      
      return (promotedPiece,pieceMovement.1,pieceMovement.2)
      
   }
   
   func pawnCapture(move: String) throws -> (Character,Notation,Notation) {
      let components = move.split(separator: "x")
      let newPos = String(components[1])
      let oldPos = String(components[0]) + String(newPos.last!.wholeNumberValue!+directiton)
      
      guard Notation(rawValue: oldPos) != nil else {
         throw InterprterError(description: "Could not interpret rook move")
      }
      
      return (piece,Notation(rawValue: oldPos)!,Notation(rawValue: newPos)!)
   }
   
   func pawnDefault(move: String) throws -> (Character,Notation,Notation) {
      let move = move.replacingOccurrences(of: "+", with: "")
      let oldPos: Notation

      guard let newPos = Notation(rawValue: move) else {
         throw InterprterError(description: "Could not interpret pawn move")
      }
      
      guard let behindPawn = newPos.offset(0,directiton) else {
         throw InterprterError(description: "Could not interpret pawn move")
      }
      
      if asciiBoard.getChar(at: behindPawn ) == "1" {
         oldPos = behindPawn.offset(0,directiton)!
      } else {
         oldPos = behindPawn
      }
      
      return (piece,oldPos,newPos)
   }
   
}
