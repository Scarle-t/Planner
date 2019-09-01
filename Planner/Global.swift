//
//  Global.swift
//  Planner
//
//  Created by Scarlet on A2019/A/18.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import Foundation

let baseURL = "https://api.scarletsc.net/aquori/"
/// Session.shared
let session = Session.shared
let defaults = UserDefaults.standard
let json = JSONParser()
let startColors: [CGColor] = [
    "ADFFF9".uiColor.cgColor,
    "C6FFAD".uiColor.cgColor,
    "FCFFAD".uiColor.cgColor,
    "FFD0AD".uiColor.cgColor,
]
let endColors: [CGColor] = [
    "7CD5EA".uiColor.cgColor,
    "7CEAAB".uiColor.cgColor,
    "EACC7C".uiColor.cgColor,
    "EA7C7C".uiColor.cgColor,
]


/// Populate Plan Cell with Project Data
/// - Parameter cell: The current cell for data population.
/// - Parameter project: The Project object  data source.
/// - Parameter showAuthor: Default: True. Flag for controlling cell display author name or project status.
func populatePlanCell(cell: planCell, item project: Project, showAuthor isAuthor: Bool = true){
    cell.layer.masksToBounds = true
    cell.layer.cornerRadius = 17
    
    cell.itemList.allowsSelection = false
    cell.itemList.tag = -1
    cell.itemList.reloadData()
    
    let gradLayer = CAGradientLayer()
    gradLayer.frame = cell.bounds
    let startColor = startColors[project.PID - 1 % startColors.count]
    let endColor = endColors[project.PID - 1 % endColors.count]
    gradLayer.colors = [startColor, endColor]
    cell.gradView.layer.addSublayer(gradLayer)
    
    Network().send(url: baseURL + "items.php?PID=\(project.PID)", method: "GET", query: nil) { (data) in
        guard let d = data else {return}
        let result = json.parse(d)!
        var items = [Item]()
        items.removeAll()
        for item in result{
            let i = Item()
            i.parse(item)
            items.append(i)
        }
        project.items = items
        project.sortItems()
        DispatchQueue.main.async {
            cell.itemList.reloadData()
        }
    }
    
    cell.planTitle.text = project.title
    cell.author.text = isAuthor ? project.author : ("Status: " + project.status)
    cell.details.text = project.details
    cell.dueDate.text = "Due: " + project.dueDate.getStringFormat(shortForm: false)
}
