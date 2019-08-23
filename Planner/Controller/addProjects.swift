//
//  addProjects.swift
//  Planner
//
//  Created by Scarlet on A2019/A/23.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class addProjects: UITableViewController{
    
    //MARK: VARIABLE
    
    
    //MARK: IBOUTLET
    
    
    //MARK: IBACTION
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: DELEGATION
    
    
    //MARK: OBJC FUNC
    
    
    //MARK: FUNC
    func delegate(){
        
    }
    
    func layout(){
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        self.navigationController?.navigationBar.barTintColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
    }
    
    func setup(){
        
    }
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad(){
        super.viewDidLoad()
        
        delegate()
        
        layout()
        
        setup()
        
    }
    
}
