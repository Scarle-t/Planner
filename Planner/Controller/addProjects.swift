//
//  addProjects.swift
//  Planner
//
//  Created by Scarlet on A2019/A/23.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class addProjects: UITableViewController, NetworkDelegate{
    
    //MARK: - VARIABLE
    let network = Network()
    
    var sdPicker = UIDatePicker()
    var ddPicker = UIDatePicker()
    
    //MARK: - IBOUTLET
    @IBOutlet weak var projTitle: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var dueDate: UITextField!
    
    
    //MARK: - IBACTION
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: UIBarButtonItem) {
        guard let t = projTitle.text, let d = desc.text, let sd = startDate.text, let dd = dueDate.text, t != "", d != "", sd != "", dd != "" else {return}
        
        var query = "title=\(t)&details=\(d)&startDate=\(sd)&dueDate=\(dd)&SID=\(session.getUser()!.SID)"
        query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        network.send(url: baseURL + "projects.php", method: "POST", query: query)
    }
    
    //MARK: - DELEGATION
    func ResponseHandle(data: Data) {
        guard let result = json.parse(data) else {return}
        DispatchQueue.main.async {
            for item in result{
                if (item["Result"] as! String) == "OK"{
                    SVProgressHUD.showSuccess(withStatus: "Received")
                    SVProgressHUD.dismiss(withDelay: 3)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    SVProgressHUD.showError(withStatus: "An error occurred.\n\(item["Reason"] as! String)")
                    SVProgressHUD.dismiss(withDelay: 3)
                }
            }
        }
    }
    
    //MARK: - OBJC FUNC
    @objc func setDate(_ sender: UIDatePicker){
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        let day = components.day!
        let month = components.month!
        let year = components.year!
        switch sender.tag{
        case 0:
            startDate.text = "\(year)-\(month)-\(day)"
        case 1:
            dueDate.text = "\(year)-\(month)-\(day)"
        default:
            break
        }
    }
    
    //MARK: - FUNC
    func delegate(){
        network.delegate = self
    }
    
    func layout(){
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        self.navigationController?.navigationBar.barTintColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
    }
    
    func setup(){
        sdPicker.datePickerMode = .date
        ddPicker.datePickerMode = .date
        sdPicker.tag = 0
        ddPicker.tag = 1
        sdPicker.addTarget(self, action: #selector(setDate(_:)), for: .valueChanged)
        ddPicker.addTarget(self, action: #selector(setDate(_:)), for: .valueChanged)
        startDate.inputView = sdPicker
        dueDate.inputView = ddPicker
    }
    
    //MARK: - VIEW CONTROLLER
    override func viewDidLoad(){
        super.viewDidLoad()
        
        delegate()
        
        layout()
        
        setup()
        
    }
    
}
