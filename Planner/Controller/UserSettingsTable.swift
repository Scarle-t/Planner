//
//  UserSettingsTable.swift
//  Planner
//
//  Created by Scarlet on A2019/A/21.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class UserSettingsTable: UITableViewController{
    
    //MARK: - VARIABLE
    var popRecognizer: InteractivePopRecognizer!
    
    //MARK: - IBOUTLET
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var version: UILabel!
    
    //MARK: - IBACTION
    
    
    //MARK: - DELEGATION
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0{
            let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
                session.clearProjects()
                session.clearUser()
                self.dismiss(animated: true){
                    session.mainVC.dismiss(animated: false, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0{
            let footerView = UIView()
            let border = UIView(frame: CGRect(x: 0, y: footerView.frame.height + 20, width: tableView.frame.width - (tableView.separatorInset.left * 2), height: 1))
            border.backgroundColor = .systemTeal
            border.alpha = 0.4
            footerView.addSubview(border)
            return footerView
        }
        return nil
    }
    
    //MARK: - OBJC FUNC
    
    
    //MARK: - FUNC
    func delegate(){
        popRecognizer = InteractivePopRecognizer(controller: self.navigationController!)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    func layout(){
        
    }
    
    func setup(){
        name.text = session.getUser()?.Name
        version.text = "Aquori Multimedia Production\n" + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) + " (" + (Bundle.main.infoDictionary!["CFBundleVersion"] as! String) + ")"
    }
    
    //MARK: - VIEW CONTROLLER
    override func viewDidLoad(){
        super.viewDidLoad()
        
        delegate()
        
        layout()
        
        setup()
        
    }
    
}
