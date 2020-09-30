//
//  File.swift
//  
//
//  Created by Jorge Elizondo on 9/27/20.
//

import Foundation

public struct ECO: Identifiable, Decodable {
   
   public let id = UUID()
   public let key: String
   public let openingName: String
   public let variation: String?
   public let moves: [String]
  
   enum CodingKeys: String, CodingKey {
      case key = "eco"
      case openingName = "name"
      case variation
      case moves
   }
}
