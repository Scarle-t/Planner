//
//  Login.swift
//  Planner
//
//  Created by Scarlet on A2019/A/18.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class Login: UIViewController, NetworkDelegate{
    
    //MARK: VARIABLE
    let network = Network()
    
    //MARK: IBOUTLET
    @IBOutlet weak var ac: UITextField!
    @IBOutlet weak var pw: UITextField!
    
    //MARK: IBACTION
    @IBAction func login(_ sender: UIButton) {
        guard let acText = ac.text, var pwText = pw.text else {
            SVProgressHUD.showError(withStatus: nil)
            SVProgressHUD.dismiss(withDelay: 3)
            return
        }
        
        pwText = pwText.sha1()
        
        var query: String? = "login=\(acText)&pwd=\(pwText)"
        query = query?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        SVProgressHUD.show()
        network.send(url: baseURL + "login.php", method: "POST", query: query)
        
    }
    
    
    //MARK: DELEGATION
    func ResponseHandle(data: Data) {
        let response = json.parse(data)!
        
        for item in response{
            if (item["Result"] as! String) == "OK"{
                session.setUser(with: item)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    let plan = self.storyboard?.instantiateViewController(withIdentifier: "plan") as! ViewController
                    
                    plan.modalPresentationStyle = .fullScreen
                    self.present(plan, animated: false){
                        self.ac.text = ""
                        self.pw.text = ""
                    }
                }
            }else if (item["Result"] as! String) == "Fail"{
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: item["Reason"] as? String)
                    SVProgressHUD.dismiss(withDelay: 3)
                }
            }
        }
        
    }
    
    //MARK: OBJC FUNC
    @objc func dismissKb(){
        view.endEditing(true)
    }
    
    //MARK: FUNC
    func delegate(){
        network.delegate = self
    }
    
    func layout(){
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
    }
    
    func setup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKb))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad(){
        super.viewDidLoad()
        
        delegate()
        
        layout()
        
        setup()
        
    }
    
}
