//
//  ViewController.swift
//  Planner
//
//  Created by Scarlet on A2019/A/14.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, EKEventViewDelegate, NetworkDelegate {
    
    //MARK: - VAR
    let network = Network()
    
    var cellTransform = CGAffineTransform()
    var cellTransformAfterY = CGFloat.zero
    var currentIndex = IndexPath()
    var currentCell: planCell = planCell()
    var tableProject = [UITableView : Project]()
    var selectedProject = Project()
    var itemTransform = CGAffineTransform()
    var initialPlanY = CGFloat.zero
    var initial = CGPoint.zero
    var refreshPan: PanDirectionGestureRecognizer!
    var isExpand = false
    var isDetails = false
    
    //MARK: - IBOUTLET
    @IBOutlet weak var plans: UICollectionView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userMenu: UIButton!
    
    //MARK: - IBACTION
    @IBAction func closeCell(_ sender: UIButton){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            sender.alpha = 0
            self.currentCell.actionBtn.alpha = 0
            self.currentCell.transform = self.cellTransform
            self.plans.layer.shadowOpacity = 0.2
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.currentCell.details.alpha = 0
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentCell.itemList.alpha = 1
                }) { _ in
                    UIView.performWithoutAnimation {
                        self.plans.reloadItems(at: [self.currentIndex])
                    }
                }
            }
        })
        currentCell.itemList.isUserInteractionEnabled = false
        currentCell.itemList.isScrollEnabled = false
        currentCell.itemList.allowsSelection = false
        currentCell.itemList.tag = -1
        currentCell.itemList.reloadData()
        currentCell.details.isScrollEnabled = false
        currentCell.details.isUserInteractionEnabled = false
        plans.isScrollEnabled = true
        plans.allowsSelection = true
        isExpand = false
        isDetails = false
    }
    @IBAction func actionMenu(_ sender: UIButton) {
        let alert = UIAlertController(title: selectedProject.title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Project" + (self.isDetails ? " Items" : " Details"), style: .default, handler: { _ in
            if self.isDetails{
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentCell.details.alpha = 0
                }) { _ in
                    UIView.animate(withDuration: 0.2) {
                        self.currentCell.itemList.alpha = 1
                    }
                }
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentCell.itemList.alpha = 0
                }) { _ in
                    UIView.animate(withDuration: 0.2) {
                        self.currentCell.details.alpha = 1
                    }
                }
            }
            self.isDetails.toggle()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - OBJC FUNC
    @objc func refreshList(){
        SVProgressHUD.show()
        network.send(url: baseURL + "projects.php", method: "GET", query: nil)
    }
    @objc func panRefresh(_ sender: UIPanGestureRecognizer){
        let touch = sender.location(in: plans.window)
        
        switch sender.state {
        case .began:
            initial = touch
        case .changed:
            let ratio = ((touch.y - initial.y) / touch.y)
            if !isExpand{
                if touch.y > initial.y{
                    plans.frame.origin.y = initialPlanY + (touch.y - initial.y)
                    refreshIndicator.alpha = ratio * 2.3
                }
            }else{
                currentCell.frame.origin.y = cellTransformAfterY + (touch.y - initial.y)
            }
            
        case .ended, .cancelled:
            if !isExpand{
                UIView.animate(withDuration: 0.2) {
                    self.plans.frame.origin.y = self.initialPlanY
                }
                if touch.y - initial.y > plans.frame.height / 4{
                    refreshIndicator.alpha = 1
                    refreshIndicator.startAnimating()
                    refreshList()
                } else {
                    refreshIndicator.alpha = 0
                }
            }else{
                UIView.animate(withDuration: 0.2) {
                    self.currentCell.frame.origin.y = self.cellTransformAfterY
                }
                if touch.y - initial.y > plans.frame.height / 4{
                    closeCell(currentCell.closeBtn)
                }
            }
        case .failed, .possible:
            break
        @unknown default:
            break
        }
    }
    
    //MARK: - DELEGATE - NETWORK
    func ResponseHandle(data: Data) {
        let result = JSONParser().parse(data)!
        session.setProjects(with: result)
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.refreshIndicator.stopAnimating()
            self.refreshIndicator.alpha = 0
            self.plans.reloadData()
        }
    }
    
    //MARK: - DELEGATE - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return session.getProjects()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! planCell
        let project = session.getProjects()![indexPath.row]
        
        isExpand = false
        isDetails = false
        tableProject[cell.itemList] = project
        refreshPan = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(panRefresh(_:)))
        cell.itemList.delegate = self
        cell.itemList.dataSource = self
        cell.addGestureRecognizer(refreshPan)
        
        populatePlanCell(cell: cell, item: project)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)! as! planCell
        currentCell = cell
        selectedProject = session.getProjects()![indexPath.row]
        currentIndex = indexPath
        cellTransform = cell.transform
        cell.superview?.bringSubviewToFront(cell)
        
        let cellRatioX = collectionView.bounds.width / cell.bounds.width
        let cellRatioY = collectionView.bounds.height / cell.bounds.height
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            cell.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                cell.transform = .init(scaleX: cellRatioX, y: cellRatioY)
                cell.closeBtn.alpha = 1
                cell.actionBtn.alpha = 1
                collectionView.layer.shadowOpacity = 0.0
            }){ _ in
                self.cellTransformAfterY = cell.frame.origin.y
            }
        }
        
        cell.itemList.isUserInteractionEnabled = true
        cell.itemList.isScrollEnabled = true
        cell.itemList.allowsSelection = true
        cell.itemList.tag = 0
        cell.itemList.reloadData()
        cell.details.isScrollEnabled = true
        cell.details.isUserInteractionEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = false
        isExpand = true
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
    
    //MARK: - DELEGATE - TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let proj = tableProject[tableView] else {return 0}
        switch section{
        case 0:
            return proj.almostDue?.count ?? 0
        case 1:
            return proj.notYetDue?.count ?? 0
        case 2:
            return proj.past?.count ?? 0
        default:
            break
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! itemCell
        
        guard let almostDue = tableProject[tableView]?.almostDue, let notYetDue = tableProject[tableView]?.notYetDue, let past = tableProject[tableView]?.past else {return cell}
        
        switch indexPath.section{
        case 0:
            cell.item.text = almostDue[indexPath.row].content
            cell.dueDate.text = "Due: " + almostDue[indexPath.row].dueDate.getStringFormat(shortForm: true)
            cell.inCharge.text = almostDue[indexPath.row].inCharge
            cell.dueDate.textColor = .black
        case 1:
            cell.item.text = notYetDue[indexPath.row].content
            cell.dueDate.text = "Due: " + notYetDue[indexPath.row].dueDate.getStringFormat(shortForm: true)
            cell.inCharge.text = notYetDue[indexPath.row].inCharge
            cell.dueDate.textColor = .black
        case 2:
            cell.item.text = past[indexPath.row].content
            cell.dueDate.text = "Due: " + past[indexPath.row].dueDate.getStringFormat(shortForm: true)
            cell.inCharge.text = past[indexPath.row].inCharge
            cell.dueDate.textColor = .systemRed
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Almost Due"
        case 1:
            return "Up coming"
        case 2:
            return "Overdue"
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! itemCell
        itemTransform = cell.item.transform
        var currentItem = Item()
        switch indexPath.section{
        case 0:
            currentItem = self.tableProject[tableView]!.almostDue![indexPath.row]
        case 1:
            currentItem = self.tableProject[tableView]!.notYetDue![indexPath.row]
        case 2:
            currentItem = self.tableProject[tableView]!.past![indexPath.row]
        default:
            break
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            cell.item.transform = .init(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                cell.item.transform = self.itemTransform
            }, completion: { _ in
                let alert = UIAlertController(title: cell.item.text, message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Add to Calendar", style: .default, handler: { (_) in
                    let eventStore : EKEventStore = EKEventStore()

                    // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'

                    eventStore.requestAccess(to: .event) { (granted, error) in

                        if (granted) && (error == nil) {
                            let event:EKEvent = EKEvent(eventStore: eventStore)
                            
                            event.title = self.tableProject[tableView]!.title + " - " + currentItem.content
                            event.startDate = currentItem.startDate.getDateFormat()
                            event.endDate = currentItem.dueDate.getDateFormat()
                            event.calendar = eventStore.defaultCalendarForNewEvents
                            do {
                                try eventStore.save(event, span: .thisEvent)
                                DispatchQueue.main.async {
                                    SVProgressHUD.showSuccess(withStatus: nil)
                                    SVProgressHUD.dismiss(withDelay: 3)
                                    
                                    let nc = UINavigationController()
                                    let ek = EKEventViewController()
                                    ek.delegate = self
                                    ek.event = event
                                    ek.allowsCalendarPreview = true
                                    nc.addChild(ek)
                                    self.present(nc, animated: true, completion: nil)
                                    
                                }
                            } catch let error as NSError {
                                DispatchQueue.main.async {
                                    SVProgressHUD.showError(withStatus: "An Error occurred.\n\(error)")
                                    SVProgressHUD.dismiss(withDelay: 3)
                                }
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                SVProgressHUD.showError(withStatus: "An Error occurred.")
                                SVProgressHUD.dismiss(withDelay: 3)
                            }
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Remarks", style: .default, handler: { (_) in
                    
                }))
                if session.getUser()?.Name == cell.inCharge.text {
                    alert.addAction(UIAlertAction(title: "Mark as Completed", style: .default, handler: { (_) in
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Request Extension", style: .destructive, handler: { (_) in
                        
                    }))
                }else{
                    alert.addAction(UIAlertAction(title: "Notify " + cell.inCharge.text!, style: .default, handler: { (_) in
                        
                    }))
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! itemCell
        itemTransform = cell.item.transform
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            cell.item.transform = .init(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! itemCell
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            cell.item.transform = self.itemTransform
        }, completion: nil)
    }
    
    //MARK: - DELEGATE: EKEVENTVIEW
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        switch action {
        case .done:
            controller.dismiss(animated: true, completion: nil)
        case .deleted:
            DispatchQueue.main.async {
                SVProgressHUD.showSuccess(withStatus: "Deleted")
                SVProgressHUD.dismiss(withDelay: 3)
            }
            controller.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    //MARK: - SETUP
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
        
        refreshIndicator.frame.origin.x = heading.frame.maxX
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
    }
       
    //MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate()
        layout()
        refreshList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        plans.transform = .init(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
            self.heading.center.y = (self.view.safeAreaInsets.top + (self.plans.frame.origin.y - self.view.safeAreaInsets.top) / 2) - 7
            self.userMenu.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.plans.transform = .identity
                self.plans.alpha = 1
            }, completion: nil)
        })
        refreshIndicator.center.y = heading.center.y
        initialPlanY = plans.frame.origin.y
        session.mainVC = self
    }

}

