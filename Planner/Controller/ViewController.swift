//
//  ViewController.swift
//  Planner
//
//  Created by Scarlet on A2019/A/14.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, NetworkDelegate {
    
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
    var tableProject = [UITableView : Project]()
    var itemTransform = CGAffineTransform()
    
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
    //MARK: DELEGATE - NETWORK
    func ResponseHandle(data: Data) {
        SVProgressHUD.dismiss()
        let result = JSONParser().parse(data)!
        session.setProjects(with: result)
        DispatchQueue.main.async {
            self.plans.reloadData()
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
                self.heading.center.y = (self.view.safeAreaInsets.top + (self.plans.frame.origin.y - self.view.safeAreaInsets.top) / 2) - 7
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.plans.transform = .identity
                    self.plans.alpha = 1
                }, completion: nil)
            })
        }
    }
    
    //MARK: DELEGATE - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return session.getProjects()?.count ?? 0
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
        
        let project = session.getProjects()?[indexPath.row]
        
        tableProject[cell.itemList] = project
        
        network.send(url: baseURL + "items.php?PID=\(project!.PID)", method: "GET", query: nil) { (data) in
            guard let d = data else {return}
            let result = json.parse(d)!
            var items = [Item]()
            items.removeAll()
            for item in result{
                let i = Item()
                i.parse(item)
                items.append(i)
            }
            project?.items = items
            DispatchQueue.main.async {
                cell.itemList.reloadData()
            }
        }
        
        cell.planTitle.text = project?.title
        cell.author.text = project?.author
        
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
        return tableProject[tableView]?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        switch tableView.tag{
//        case -1:
//            cell.selectionStyle = .none
//        case 0:
//            cell.selectionStyle = .gray
//        default:
//            break
//        }
        
        let item = tableProject[tableView]?.items?[indexPath.row]
        
        cell.textLabel?.text = item?.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        itemTransform = cell!.transform
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            cell?.transform = .init(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            cell?.transform = self.itemTransform
        }, completion: nil)
    }
    
    //MARK: SETUP
    func delegate(){
        plans.delegate = self
        plans.dataSource = self
        network.delegate = self
    }
    func layout(){
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
    
    //MARK: VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate()
        layout()
        SVProgressHUD.show()
        network.send(url: baseURL + "projects.php", method: "GET", query: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        plans.transform = .init(translationX: 0, y: 20)
        
    }

}

