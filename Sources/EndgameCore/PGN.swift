//
//  PGN.swift
//  
//
//  Created by Jorge Elizondo on 1/14/20.
//

import Foundation

public struct PGN {
   
   let event: String?
   let site: String?
   let date: String?
   let round: String?
   let whitePlayer: String?
   let blackPlayer: String?
   let result: String?
   let moves: [String]
   let rawValue: String
   
   public init(pgn: String) {
      var keyValuePairs = [String:String]()
      
      // Parse metadata
      let components = pgn.split(separator: "\n")
      let metadata = components.dropLast(components.count-9)
      for data in metadata {
         let components = data.split(separator: "\"")
         let key = String(components[0].dropFirst().dropLast())
         let value = String(components[1])
         keyValuePairs[key] = value
      }
      
      // Parse moves
      var aux = [String]()
      let moves = pgn.components(separatedBy: "\n\n").last!.replacingOccurrences(of: "\n", with: " ").split(separator: " ")
      for move in moves {
         aux.append(String(move.split(separator: ".").last!))
      }
      
      // Initialize properties
      rawValue = pgn
      self.moves = aux
      event = keyValuePairs["Event"]
      site = keyValuePairs["Site"]
      date = keyValuePairs["Date"]
      round = keyValuePairs["Round"]
      whitePlayer = keyValuePairs["White"]
      blackPlayer = keyValuePairs["Black"]
      result = keyValuePairs["Result"]
   }
   
}

extension PGN: CustomStringConvertible {
   public var description: String {
      return rawValue
   }
}
