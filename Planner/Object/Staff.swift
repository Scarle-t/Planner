//
//  Staff.swift
//  Planner
//
//  Created by Scarlet on A2019/A/18.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import Foundation

class Staff: NSObject{
    
    //MARK: ATTRIBUTE
    var SID: Int
    var Name: String
    
    //MARK: INIT
    override init(){
        SID = 0
        Name = ""
    }
    
    //MARK: PARSE
    func parse(_ data: NSDictionary){
        SID = Int(data["SID"] as! String)!
        Name = data["Name"] as! String
    }
    
}
