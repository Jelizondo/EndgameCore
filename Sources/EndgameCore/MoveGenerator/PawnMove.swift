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
   
   func execute() throws -> ASCIIBoard {
      let move = self.move.replacingOccurrences(of: "+", with: "")
      let isCapture = move.contains("x")
      let isPromotion = move.contains("=")
      
      
      var movement: Movement?
      switch move {
         case _ where isPromotion:
            try pawnPromotion(move: move)
         case _ where isCapture:
            movement = try pawnCapture(move: move)
         default:
            movement = try pawnDefault(move: move)
      }
      
      if let movement = movement {
         self.move(from: movement.from, to: movement.to)
      }
      
      return asciiBoard
   }
   
   func pawnPromotion(move: String) throws {
      let components = move.split(separator: "=")
      let move = String(components.first!)
      let promotedPiece = isWhiteMove ? Character(String(components.last!)) : Character(String(components.last!).capitalized)
      let pieceMovement: Movement
      
      if self.move.contains("x") {
         pieceMovement = try pawnCapture(move: move)
      } else {
         pieceMovement = try pawnDefault(move: move)
      }
      
      asciiBoard.setChar(promotedPiece, at: pieceMovement.to)
      asciiBoard.setChar("1", at: pieceMovement.from)
            
   }
   
   func pawnCapture(move: String) throws -> (Notation,Notation) {
      let components = move.split(separator: "x")
      let newPos = Notation(rawValue: String(components[1]) )
      let oldPos = Notation(rawValue: String(components[0]) + String(String(components[1]).last!.wholeNumberValue!+directiton) )
      
      guard oldPos != nil else {
         throw InterprterError(description: "Could not interpret rook move")
      }
     
      if asciiBoard.getChar(at: newPos!) == "1" {
         if isWhiteMove {
            asciiBoard.setChar("1", at: newPos!.offset(0,-1)!)
         } else {
            asciiBoard.setChar("1", at: newPos!.offset(0,1)!)
         }
      }
      
      return (oldPos!,newPos!)
   }
   
   func pawnDefault(move: String) throws -> (Notation,Notation) {
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
      
      return (oldPos,newPos)
   }
   
   func move(from oldPos: Notation, to newPos: Notation) {
      asciiBoard.setChar(piece, at: newPos)
      asciiBoard.setChar("1", at: oldPos)
   }
   
}
