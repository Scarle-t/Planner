//
//  UserSettingsTable.swift
//  Planner
//
//  Created by Scarlet on A2019/A/21.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class UserSettingsTable: UITableViewController{
    
    //MARK: VARIABLE
    
    
    //MARK: IBOUTLET
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var version: UILabel!
    
    //MARK: IBACTION
    
    
    //MARK: DELEGATION
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0{
            let alert = UIAlertController(title: "Are you sure you want to logout?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
                session.clearUser()
                self.dismiss(animated: true){
                    session.mainVC.dismiss(animated: false, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: OBJC FUNC
    
    
    //MARK: FUNC
    func delegate(){
        
    }
    
    func layout(){
        
    }
    
    func setup(){
        name.text = session.getUser()?.Name
        version.text = "Aquori Multimedia Production\n" + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) + " (" + (Bundle.main.infoDictionary!["CFBundleVersion"] as! String) + ")"
    }
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad(){
        super.viewDidLoad()
        
        delegate()
        
        layout()
        
        setup()
        
    }
    
}
