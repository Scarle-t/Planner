//
//  ViewController.swift
//  Planner
//
//  Created by Scarlet on A2019/A/14.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let colors: [UIColor] = ["ADFFF9".uiColor, "C6FFAD".uiColor, "FCFFAD".uiColor, "FFD0AD".uiColor]
    
    @IBOutlet weak var plans: UICollectionView!
    @IBOutlet weak var heading: UILabel!
    
    var cellTransform = CGAffineTransform()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! planCell
        
        cell.planTitle.text = "Wonderful Trip"
        
        cell.contentView.backgroundColor = colors[indexPath.row % colors.count]
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 17
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOpacity = 0.7
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        cellTransform = cell.transform
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            cell.transform = .identity
        }, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            cell.transform = self.cellTransform
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        plans.delegate = self
        plans.dataSource = self
        
        
        
        plans.collectionViewLayout = CardsCollectionViewLayout()
        
        let layout = plans.collectionViewLayout as! CardsCollectionViewLayout
        layout.itemSize = .init(width: plans.frame.width - 100, height: plans.frame.height - 250)
        layout.spacing = 30
        
        plans.isPagingEnabled = true
        plans.showsHorizontalScrollIndicator = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        plans.transform = .init(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.heading.center.y = self.view.safeAreaInsets.top + (self.plans.frame.origin.y - self.view.safeAreaInsets.top) / 2
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.plans.transform = .identity
                self.plans.alpha = 1
            }, completion: nil)
        })
        
        plans.reloadData()
    }


}

