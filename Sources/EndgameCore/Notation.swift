//
//  Notation.swift
//  
//
//  Created by Jorge Elizondo on 1/17/20.
//

import Foundation

public enum Notation: String, CaseIterable {
   case a1, a2, a3, a4, a5, a6, a7, a8
   case b1, b2, b3, b4, b5, b6, b7, b8
   case c1, c2, c3, c4, c5, c6, c7, c8
   case d1, d2, d3, d4, d5, d6, d7, d8
   case e1, e2, e3, e4, e5, e6, e7, e8
   case f1, f2, f3, f4, f5, f6, f7, f8
   case g1, g2, g3, g4, g5, g6, g7, g8
   case h1, h2, h3, h4, h5, h6, h7, h8
   
   
   func offset(_ x: Int, _ y: Int) -> Notation? {
      let components = Array(self.rawValue)
      let column = Character(UnicodeScalar(Int(components[0].asciiValue!) + x)!)
      let rank = components[1].wholeNumberValue! + y
      let rawValue = "\(column)\(rank)"
      
      return Notation(rawValue: rawValue)
   }
}
