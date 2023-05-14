//
//  OrderDetailViewController.swift
//  FoodOrder
//
//  Created by Aleksandar Nikolic on 11.5.23..
//

import UIKit

class OrderDetailViewController: UIViewController {
  var order: Order!
  
  private let mainStackView: UIStackView = {
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.alignment = .center
    mainStackView.spacing = 16
    return mainStackView
  }()
  
  lazy private var closeButton: UIButton = {
    let closeButton = UIButton(type: .system)
    closeButton.setTitle("Close", for: .normal)
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    return closeButton
  }()
  
  private let orderDetailsLabel: UILabel = {
    let orderDetailsLabel = UILabel()
    orderDetailsLabel.text = "Order Details"
    orderDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
    orderDetailsLabel.font = UIFont.boldSystemFont(ofSize: 16)
    return orderDetailsLabel
  }()
  
  private let nameLabel = UILabel()
  private let stateLabel = UILabel()
  private let dateLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupUI()
    updateOrderDetails()
  }
  
  private func setupUI() {
    
    view.addSubview(orderDetailsLabel)
    
    NSLayoutConstraint.activate([
      orderDetailsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      orderDetailsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    
    mainStackView.addArrangedSubview(nameLabel)
    mainStackView.addArrangedSubview(stateLabel)
    mainStackView.addArrangedSubview(dateLabel)
    
    view.addSubview(mainStackView)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    view.addSubview(closeButton)
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
    
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  private func updateOrderDetails() {
    nameLabel.text = "Order: \(order.name)"
    stateLabel.text = "State: \(order.state.title)"
    dateLabel.text = "Created: \(order.createdDateShort)"
  }
}
