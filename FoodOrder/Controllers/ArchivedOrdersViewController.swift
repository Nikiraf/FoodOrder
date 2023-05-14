//
//  ArchivedOrdersViewController.swift
//  FoodOrder
//
//  Created by Aleksandar Nikolic on 12.5.23..
//

import UIKit

class ArchivedOrdersViewController: UIViewController {
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let orderListStackView: UIStackView = {
    let orderListStackView = UIStackView()
    orderListStackView.axis = .vertical
    orderListStackView.spacing = 8
    orderListStackView.translatesAutoresizingMaskIntoConstraints = false
    return orderListStackView
  }()
  
  lazy private var closeButton: UIButton = {
    let closeButton = UIButton(type: .system)
    closeButton.setTitle("Close", for: .normal)
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    return closeButton
  }()
  
  var orders: [Order] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    showData()
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    view.addSubview(closeButton)
    
    NSLayoutConstraint.activate([
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
    
    view.addSubview(scrollView)
    
    scrollView.addSubview(stackView)
    
    let orderListView = UIView()
    stackView.addArrangedSubview(orderListView)
    
    orderListView.addSubview(orderListStackView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
      
      
      orderListStackView.topAnchor.constraint(equalTo: orderListView.topAnchor, constant: 8),
      orderListStackView.leadingAnchor.constraint(equalTo: orderListView.leadingAnchor, constant: 8),
      orderListStackView.trailingAnchor.constraint(equalTo: orderListView.trailingAnchor, constant: -8),
      orderListStackView.bottomAnchor.constraint(equalTo: orderListView.bottomAnchor, constant: -8),
    ])
  }
  
  private func showData() {
    // Clear the order list stack view
    orderListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    // Rebuild the order views
    for order in orders {
      let orderView = createOrderView(order)
      orderListStackView.addArrangedSubview(orderView)
    }
    
    // Adjust the spacing between orders
    orderListStackView.spacing = 8
  }
  
  private func createOrderView(_ order: Order) -> UIView {
    let view = UIView()
    view.backgroundColor = .lightGray
    view.layer.cornerRadius = 8
    
    let nameLabel = UILabel()
    nameLabel.text = "\(order.name)"
    
    let stateLabel = UILabel()
    stateLabel.text = "\(order.state.title)"
    
    let labelsStack = UIStackView(arrangedSubviews: [nameLabel, stateLabel])
    labelsStack.axis = .horizontal
    labelsStack.spacing = 8
    
    stackView.tag = order.id
    
    let stackView = UIStackView(arrangedSubviews: [labelsStack])
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
    ])
    
    return view
  }
  
  @objc private func closeButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
  
}
