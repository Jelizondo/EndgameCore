//
//  File.swift
//  
//
//  Created by Jorge Elizondo on 9/27/20.
//

import Foundation

public struct Opening: Identifiable, Decodable {
   public let id = UUID()
   public let eco: String
   public let name: String
   public let variation: String?
   public let moves: [String]
  
   enum CodingKeys: String, CodingKey {
      case eco
      case name
      case variation
      case moves
   }
}
