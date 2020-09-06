//
//  File.swift
//  
//
//  Created by Jorge Elizondo on 5/17/20.
//

import Foundation

public struct PGNDecoder {
   
   public init() {}
   
   public func decode(fileName: String, bundle: Bundle) -> [PGN] {
      guard let path = bundle.path(forResource: fileName, ofType: "pgn") else {
         fatalError("File not found!")
      }
      
      guard let string = try? String(contentsOfFile: path,
                                     encoding: String.Encoding.utf8) else {
         fatalError("Could not read file")
      }
      
      let rawPGNs = string.components(separatedBy:  "[Event ")
         .dropFirst()
         .map { "[Event " + $0 }
      
      var pgns: [PGN] = []
      for rawPGN in rawPGNs {
         let pgn = decode(rawValue: rawPGN)
         pgns.append(pgn)
      }
      
      return pgns
   }
   
   public func decode(rawValue: String) -> PGN {
      var keyValuePairs = [String:String]()
      
      // Parse metadata
      let rawPGN = rawValue.replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\n\n", with: "\n")
      
      
      let components = rawPGN.split(separator: "\n")
      let metadata = components.filter { $0.contains("[") }
      
      for data in metadata {
         let components = data.components(separatedBy: " \"")
         let key = String(components[0].dropFirst())
         let value = String(components[1].dropLast(2))
         keyValuePairs[key] = value
      }
      
      // Parse moves
      var aux = [String]()
      let moves = rawPGN.components(separatedBy: "\n1.")
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
      
      
      let pgn = PGN(event: keyValuePairs["Event"],
                    site: keyValuePairs["Site"],
                    date: keyValuePairs["Date"],
                    round:  keyValuePairs["Round"],
                    whitePlayer: keyValuePairs["White"]!,
                    blackPlayer: keyValuePairs["Black"]!,
                    whiteElo: keyValuePairs["WhiteElo"] == "" ? nil : keyValuePairs["WhiteElo"],
                    blackElo: keyValuePairs["BlackElo"] == "" ? nil : keyValuePairs["BlackElo"],
                    result: keyValuePairs["Result"],
                    moves: aux,
                    rawValue: rawPGN)
      
      return pgn
   }
   
}
