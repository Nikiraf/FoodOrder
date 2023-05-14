//
//  Order.swift
//  FoodOrder
//
//  Created by Aleksandar Nikolic on 10.5.23..
//

import Foundation

struct Order: Equatable {
  let id: Int
  let name: String
  private (set) var createDate: Date
  
  var createdDateShort: String {
    return createDate.shortDate()
  }
  
  var state: OrderState
  
  init(id: Int, name: String, state: OrderState) {
    self.id = id
    self.createDate = Date()
    self.name = name
    self.state = state
  }
  
}

enum OrderState: Int {
  case new
  case preparing
  case ready
  case delivered
  
  var title: String {
    switch self {
    case .new:
      return "New"
    case .preparing:
      return "Preparing"
    case .ready:
      return "Ready"
    case .delivered:
      return "Delivered"
    }
  }
  
  
}
