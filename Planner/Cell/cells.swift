//
//  cells.swift
//  Planner
//
//  Created by Scarlet on A2019/A/14.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

//MARK: - planCell
class planCell: UICollectionViewCell{
    @IBOutlet weak var planTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var gradView: UIView!
    @IBOutlet weak var itemList: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var dueDate: UILabel!
}

class itemCell: UITableViewCell{
    @IBOutlet weak var inCharge: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var item: UILabel!
}
