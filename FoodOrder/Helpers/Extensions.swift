//
//  Extensions.swift
//  FoodOrder
//
//  Created by Aleksandar Nikolic on 10.5.23..
//

import UIKit

extension UIViewController {
  func showAlert(title: String, text: String) {
    let alertController = UIAlertController(title: title,
                                            message: text,
                                            preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
}

extension Date {
  func shortDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    let stringDate = dateFormatter.string(from: self)
    return stringDate
  }
}

extension String {
  var capitalizedSentence: String {
    let firstLetter = self.prefix(1).capitalized
    let remainingLetters = self.dropFirst().lowercased()
    return firstLetter + remainingLetters
  }
}
