//
//  ListViewController.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  private let listTableView = UITableView()
  private var activityIndicator = UIActivityIndicatorView()
  private let noRecordLabel = UILabel(frame: .zero)
  var safeArea: UILayoutGuide!
  private let cellIdentifier = "ListCellIdentifier"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    // Safe Area Layout Initialized
    safeArea = view.safeAreaLayoutGuide
    
    // Set up all the views programmatically
    setUpNavigationBar(title: "")
    setUpTableView()
    setUpActivityIndicator()
    setUpNoRecordLabel()
  }
}

// MARK: - ViewController UI Configuration Methods
extension ListViewController {
  // Setup NavigationBar with Title
  func setUpNavigationBar(title: String) {
    navigationItem.title = title
  }
  
  // Setup TableView
  func setUpTableView() {
    listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    listTableView.delegate = self
    listTableView.dataSource = self
    listTableView.tableFooterView = UIView(frame: .zero)
    listTableView.estimatedRowHeight = 120
    view.addSubview(listTableView)
    listTableView.translatesAutoresizingMaskIntoConstraints = false
    
    //Table View constraints
    listTableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    listTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
    listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    listTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
  }
  
  // Setup ActivityIndicator
  func setUpActivityIndicator() {
    //Activity Indicator style as per iOS
    if #available(iOS 13.0, *) {
      activityIndicator = UIActivityIndicatorView.init(style: .medium)
    } else {
      activityIndicator = UIActivityIndicatorView.init(style: .gray)
    }
    activityIndicator.center = CGPoint(x: self.view.frame.size.width / 2.0, y: self.view.frame.size.height / 2.0)
    activityIndicator.color = .gray
    self.view.addSubview(activityIndicator)
  }
  
  // Setup NoRecordsFound Label
  func setUpNoRecordLabel() {
    noRecordLabel.isHidden = true
    noRecordLabel.text = "No Records Found"
    noRecordLabel.textColor = .red
    noRecordLabel.font = .preferredFont(forTextStyle: .headline)
    noRecordLabel.adjustsFontForContentSizeCategory = true
    noRecordLabel.textAlignment = .center
    noRecordLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(noRecordLabel)
    view.bringSubviewToFront(noRecordLabel)
    
    //No Record Label constraints
    noRecordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    noRecordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    noRecordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    noRecordLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
  }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ListTableViewCell else {
      return UITableViewCell()
    }
    cell.tag = indexPath.row
    cell.selectionStyle = .none
    return cell
  }
}
