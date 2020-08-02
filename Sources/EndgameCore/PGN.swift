//
//  PGN.swift
//  
//
//  Created by Jorge Elizondo on 1/14/20.
//

import Foundation

public struct PGN {
   
   public let event: String?
   public let site: String?
   public let date: String?
   public let round: String?
   public let whitePlayer: String
   public let blackPlayer: String
   public let whiteElo: String?
   public let blackElo: String?
   public let result: String?
   public let moves: [String]
   public let rawValue: String
   
   public init(pgn: String) {
      var keyValuePairs = [String:String]()
      
      // Parse metadata
      let pgn = pgn.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n\n", with: "\n")
      
      
      let components = pgn.split(separator: "\n")
      let metadata = components.filter { $0.contains("[") }
      
      for data in metadata {
         let components = data.components(separatedBy: " \"")
         let key = String(components[0].dropFirst())
         let value = String(components[1].dropLast(2))
         keyValuePairs[key] = value
      }
      
      // Parse moves
      
      var aux = [String]()
      let moves = pgn.components(separatedBy: "\n1.")
                     .last!
                     .replacingOccurrences(of: "\n", with: " ")
                     .split(separator: " ")
                     .dropLast()
      
      for move in moves {
         let move = move.replacingOccurrences(of: "[0-9]*[.]",
                                              with: "",
                                              options: .regularExpression)
         
         guard !move.isEmpty else { continue }
         
         aux.append(String(move))
      }
      
      // Initialize properties
      rawValue = pgn
      self.moves = aux
      event = keyValuePairs["Event"]
      site = keyValuePairs["Site"]
      date = keyValuePairs["Date"]
      round = keyValuePairs["Round"]
      whitePlayer = keyValuePairs["White"]!
      blackPlayer = keyValuePairs["Black"]!
      result = keyValuePairs["Result"]
      
      if let elo = keyValuePairs["WhiteElo"] {
         if elo.isEmpty {
            whiteElo = nil
         } else {
            whiteElo = elo
         }
      } else {
         whiteElo = nil
      }
      
      if let elo = keyValuePairs["BlackElo"] {
         if elo.isEmpty {
            blackElo = nil
         } else {
            blackElo = elo
         }
      } else {
         blackElo = nil
      }
      
   }
   
}

extension PGN: CustomStringConvertible {
   public var description: String {
      return rawValue
   }
}
