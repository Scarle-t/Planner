//
//  UserSettings.swift
//  Planner
//
//  Created by Scarlet on A2019/A/21.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class UserSettings: UIViewController{
    
    //MARK: VARIABLE
    
    
    //MARK: IBOUTLET
    
    
    //MARK: IBACTION
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: DELEGATION
    
    
    //MARK: OBJC FUNC
    
    
    //MARK: FUNC
    func delegate(){
        
    }
    
    func layout(){
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
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
