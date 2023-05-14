//
//  HomeViewController.swift
//  FoodOrder
//
//  Created by Aleksandar Nikolic on 10.5.23..
//

import UIKit

class HomeViewController: UIViewController {
  
  //MARK: UI elements
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
  
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Search by ID or name"
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    return searchBar
  }()
  
  private let orderListStackView: UIStackView = {
    let orderListStackView = UIStackView()
    orderListStackView.axis = .vertical
    orderListStackView.spacing = 8
    orderListStackView.translatesAutoresizingMaskIntoConstraints = false
    return orderListStackView
  }()
  
  lazy private var rightBarButton: UIBarButtonItem = {
    let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "archivebox.fill"), style: .plain, target: self, action: #selector(openArchivedOrders))
    rightBarButton.isEnabled = false
    return rightBarButton
  }()
  
  lazy private var placeOrderButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Place Order", for: .normal)
    button.addTarget(self, action: #selector(placeOrderButtonTapped), for: .touchUpInside)
//    button.configuration = .filled()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  //MARK: Properties
  private let viewModel = OrderViewModel()
  
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    viewModel.showError = { [weak self] (error: String) in
      guard let self = self else { return }
      self.showAlert(title: "Error", text: error)
    }
    
    viewModel.reloadData = { [weak self] in
      guard let self = self else { return }
      self.reloadOrderList()
    }
    
  }
  
  //MARK: UI
  private func setupUI() {
    view.backgroundColor = .white
    title = "Restaurant orders"
    navigationItem.rightBarButtonItem = rightBarButton
    
    view.addSubview(scrollView)
    scrollView.addSubview(stackView)
    
    stackView.addArrangedSubview(searchBar)
    
    stackView.addArrangedSubview(placeOrderButton)
    
    let orderListView = UIView()
    stackView.addArrangedSubview(orderListView)
    
    orderListView.addSubview(orderListStackView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
      
      searchBar.heightAnchor.constraint(equalToConstant: 50),
      
      orderListStackView.topAnchor.constraint(equalTo: orderListView.topAnchor, constant: 8),
      orderListStackView.leadingAnchor.constraint(equalTo: orderListView.leadingAnchor, constant: 8),
      orderListStackView.trailingAnchor.constraint(equalTo: orderListView.trailingAnchor, constant: -8),
      orderListStackView.bottomAnchor.constraint(equalTo: orderListView.bottomAnchor, constant: -8),
      
      placeOrderButton.heightAnchor.constraint(equalToConstant: 50)
    ])
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openOrderDetails(_:)))
    stackView.addGestureRecognizer(tapGesture)
    stackView.isUserInteractionEnabled = true
    
    searchBar.delegate = self
  }
  
  private func createOrderView(_ order: Order) -> UIView {
    let view = UIView()
    view.backgroundColor = .lightGray
    view.layer.cornerRadius = 8
    
    let nameLabel = UILabel()
    nameLabel.text = "\(order.name)"
    
    let stateLabel = UILabel()
    stateLabel.sizeToFit()
    stateLabel.text = "\(order.state.title)"
    
    let labelsStack = UIStackView(arrangedSubviews: [nameLabel, stateLabel])
    labelsStack.axis = .horizontal
    labelsStack.spacing = 8
    
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: labelsStack.leadingAnchor),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: stateLabel.leadingAnchor),
      stateLabel.trailingAnchor.constraint(equalTo: labelsStack.trailingAnchor)
    ])
    
    let nextStateButton = UIButton(type: .system)
    nextStateButton.setTitle("Next State", for: .normal)
    nextStateButton.addTarget(self, action: #selector(nextStateButtonTapped(_:)), for: .touchUpInside)
    nextStateButton.tag = order.id
    stackView.tag = order.id
    
    let stackView = UIStackView(arrangedSubviews: [labelsStack, nextStateButton])
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
    
    nameLabel.layoutIfNeeded()
    stackView.layoutIfNeeded()
    
    nextStateButton.isEnabled = order.state != .delivered
    
    return view
  }
  
  private func reloadOrderList() {
    // Clear the order list stack view
    orderListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    orderListStackView.addArrangedSubview(placeOrderButton)
    
    // Rebuild the order views
    for order in viewModel.activeOrders {
      let orderView = createOrderView(order)
      orderListStackView.addArrangedSubview(orderView)
    }
    
    // Adjust the spacing between orders
    orderListStackView.spacing = 8
    orderListStackView.layoutIfNeeded()
    
    rightBarButton.isEnabled = !viewModel.deliveredOrders.isEmpty
    
  }
  
  //MARK: Functions
  private func changeOrderState(_ order: Order) {
    viewModel.changeOrderState(order)
    reloadOrderList()
  }
  
  @objc private func placeOrderButtonTapped() {
    let alertController = UIAlertController(title: "Place Order", message: "Enter order name", preferredStyle: .alert)
    alertController.addTextField { textField in
      textField.placeholder = "Name"
    }
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
      guard let self = self else { return }
      if let name = alertController.textFields?.first?.text {
        self.viewModel.placeOrder(name: name)
        self.reloadOrderList()
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(confirmAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }
  
  @objc private func nextStateButtonTapped(_ sender: UIButton) {
    let orderId = sender.tag
    if let order = viewModel.activeOrders.first(where: { $0.id == orderId }) {
      changeOrderState(order)
    }
  }
  
}

//MARK: Navigate
extension HomeViewController {
  @objc private func openOrderDetails(_ gesture: UITapGestureRecognizer) {
    guard let orderID = gesture.view?.tag,
          let order = viewModel.activeOrders.first(where: { $0.id == orderID }) else {
      showAlert(title: "Error", text: "Order details not available")
      return
    }
    let orderDetailViewController = OrderDetailViewController()
    orderDetailViewController.order = order
    
    // Present the order detail screen
    self.present(orderDetailViewController, animated: true, completion: nil)
  }
  
  @objc
  private func openArchivedOrders() {
    let vc = ArchivedOrdersViewController()
    vc.orders = viewModel.deliveredOrders
    self.present(vc, animated: true, completion: nil)
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let text = searchText.lowercased()
    var filteredOrders: [Order]? = viewModel.activeOrders.filter { order in
      return (order.name.lowercased().contains(text) || text == String(order.id))
    }
    if text.isEmpty {
      filteredOrders = nil
    }
    viewModel.addFilteredOrders(filteredOrders)
    
    reloadOrderList()
  }
 
//  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//    print("End")
//  }
//
//  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//    print("Start")
//  }
  
}
