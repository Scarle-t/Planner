//
//  Dat.swift
//  Planner
//
//  Created by Scarlet on A2019/S/1.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import Foundation

class Date: NSObject{
    
    //MARK: - ATTRIBUTE
    var day: Int
    var month: Int
    var year: Int
    
    //MARK: - INIT
    override init(){
        day = 0
        month = 0
        year = 0
    }
    
    //MARK: - FUNCTION
    func getStringFormat(shortForm: Bool)->String{
        return shortForm ? ("\(day)/\(month)") : ("\(day)/\(month)/\(year)")
    }
    
    func getDateFormat()->Foundation.Date{
        let sdFormat = DateFormatter()
        sdFormat.dateFormat = "yyyy/MM/dd"
        return sdFormat.date(from: "\(year)/\(month)/\(day)")!
    }
    
}
