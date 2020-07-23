//
//  ListViewModel.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import Foundation
import UIKit

class ListViewModel: NSObject {
  let httpLayer = HTTPLayer()
  let networking: ApiClient
  var listData: ListModel?
  var listRows: [ListDetailModel]?
  
  // Cell minimum height as per device
  private var cellMinimumHeight: CGFloat {
    if DeviceType.iPhone {
      return 70
    } else {
      return 80
    }
  }
  
  // MARK: - Class Methods
  override init(){
    // Initialize networking for API Calls
    networking = ApiClient(httpLayer: httpLayer)
  }
  
  // Get List API Call
  func getList(completion: @escaping (NSError?) -> Void) {
    networking.fetchList() { [weak self] (result) in
      guard let self = self else {
        return
      }
      switch result{
      case .failure(let error):
        completion(error as NSError)
      case .success(let list):
        self.listData = list
        completion(nil)
      }
    }
  }
  
  func filterRows() {
    if let rows = listData?.rows {
      listRows = rows.filter({ (listDetailModel) -> Bool in
        (listDetailModel.title != nil) ||
        (listDetailModel.imageHref != nil) ||
        (listDetailModel.description != nil)
      })
    } else {
      listRows = nil
    }
  }
}

// MARK: - UITableViewDelegate
extension ListViewModel: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

// MARK: - UITableViewDataSource
extension ListViewModel: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listRows?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kListCellIdentifier) as? ListTableViewCell else {
      return UITableViewCell()
    }
    guard let listModel = listRows?[indexPath.row] else {
      return UITableViewCell()
    }
    cell.tag = indexPath.row
    cell.configureCellElements(with: listModel, networkingClient:networking, row: indexPath.row)
    cell.selectionStyle = .none
    
    // Set minimum height for cell
    cell.minHeight = cellMinimumHeight
    
    return cell
  }
}
