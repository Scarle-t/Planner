//
//  Project.swift
//  Planner
//
//  Created by Scarlet on A2019/A/18.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import Foundation

class Project: NSObject{
    
    //MARK: - ATTRIBUTE
    var PID: Int
    var title: String
    var details: String
    var author: String
    var status: String
    var items: [Item]?
    
    //MARK: - INIT
    override init(){
        PID = 0
        title = ""
        details = ""
        author = ""
        status = ""
    }
    
    //MARK: - PARSE
    func parse(_ data: NSDictionary){
        PID = Int(data["PID"] as! String)!
        title = data["Title"] as! String
        details = data["Details"] as! String
        author = data["Author"] as! String
        status = data["status"] as! String
    }
    
}
