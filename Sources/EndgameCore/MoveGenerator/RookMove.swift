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
      var oldPos: Notation?
      
      // Two possibilities of Rook moves
      if move.count > 3 {
         
         let aux: [Character] = Array(move.dropFirst())
         
         guard let component = aux.first else {
            throw InterprterError(description: errorMessage)
         }
         
         let searchInCol = aux[1] == component
         let searchInRow = aux[2] == component
         
         if searchInCol {
            oldPos = try self.searchInCol(newPos: newPos)
         } else if component.isLetter {
            oldPos = Notation(rawValue: "\(component)\(move.last!)")
         } else if searchInRow {
            oldPos = try self.searchInRow(newPos: newPos)
         } else if component.isLetter {
            oldPos = Notation(rawValue: "\(Array(move)[move.count-2])\(component)")
         }
         
         if let oldPos = oldPos {
            return (piece,oldPos,newPos)
         }
      }
      
      // Find rook in paths
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
                  oldPos = path.value
                  break loop
               case "1": // Empty
                  break
               default: // Other piece found
                  paths.removeValue(forKey: path.key)
            }
         }
      }
      
      guard oldPos != nil else {
         throw InterprterError(description: "Could not interpret rook move")
      }
            
      return (piece,oldPos!,newPos)
   }
   
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
      
      throw InterprterError(description: "Could not interpret rook move")
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
      
      throw InterprterError(description: "Could not interpret rook move")
   }
   
}
