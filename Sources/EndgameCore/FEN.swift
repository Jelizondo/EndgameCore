//
//  FEN.swift
//  
//
//  Created by Jorge Elizondo on 1/14/20.
//

import Foundation

public struct FEN {
   public let rawValue: String
   public var piecePlacement: String {
      return String(rawValue.split(separator: " ").first!)
   }
   
   public init(string: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1") {
      rawValue = string
   }
   
}
