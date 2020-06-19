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
                     .replacingOccurrences(of: "x", with: "")
      
      let isQueenColOrRowKnown = move.count > 3
      let newPos = Notation(rawValue: String(move.suffix(2)))!
      var oldPos: Notation
      
      if isQueenColOrRowKnown {
         oldPos = try searchForQueenInColOrRow()
      } else {
         oldPos = try searchForQueen(newPos: newPos)
      }
  
      return (piece,oldPos,newPos)
   }
   
   func searchForQueen(newPos: Notation) throws -> Notation {
      var paths = ["top":newPos,
                   "right":newPos,
                   "bottom":newPos,
                   "left":newPos,
                   "topRight":newPos,
                   "bottomRight":newPos,
                   "bottomLeft":newPos,
                   "topLeft":newPos]
      
      loop: for _ in 1...7 {
         paths["top"] = paths["top"]?.offset(0, 1)
         paths["right"] = paths["right"]?.offset(1, 0)
         paths["bottom"] = paths["bottom"]?.offset(0, -1)
         paths["left"] = paths["left"]?.offset(-1, 0)
         paths["topRight"] = paths["topRight"]?.offset(1, 1)
         paths["bottomRight"] = paths["bottomRight"]?.offset(1, -1)
         paths["bottomLeft"] = paths["bottomLeft"]?.offset(-1, -1)
         paths["topLeft"] = paths["topLeft"]?.offset(-1, 1)
         
         for path in paths {
            switch asciiBoard.getChar(at: path.value) {
               case self.piece: // Queen found
                  return path.value
               case "1": // Empty
                  break
               default: // Other piece found
                  paths.removeValue(forKey: path.key)
            }
         }
      }
      
      throw InterprterError(move: self.move)
   }
   
   func searchForQueenInColOrRow() throws -> Notation {
      let move = self.move.replacingOccurrences(of: "+", with: "")
                          .replacingOccurrences(of: "x", with: "")
                          .dropFirst()
      
      let aux: [Character] = Array(move)
      var oldPos: Notation?
      
      if aux[0].isLetter {
         oldPos = Notation(rawValue: "\(aux[0])\([aux[2]])")
      } else if aux[0].isNumber {
         oldPos = Notation(rawValue: "\(aux[1])\(aux[0])")
      }
      
      guard oldPos != nil else {
         throw InterprterError(move: self.move)
      }
      
      return oldPos!
      
   }
   
}
