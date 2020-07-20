//
//  ListTableViewCell.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
  var titleLabel = UILabel(frame: .zero)
  var descriptionLabel = UILabel(frame: .zero)
  var listImageView = UIImageView(image: UIImage(named: "no-photo"))
  var minHeight: CGFloat?
  
  // Set Image Height and Width as per screen size
  private var imageHeightConstant: CGFloat {
    if DeviceType.iPhone {
      return 60
    } else {
      return 70
    }
  }
  
  // Override func for setting minimum height to avoid content overlapping
  override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
    let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    guard let minHeight = minHeight else { return size }
    return CGSize(width: size.width, height: max(size.height, minHeight))
  }
  
  // Code Cleanup for cell reuse
  override func prepareForReuse() {
    listImageView.image = UIImage(named: "no-photo")
    titleLabel.text = ""
    descriptionLabel.text = ""
  }
}

// MARK: - UITableViewCell UI Configuration Methods
extension ListTableViewCell {
  // Configure all the Cell Elements
  func configureCellElements(with listDetailModel: ListDetailModel, networkingClient: ApiClient, row: Int){
    // Setup ImageView
    setupListImageView(imageString: listDetailModel.imageHref, networkingClient: networkingClient, row: row)
    
    // Setup Title Label
    setupTitleLabel(titleString: listDetailModel.title)
    
    // Setup Description Label
    setupDescriptionLabel(descriptionString: listDetailModel.description)
  }
  
  // Configuration method for ListImageView
  private func setupListImageView(imageString: String, networkingClient: ApiClient, row: Int) {
    listImageView.translatesAutoresizingMaskIntoConstraints = false
    
    // Download image only if imageHref is not empty
    if imageString != "" {
      // Download image here
      // Create background thread to download image
      DispatchQueue.global(qos: .background).async { [weak self] in
        guard let self = self else { return }
        self.downloadImage(urlString: imageString, networking: networkingClient) {[weak self] (image) in
          guard let self = self else { return }
          
          // Get Main thread to update UI
          DispatchQueue.main.async {
            // Check if cell is relevant to assign downloaded image
            if self.tag == row {
              self.listImageView.image = image
            }
          }
        }
      }
    }
    self.addSubview(listImageView)
    
    // ListImageView Constraints
    listImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
    listImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    listImageView.heightAnchor.constraint(equalToConstant: imageHeightConstant).isActive = true
    listImageView.widthAnchor.constraint(equalToConstant: imageHeightConstant).isActive = true
  }
  
  // Configuration method for TitleLabel
  private func setupTitleLabel(titleString: String) {
    // Set font as per text style. No need to set FontSize
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.adjustsFontForContentSizeCategory = true
    
    // Title Label text rendering configuration
    titleLabel.text = titleString
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(titleLabel)
    
    // Title Label Constraints
    titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: listImageView.trailingAnchor, constant: 10).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
  }
  
  // Configuration method for DescriptionLabel
  private func setupDescriptionLabel(descriptionString: String) {
    // Set font as per text style. No need to set FontSize
    descriptionLabel.font = .preferredFont(forTextStyle: .body)
    descriptionLabel.adjustsFontForContentSizeCategory = true
    
    // Description Label text rendering configuration
    descriptionLabel.text = descriptionString
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping
    descriptionLabel.textColor = .darkGray
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(descriptionLabel)
    
    // Description Label Constraints
    descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
    descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
    descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
  }
}

// MARK: - Download Image Method
extension ListTableViewCell {
  func downloadImage(urlString: String, networking: ApiClient, completion: @escaping (UIImage)-> Void){
    networking.downloadImage(from: urlString) { (result) in
      switch result{
      case .failure(let error):
        print(error)
      case .success(let imageData):
        if let image = UIImage(data: imageData){
          completion(image)
        }else{
          completion(UIImage())
        }
      }
    }
  }
}
