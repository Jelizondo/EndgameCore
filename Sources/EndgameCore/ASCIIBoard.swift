//
//  ASCIIBoard.swift
//  
//
//  Created by Jorge Elizondo on 1/14/20.
//

import Foundation

public struct ASCIIBoard {
   
   public private(set) var rawValue: [[Character]] = Array(repeating: Array(repeating: Character(" "), count: 8), count: 8)
   
   public init(fen: FEN = FEN() ) {
      rawValue = generateBoard(fen: fen)
   }
   
   private func generateBoard(fen: FEN) -> [[Character]] {
      var board: [[Character]] = Array(repeating: Array(repeating: Character("1"), count: 8), count: 8)
      var characters: [Character] = Array(fen.piecePlacement.replacingOccurrences(of: "/", with: ""))
      
      var count = 0
      var row = 0
      var col = 0
      
      while row < 8 {
         while col < 8 {
            let character = characters[count]
            if character.isLetter {
               board[row][col] = character
               count += 1
            } else if character.isNumber {
               if character == "1" {
                  board[row][col] = character
                  count += 1
               } else {
                  characters[count] = Character(Unicode.Scalar(character.asciiValue! - 1))
                  board[row][col] = "1"
               }
            }
            col += 1
         }
         col = 0
         row += 1
      }
      
      return board
   }
   
   
   func getChar(at notation: Notation) -> Character {
      let components = Array(notation.rawValue)
      let col = Int(components[0].asciiValue! - 97)
      let row = (components[1].wholeNumberValue! - 8) * -1
     
      return rawValue[row][col]
   }
   
   mutating func setChar(_ character: Character, at notation: Notation) {
      let components = Array(notation.rawValue)
      let col = Int(components[0].asciiValue! - 97)
      let row = (components[1].wholeNumberValue! - 8) * -1
      
      rawValue[row][col] = character
   }
   

}
