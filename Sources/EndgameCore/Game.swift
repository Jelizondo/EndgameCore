//
//  Game.swift
//  
//
//  Created by Jorge Elizondo on 1/14/20.
//

import Foundation

public struct Game: Identifiable {
   public let id = UUID()
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
   public let pgn: String
   public var asciiPositions: [ASCIIBoard] = [ASCIIBoard()]
   
   public init?(pgn: PGN) {
      event = pgn.event
      site = pgn.site
      date = pgn.date
      round = pgn.round
      whitePlayer = pgn.whitePlayer
      blackPlayer = pgn.blackPlayer
      whiteElo = pgn.whiteElo
      blackElo = pgn.blackElo
      result = pgn.result
      moves = pgn.moves
      self.pgn = pgn.rawValue
      
      let moveGen = MoveGenerator(asciiBoard: ASCIIBoard())
      for move in moves {
         do {
            let asciiBoard = try moveGen.execute(move: move)
            asciiPositions.append(asciiBoard)
         } catch {
            return nil
         }
      }
   }
}
