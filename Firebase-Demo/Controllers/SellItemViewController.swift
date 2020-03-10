//
//  SellItemViewController.swift
//  Firebase-Demo
//
//  Created by Tiffany Obi on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class SellItemViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var catergories = Category.getCategories()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate =  self
    }
    

   

}

extension SellItemViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catergories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let catergoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CatergoryCell else {
            fatalError("Could not downcast to Catergory Cell")
        }
        
        let catergory = catergories[indexPath.row]
        
        catergoryCell.configureCell(for: catergory)
        
        return catergoryCell
    }
    
    
}

extension SellItemViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let interSpacing: CGFloat = 11
        let numberOfItems: CGFloat = 3
        let totalSpacing: CGFloat = ((2 * interSpacing) + (numberOfItems - 1) * interSpacing)
        let itemWidth: CGFloat = ((maxSize.width - totalSpacing) / numberOfItems)
        let itemHeight: CGFloat = (maxSize.height * 0.20)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //segue to creatViewController
        let catergory =  catergories[indexPath.row]
        let mainViewStoryboard = UIStoryboard(name: "MainView", bundle: nil)
       let createItemVC = mainViewStoryboard.instantiateViewController(identifier: "CreateItemViewController") { coder in
            return CreateItemViewController(coder: coder, category: catergory)
        }
        
        present(UINavigationController(rootViewController: createItemVC), animated:  true)
        
    }
}
