//
//  ListViewController.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  private let viewModel = ListViewModel()
  private let listTableView = UITableView()
  private var activityIndicator = UIActivityIndicatorView()
  private let noRecordLabel = UILabel(frame: .zero)
  var safeArea: UILayoutGuide!
  private let refreshControl = UIRefreshControl()
  
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
    
    // Call API to Fetch List if network available
    if ReachabilityManager.sharedManager.isNetworkRechable {
      callGetListAPI()
    } else {
      showNetworkToast()
    }
    
    // Adding observer for Reachability
    NotificationCenter.default.addObserver(self, selector: #selector(showNetworkToast), name: NSNotification.Name(rawValue: Constants.kNetworkChangeIdentifier), object: nil)
  }
  
  // MARK: - Pull to Refresh Method
  @objc func pullToRefresh(_ sender: UIRefreshControl) {
    if ReachabilityManager.sharedManager.isNetworkRechable {
      refreshControl.beginRefreshing()
      
      // Pass sender for hiding ActivityIndicator when called from RefreshControl
      callGetListAPI(refreshControl: sender)
    } else {
      refreshControl.endRefreshing()
      showNetworkToast()
    }
  }
  
  // MARK: - Reachability Toast Method
  @objc func showNetworkToast() {
    let toastView = NetworkErrorToastView()
    let toastHeight: CGFloat = DeviceType.hasTopNotch ? 70.0 : 50.0
    toastView.frame = CGRect(x: 0, y: ScreenSize.height, width: ScreenSize.width, height: toastHeight)
    if (!ReachabilityManager.sharedManager.isNetworkRechable) {
      toastView.setUpViewWithText(text: Constants.KNoNetwork)
    }
    view.addSubview(toastView)
    
    // Animation Block
    toastView.toastAnimation()
  }
}

// MARK: - API Method
extension ListViewController {
  func callGetListAPI (refreshControl: UIRefreshControl? = nil) {
    // If called from Refresh Control then don't show ActivityIndicator
    if refreshControl == nil {
      activityIndicator.isHidden = false
      activityIndicator.startAnimating()
    }
    
    // Background call for GetList API
    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let self = self else { return }
      self.viewModel.getList(completion: { (error) in
        // Populate UI as per API Response
        self.gotListData(error: error)
      })
    }
  }
}

// MARK: - API Response Handling Method
extension ListViewController {
  func gotListData(error: NSError?) {
    // Get MainThread to Update UI elements
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.refreshControl.endRefreshing()
      self.activityIndicator.isHidden = true
      self.activityIndicator.stopAnimating()
      
      // If listData nil then show Alert
      if let listData = self.viewModel.listData {
        self.setUpNavigationBar(title: listData.title)
        self.noRecordLabel.isHidden = true
        self.listTableView.reloadData()
        if listData.rows.count == 0 {
          self.noRecordLabel.isHidden = false
        }
      } else {
        // Show Error alert
        let alertMsg = error != nil ? error!.localizedDescription : Constants.kErrorFetchList
        let alertVC = UIAlertController(title: Constants.kError, message: alertMsg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: Constants.kOk, style: .default, handler: nil))
        self.navigationController?.present(alertVC, animated: true, completion: nil)
        self.noRecordLabel.isHidden = false
        self.setUpNavigationBar(title: "")
        self.listTableView.reloadData()
      }
    }
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
    listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: Constants.kListCellIdentifier)
    listTableView.delegate = viewModel
    listTableView.dataSource = viewModel
    listTableView.tableFooterView = UIView(frame: .zero)
    listTableView.estimatedRowHeight = 120
    listTableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
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
    noRecordLabel.text = Constants.kNoRecordFound
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
