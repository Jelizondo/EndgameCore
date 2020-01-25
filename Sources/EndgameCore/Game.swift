//
//  Game.swift
//  
//
//  Created by Jorge Elizondo on 1/14/20.
//

import Foundation

public class Game {
   
   let moves: [String]
   public let asciiPositions: [ASCIIBoard]
   let pgn: String
   
   public init(pgn: PGN) {
      moves = pgn.moves
      self.pgn = pgn.rawValue
      
      let moveGen = MoveGenerator(asciiBoard: ASCIIBoard())
      asciiPositions = moves.map { move in
         return moveGen.execute(move: move)
      }
   }
}
