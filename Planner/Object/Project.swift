//
//  Project.swift
//  Planner
//
//  Created by Scarlet on A2019/A/18.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import Foundation

class Project: NSObject{
    
    //MARK: ATTRIBUTE
    var PID: Int
    var title: String
    var author: String
    
    //MARK: INIT
    override init(){
        PID = 0
        title = ""
        author = ""
    }
    
    //MARK: PARSE
    func parse(_ data: NSDictionary){
        PID = Int(data["PID"] as! String)!
        title = data["Title"] as! String
        author = data["Author"] as! String
    }
    
}
