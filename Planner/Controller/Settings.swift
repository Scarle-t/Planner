//
//  Settings.swift
//  Planner
//
//  Created by Scarlet on A2019/A/21.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class Settings: UITableViewController{
    
    //MARK: - VARIABLE
    
    
    //MARK: - IBOUTLET
    @IBOutlet weak var toggleBio: UISwitch!
    
    //MARK: - IBACTION
    @IBAction func bioSwitch(_ sender: UISwitch) {
        if sender.isOn{
            defaults.set(session.getUser()!.SID, forKey: "SID")
            defaults.set(true, forKey: "useBio")
        }else{
            defaults.removeObject(forKey: "SID")
            defaults.set(false, forKey: "useBio")
        }
    }
    @IBAction func close(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - DELEGATION
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0{
            if !toggleBio.isEnabled{
                return "Another user has registered biometrics."
            }
        }
        return nil
    }
    
    //MARK: - OBJC FUNC
    
    
    //MARK: - FUNC
    func delegate(){
        
    }
    
    func layout(){
        if defaults.integer(forKey: "SID") != 0{
            if defaults.integer(forKey: "SID") == session.getUser()!.SID {
                toggleBio.setOn(defaults.bool(forKey: "useBio"), animated: false)
            }else{
                toggleBio.isEnabled = false
            }
        }else{
            toggleBio.setOn(false, animated: false)
        }
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
    }
    
    func setup(){
        
    }
    
    //MARK: - VIEW CONTROLLER
    override func viewDidLoad(){
        super.viewDidLoad()
        
        delegate()
        
        layout()
        
        setup()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        layout()
    }
    
}
