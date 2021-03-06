//
//  NetworkErrorToastView.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import UIKit

class NetworkErrorToastView: UIView {
  private var toastTitle = UILabel(frame: .zero)
  
  func setUpViewWithText(text: String) {
    self.backgroundColor = .red
    toastTitle.text = text
    toastTitle.font = .systemFont(ofSize: 16, weight: .regular)
    toastTitle.textColor = .white
    toastTitle.translatesAutoresizingMaskIntoConstraints = false
    addSubview(toastTitle)
    
    toastTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
    toastTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
    toastTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    toastTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  }
  
  func toastAnimation() {
    // Animation Block
    UIView.animate(withDuration: 0.4, delay: 0.0,
                   animations: {
                    self.frame.origin.y = ScreenSize.height - self.frame.size.height
    }, completion: { _ in
      UIView.animate(withDuration: 0.4, delay: 3.0,
                     animations: {
                      self.frame.origin.y = ScreenSize.height
      }, completion: { _ in
        if ((self.superview) != nil) {
          self.removeFromSuperview()
        }
      })
    })
  }
}
