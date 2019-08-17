//
//  Session.swift
//  Planner
//
//  Created by Scarlet on A2019/A/18.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class Session: NSObject{
    
    static let shared = Session()
    
    fileprivate var projects: [Project]?
    func getProjects()->[Project]?{
        return projects
    }
    func setProjects(with value: [NSDictionary]){
        var projs = [Project]()
        projs.removeAll()
        for item in value{
            let proj = Project()
            proj.parse(item)
            projs.append(proj)
        }
        projects = projs
    }
    
}
