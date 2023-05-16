//
//  OrderViewModel.swift
//  FoodOrder
//
//  Created by Aleksandar Nikolic on 10.5.23..
//

import Foundation
import UIKit

final class OrderViewModel {
  private (set) var ordersFullList: [Order] = [] // does not contains deliveredOrders
  private (set) var filteredOrders: [Order]?
  var deliveredOrders: [Order] = []
  
  let maxNumberOfThePrepairingOrders: Int = 3
  let maxNumberOfTotalOrders: Int = 10
  
  var showError: ((String) -> Void)?
  var reloadData: (() -> Void)?
  
  var activeOrders: [Order] {
    guard let filteredOrders = filteredOrders else {
      return ordersFullList
    }
    return filteredOrders
  }
  
  func addFilteredOrders(_ filteredOrders: [Order]?) {
    self.filteredOrders = filteredOrders
  }
  
  func placeOrder(name: String) {
    guard ordersFullList.count < maxNumberOfTotalOrders else {
      self.showError?(String(format: ErrorState.maximumNumbersOfOrdersReached.rawValue, maxNumberOfTotalOrders))
      return
    }
    
    // Order id should be unique number that will handle database. For the task purpose it id done this way
    let a = ordersFullList.count+deliveredOrders.count + 1
    let order = Order(id: a, name: name, state: .new)
    ordersFullList.append(order)
  }
  
  func changeOrderState(_ order: Order) {
    if let error = changeStateError(order) {
      showError?(error.rawValue)
      return
    }
    
    switchToNextState(for: order)
  }
  
  func switchToNextState(for order: Order) {
    guard let index = ordersFullList.firstIndex(where: { $0.id == order.id }) else {
      return
    }
    
    switch order.state {
    case .new:
      ordersFullList[index].state = .preparing
    case .preparing:
      ordersFullList[index].state = .ready
    case .ready:
      ordersFullList[index].state = .delivered
      deliveredOrders.append(ordersFullList[index])
      DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
        self.removeDeliveredOrder(order)
      }
    case .delivered:
      break
    }
    reloadData?()
  }
  
  func changeStateError(_ order: Order) -> ErrorState? {
    let previousOrders = ordersFullList.filter({$0.createDate < order.createDate})
    
    let previousOrdersAreProcessed = previousOrders.allSatisfy{ $0.state.rawValue > order.state.rawValue }
    
    // Check if previous orders are processed
    if !previousOrdersAreProcessed {
      return .previousOrdersNotProcessed
    }
    
    // Check if number of prepairing orders queue is full
    let ordersInPrepairingState: [Order] = ordersFullList.filter({$0.state == .preparing && $0.id != order.id})
    
    if ordersInPrepairingState.count == maxNumberOfThePrepairingOrders {
      return .prepairingOrdersQueueIsFull
    }
    
    return nil
    
  }
  
  private func removeDeliveredOrder(_ order: Order) {
    guard let orderIndex = ordersFullList.firstIndex(where: { $0.id == order.id }) else {
      return
    }
    ordersFullList.remove(at: orderIndex)
    
    // Remove delivered order from the searches orders as well
    if let deliveredOrderIndex = filteredOrders?.firstIndex(where: { $0.id == order.id }) {
      filteredOrders?.remove(at: deliveredOrderIndex)
    }
    
    reloadData?()
  }
  
  func searchOrders(query: String) -> [Order] {
    return ordersFullList.filter { $0.name.contains(query) || String($0.id).contains(query) }
  }
}
