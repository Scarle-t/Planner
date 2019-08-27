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
    
    //MARK: - INIT
    override init(){
        IID = 0
        type = ""
        content = ""
    }
    
    //MARK: - PARSE
    func parse(_ data: NSDictionary){
        IID = Int(data["IID"] as! String)!
        type = data["type"] as! String
        content = data["Content"] as! String
    }
    
}
