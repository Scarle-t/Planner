//
//  ViewController.swift
//  Planner
//
//  Created by Scarlet on A2019/A/14.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: VAR
    let startColors: [CGColor] = [
        "ADFFF9".uiColor.cgColor,
        "C6FFAD".uiColor.cgColor,
        "FCFFAD".uiColor.cgColor,
        "FFD0AD".uiColor.cgColor,
    ]
    let endColors: [CGColor] = [
        "7CD5EA".uiColor.cgColor,
        "7CEAAB".uiColor.cgColor,
        "EACC7C".uiColor.cgColor,
        "EA7C7C".uiColor.cgColor,
    ]
    
    var cellTransform = CGAffineTransform()
    var currentIndex = IndexPath()
    var currentCell: planCell = planCell()
    
    //MARK: IBOUTLET
    @IBOutlet weak var plans: UICollectionView!
    @IBOutlet weak var heading: UILabel!
    
    //MARK: OBJC FUNC
    @IBAction func closeCell(_ sender: UIButton){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            sender.alpha = 0
            self.currentCell.transform = self.cellTransform
            self.plans.layer.shadowOpacity = 0.2
        }, completion: { _ in
            UIView.performWithoutAnimation {
                self.plans.reloadItems(at: [self.currentIndex])
            }
        })
        currentCell.itemList.isUserInteractionEnabled = false
        currentCell.itemList.isScrollEnabled = false
        currentCell.itemList.allowsSelection = false
        currentCell.itemList.tag = -1
        currentCell.itemList.reloadData()
        plans.isScrollEnabled = true
        plans.allowsSelection = true
    }
    
    //MARK: DELEGATE - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! planCell
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 17
        
        let gradLayer = CAGradientLayer()
        gradLayer.frame = cell.bounds
        let startColor = startColors[indexPath.row % startColors.count]
        let endColor = endColors[indexPath.row % endColors.count]
        gradLayer.colors = [startColor, endColor]
        cell.gradView.layer.addSublayer(gradLayer)
        
        cell.itemList.delegate = self
        cell.itemList.dataSource = self
        cell.itemList.allowsSelection = false
        cell.itemList.tag = -1
        cell.itemList.reloadData()
        
        cell.planTitle.text = "Title"
        cell.author.text = "Author"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)! as! planCell
        currentCell = cell
        currentIndex = indexPath
        cellTransform = cell.transform
        cell.superview?.bringSubviewToFront(cell)
        
        let cellRatioX = collectionView.bounds.width / cell.bounds.width
        let cellRatioY = collectionView.bounds.height / cell.bounds.height
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            cell.transform = .init(scaleX: cellRatioX, y: cellRatioY)
            cell.closeBtn.alpha = 1
            collectionView.layer.shadowOpacity = 0.0
        }, completion: nil)
        
        cell.itemList.isUserInteractionEnabled = true
        cell.itemList.isScrollEnabled = true
        cell.itemList.allowsSelection = true
        cell.itemList.tag = 0
        cell.itemList.reloadData()
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = false
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
    
    //MARK: DELEGATE - TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch tableView.tag{
        case -1:
            cell.selectionStyle = .none
        case 0:
            cell.selectionStyle = .gray
        default:
            break
        }
        
        cell.textLabel?.text = "Item"
        cell.textLabel?.textColor = .black
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
    }
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        plans.delegate = self
        plans.dataSource = self
        
        plans.collectionViewLayout = CardsCollectionViewLayout()
        
        let layout = plans.collectionViewLayout as! CardsCollectionViewLayout
        layout.itemSize = .init(width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.7)
        layout.spacing = 30
        
        plans.isPagingEnabled = true
        plans.showsHorizontalScrollIndicator = false
        
        plans.layer.masksToBounds = true
        plans.layer.shadowColor = UIColor.lightGray.cgColor
        plans.layer.shadowOpacity = 0.2
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        plans.transform = .init(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
            self.heading.center.y = (self.view.safeAreaInsets.top + (self.plans.frame.origin.y - self.view.safeAreaInsets.top) / 2) - 7
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.plans.transform = .identity
                self.plans.alpha = 1
            }, completion: nil)
        })
        plans.reloadData()
    }

}

