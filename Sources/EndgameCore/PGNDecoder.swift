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
      
      var pgn: [PGN] = []
      for rawPGN in rawPGNs {
         pgn.append(PGN(pgn: rawPGN))
      }
      
      return pgn
   }
   
}


