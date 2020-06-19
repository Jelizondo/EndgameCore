//
//  RookMove.swift
//  
//
//  Created by Jorge Elizondo on 1/21/20.
//

import Foundation

class RookMove {
   var move: String
   var asciiBoard: ASCIIBoard
   var isWhiteMove = true
   var piece: Character { isWhiteMove ? "R" : "r" }
   let errorMessage = "Could not interpret rook move"
   
   init(move: String, isWhiteMove: Bool, board: ASCIIBoard) {
      self.move = move
      self.isWhiteMove = isWhiteMove
      self.asciiBoard = board
   }
   
   func execute() throws -> (piece: Character, from: Notation, to: Notation) {
      return try rookDefault(move: move)
   }
   
   func rookDefault(move: String) throws -> (Character,Notation,Notation) {
      let move = move.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "x", with: "")
      let newPos = Notation(rawValue: String(move.suffix(2)))!
      let isRookColOrRowKnown = move.count > 3
      var oldPos: Notation
      
      if isRookColOrRowKnown {
         oldPos = try searchInColOrRow(newPos: newPos)
         return (piece,oldPos,newPos)
      } else {
         oldPos = try searchInColAndRow(newPos: newPos)
         return (piece,oldPos,newPos)
      }
      
     
   }
   
   // MARK: - Cases
   
   func searchInColOrRow(newPos: Notation) throws -> Notation {
      let move = self.move.replacingOccurrences(of: "+", with: "")
                          .replacingOccurrences(of: "x", with: "")
                          .dropFirst()
      
      let aux: [Character] = Array(move)
      var foundAt: Notation?
      
      let searchInCol = aux[0] == aux[1]
      let searchInRow = aux[0] == aux[2]
      
      if searchInCol {
         foundAt = try self.searchInCol(newPos: newPos)
      } else if aux[0].isLetter {
         foundAt = Notation(rawValue: "\(aux[0])\(aux[2])")
      } else if searchInRow {
         foundAt = try self.searchInRow(newPos: newPos)
      } else if aux[0].isNumber {
         foundAt = Notation(rawValue: "\(aux[1])\(aux[0])")
      }
      
      guard let found = foundAt else {
         throw InterprterError(move: self.move)
      }
      
      return found
      
   }
   
   func searchInColAndRow(newPos: Notation) throws -> Notation {
      var paths = ["top":newPos,
                   "right":newPos,
                   "bottom":newPos,
                   "left":newPos]
      
      loop: for _ in 1...7 {
         paths["top"] = paths["top"]?.offset(0, 1)
         paths["right"] = paths["right"]?.offset(1, 0)
         paths["bottom"] = paths["bottom"]?.offset(0, -1)
         paths["left"] = paths["left"]?.offset(-1, 0)
         
         for path in paths {
            switch asciiBoard.getChar(at: path.value) {
               case self.piece: // Rook found
                  return  path.value
               case "1": // Empty
                  break
               default: // Other piece found
                  paths.removeValue(forKey: path.key)
            }
         }
      }
      
      throw InterprterError(move: move)
   }
   
   // MARK: - Helper functions
   
   func searchInRow(newPos: Notation) throws -> Notation {
      var paths = ["bottom":newPos,
                   "left":newPos]
      
      for _ in 1...7 {
         
         paths["right"] = paths["right"]?.offset(1, 0)
         paths["left"] = paths["left"]?.offset(-1, 0)
         
         for path in paths {
            switch asciiBoard.getChar(at: path.value) {
               case self.piece: // Rook found
                  return path.value
               case "1": // Empty
                  break
               default: // Other piece found
                  paths.removeValue(forKey: path.key)
            }
         }
      }
      
      throw InterprterError(move: move)
   }
   
   func searchInCol(newPos: Notation) throws -> Notation {
      var paths = ["top":newPos,
                   "bottom":newPos]
      
      for _ in 1...7 {
         
         paths["top"] = paths["top"]?.offset(0, 1)
         paths["bottom"] = paths["bottom"]?.offset(0, -1)
      
         for path in paths {
            switch asciiBoard.getChar(at: path.value) {
               case self.piece: // Rook found
                  return path.value
               case "1": // Empty
                  break
               default: // Other piece found
                  paths.removeValue(forKey: path.key)
            }
         }
      }
      
      throw InterprterError(move: move)
   }
   
}
