//
//  File.swift
//  
//
//  Created by Jorge Elizondo on 1/17/20.
//

import Foundation

public struct InterprterError: Error {
   let description: String
}

public typealias Movement = (from: Notation, to: Notation)

public class MoveGenerator {
   var asciiBoard: ASCIIBoard
   var isWhiteMove = true
   var asciiPawn: Character { isWhiteMove ? "P" : "p" }
       
   public init(asciiBoard: ASCIIBoard) {
      self.asciiBoard = asciiBoard
   }
   
   public func execute(move: String) throws -> (ASCIIBoard, Movement, Movement?) {
      
      var castleMovement: (Movement,Movement)?
      var pieceMovement: (piece: Character, from: Notation, to: Notation)?
      switch move.first {
         case "a","b","c","d","e","f","g","h":
            pieceMovement = try PawnMove(move: move, isWhiteMove: isWhiteMove, board: asciiBoard).execute()
         case "N":
            pieceMovement = try KightMove(move: move, isWhiteMove: isWhiteMove, board: asciiBoard).execute()
         case "B":
            pieceMovement = try BishopMove(move: move, isWhiteMove: isWhiteMove, board: asciiBoard).execute()
         case "Q":
            pieceMovement = try QueenMove(move: move, isWhiteMove: isWhiteMove, board: asciiBoard).execute()
         case "R":
            pieceMovement = try RookMove(move: move, isWhiteMove: isWhiteMove, board: asciiBoard).execute()
         case "K":
            pieceMovement = try KingMove(move: move, isWhiteMove: isWhiteMove, board: asciiBoard).execute()
         default:
            switch move {
               case "O-O" where isWhiteMove:
                  castleMovement = shortCastleWhite()
               case "O-O":
                  castleMovement = shortCastleBlack()
               case "O-O-O" where isWhiteMove:
                  castleMovement = longCastleWhite()
               case "O-O-O":
                  castleMovement = longCastleBlack()
               default:
                  throw InterprterError(description: "Unable to parse move -> \(move)")
         }
      }
      
      if let movement = pieceMovement {
         self.move(piece: movement.piece, from: movement.from, to: movement.to)
         isWhiteMove.toggle()
         return (asciiBoard,(from: movement.from, to: movement.to), nil)
      }
      
      if let movement = castleMovement {
         isWhiteMove.toggle()
         return (asciiBoard, movement.0,movement.1)
      }
      
      fatalError("Unable to parse move")
}
   
   func move(piece: Character, from oldPos: Notation, to newPos: Notation) {
      asciiBoard.setChar(piece, at: newPos)
      asciiBoard.setChar("1", at: oldPos)
   }
   
   func shortCastleWhite() -> (Movement,Movement) {
      asciiBoard.setChar("R", at: .f1)
      asciiBoard.setChar("K", at: .g1)
      asciiBoard.setChar("1", at: .h1)
      asciiBoard.setChar("1", at: .e1)
      return ((.h1,.f1),(.e1,.g1))
   }
   
   func shortCastleBlack() -> (Movement,Movement) {
      asciiBoard.setChar("r", at: .f8)
      asciiBoard.setChar("k", at: .g8)
      asciiBoard.setChar("1", at: .h8)
      asciiBoard.setChar("1", at: .e8)
      return ((.h8,.f8),(.e8,.g8))
   }
   
   func longCastleWhite() -> (Movement,Movement)  {
      asciiBoard.setChar("1", at: .e1)
      asciiBoard.setChar("R", at: .d1)
      asciiBoard.setChar("K", at: .c1)
      asciiBoard.setChar("1", at: .b1)
      asciiBoard.setChar("1", at: .a1)
      return ((.a1,.d1),(.e1,.c1))
   }
   
   func longCastleBlack() -> (Movement,Movement) {
      asciiBoard.setChar("1", at: .e8)
      asciiBoard.setChar("r", at: .d8)
      asciiBoard.setChar("k", at: .c8)
      asciiBoard.setChar("1", at: .b8)
      asciiBoard.setChar("1", at: .a8)
      return ((.a8,.d8),(.e8,.g8))
   }
   
}
