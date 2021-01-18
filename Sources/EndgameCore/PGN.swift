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
   public let eco: String?
   public let moves: [String]
   public let rawValue: String
   
}

extension PGN: CustomStringConvertible {
   public var description: String {
      return rawValue
   }
}
