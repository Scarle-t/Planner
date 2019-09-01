//
//  Item.swift
//  Planner
//
//  Created by Scarlet on A2019/A/18.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import Foundation

class Item: NSObject{
    
    //MARK: - ATTRIBUTE
    var IID: Int
    var type: String
    var content: String
    var inCharge: String
    
    var startDate: Date
    var dueDate: Date
    
    //MARK: - INIT
    override init(){
        IID = 0
        type = ""
        content = ""
        inCharge = ""
        startDate = Date()
        dueDate = Date()
    }
    
    //MARK: - PARSE
    func parse(_ data: NSDictionary){
        IID = Int(data["IID"] as! String)!
        type = data["type"] as! String
        content = data["Content"] as! String
        inCharge = data["inCharge"] as! String
        startDate.day = Int(data["Start_date_Day"] as! String)!
        startDate.month = Int(data["Start_date_Month"] as! String)!
        startDate.year = Int(data["Start_date_Year"] as! String)!
        dueDate.day = Int(data["Due_date_Day"] as! String)!
        dueDate.month = Int(data["Due_date_Month"] as! String)!
        dueDate.year = Int(data["Due_date_Year"] as! String)!
    }
    
}
