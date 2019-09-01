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
    
    var startDate: Date
    var dueDate: Date
    
    var almostDue: [Item]?
    var notYetDue: [Item]?
    var past: [Item]?
    
    //MARK: - INIT
    override init(){
        PID = 0
        title = ""
        details = ""
        author = ""
        status = ""
        startDate = Date()
        dueDate = Date()
    }
    
    //MARK: - PARSE
    func parse(_ data: NSDictionary){
        PID = Int(data["PID"] as! String)!
        title = data["Title"] as! String
        details = data["Details"] as! String
        author = data["Author"] as! String
        status = data["status"] as! String
        startDate.day = Int(data["Start_date_Day"] as! String)!
        startDate.month = Int(data["Start_date_Month"] as! String)!
        startDate.year = Int(data["Start_date_Year"] as! String)!
        dueDate.day = Int(data["Due_date_Day"] as! String)!
        dueDate.month = Int(data["Due_date_Month"] as! String)!
        dueDate.year = Int(data["Due_date_Year"] as! String)!
    }
    
    func sortItems(){
        guard let items = items else {return}
        var aD = [Item]()
        var nYD = [Item]()
        var p = [Item]()
        
        for item in items{
            let date = Foundation.Date()
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            
            let yearDiff = (item.dueDate.year - year) * 365
            let monthDiff = (item.dueDate.month - month) * 30
            let dayDiff = item.dueDate.day - day
            
            let totalDiff = yearDiff + monthDiff + dayDiff
            
            if totalDiff < 0{
                p.append(item)
            }else if totalDiff >= 0 && totalDiff <= 14{
                aD.append(item)
            }else{
                nYD.append(item)
            }
        }
        almostDue = aD
        notYetDue = nYD
        past = p
    }
    
}
