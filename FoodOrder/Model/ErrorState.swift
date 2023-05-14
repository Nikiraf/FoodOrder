//
//  ErrorState.swift
//  FoodOrder
//
//  Created by Aleksandar Nikolic on 12.5.23..
//

import Foundation

enum ErrorState: String {
  case previousOrdersNotProcessed = "Previous orders are not processed yet."
  case prepairingOrdersQueueIsFull = "Prepairing order queue is full"
  case maximumNumbersOfOrdersReached = "Maximum number of orders is %d"
  case systemError = "System error"
}
