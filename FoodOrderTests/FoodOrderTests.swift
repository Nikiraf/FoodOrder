//
//  FoodOrderTests.swift
//  FoodOrderTests
//
//  Created by Aleksandar Nikolic on 10.5.23..
//

import XCTest
@testable import FoodOrder

class FoodOrderTests: XCTestCase {

  private var orderViewModel = OrderViewModel()
  
  private var expectedError = ""
  
  func initData() {
    orderViewModel.showError = {(error: String) in
      XCTAssertEqual(error, self.expectedError)
    }
    
    self.orderViewModel.placeOrder(name: "Order 1")
    self.orderViewModel.placeOrder(name: "Order 2")
    self.orderViewModel.placeOrder(name: "Order 3")
    
  }
  
  func testChangingSecondOrderStateBeforeChangingFirstOrderState() {
    expectedError = ErrorState.previousOrdersNotProcessed.rawValue
    initData()
    
    orderViewModel.changeOrderState(orderViewModel.orders[1])
    
  }
  
  func testChangingThirdOrderStateBeforeChangingSecondOrderState() {
    expectedError = ErrorState.previousOrdersNotProcessed.rawValue
    initData()
    
    orderViewModel.changeOrderState(orderViewModel.orders[2])
    
  }
  
  func testChangingOrderState() {
    expectedError = ""
    initData()
    
    orderViewModel.reloadData = {
      XCTAssertEqual(self.orderViewModel.orders[0].state, OrderState.preparing)
    }
    
    orderViewModel.changeOrderState(orderViewModel.orders[0])
    
  }
  
  func testExceedingMaximumNumberOfOrders() {
    expectedError = String(format: ErrorState.maximumNumbersOfOrdersReached.rawValue, self.orderViewModel.maxNumberOfTotalOrders)
    initData()
    
    self.orderViewModel.placeOrder(name: "Order 4")
    self.orderViewModel.placeOrder(name: "Order 5")
    self.orderViewModel.placeOrder(name: "Order 6")
    self.orderViewModel.placeOrder(name: "Order 7")
    self.orderViewModel.placeOrder(name: "Order 8")
    self.orderViewModel.placeOrder(name: "Order 9")
    self.orderViewModel.placeOrder(name: "Order 10")
    self.orderViewModel.placeOrder(name: "Order 11")
    
    orderViewModel.showError = {(error: String) in
      XCTAssertEqual(error, self.expectedError)
    }
    
    
  }

}
