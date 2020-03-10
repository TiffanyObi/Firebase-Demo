//
//  CatergoryCell.swift
//  Firebase-Demo
//
//  Created by Tiffany Obi on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class CatergoryCell: UICollectionViewCell {
    
    @IBOutlet weak var catergoryImageView: UIImageView!
    
    @IBOutlet weak var catergoryNameLabel: UILabel!
    
    
    public func configureCell(for category: Category){
        catergoryNameLabel.text = category.name
        let colorImage = category.image.withTintColor(.generateRandomColor(), renderingMode: .alwaysOriginal)
        catergoryImageView.image = colorImage
    }
}

extension UIColor {
  static func generateRandomColor() -> UIColor {
      let redValue = CGFloat.random(in: 0...1)
      let greenValue = CGFloat.random(in: 0...1)
      let blueValue = CGFloat.random(in: 0...1)
      let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
      return randomColor
  }
}
