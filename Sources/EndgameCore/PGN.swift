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
         let components = data.split(separator: "\"")
         let key = String(components[0].dropFirst().dropLast())
         let value = String(components[1])
         keyValuePairs[key] = value
      }
      
      // Parse moves
      var aux = [String]()
      let moves = pgn.components(separatedBy: "\n1.").last!.replacingOccurrences(of: "\n", with: " ").split(separator: " ").dropLast()
      for move in moves {
         guard !move.contains(".") else {
            continue
         }
         
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
      whiteElo = keyValuePairs["WhiteElo"]
      blackElo = keyValuePairs["BlackElo"]
      result = keyValuePairs["Result"]
   }
   
}

extension PGN: CustomStringConvertible {
   public var description: String {
      return rawValue
   }
}
