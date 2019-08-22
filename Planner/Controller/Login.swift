//
//  Login.swift
//  Planner
//
//  Created by Scarlet on A2019/A/18.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit
import LocalAuthentication

class Login: UIViewController, NetworkDelegate{
    
    //MARK: VARIABLE
    let network = Network()
    
    //MARK: IBOUTLET
    @IBOutlet weak var ac: UITextField!
    @IBOutlet weak var pw: UITextField!
    @IBOutlet weak var bioLock: UIButton!
    
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
        DispatchQueue.main.async {
            SVProgressHUD.show()
            self.ac.isEnabled = false
            self.pw.isEnabled = false
        }
        network.send(url: baseURL + "login.php", method: "POST", query: query)
        
    }
    @IBAction func bioLogin(_ sender: UIButton) {
        Authenticate { (success) in
            if success{
                DispatchQueue.main.async {
                    SVProgressHUD.show()
                    self.ac.isEnabled = false
                    self.pw.isEnabled = false
                }
                self.network.send(url: baseURL + "login.php?SID=\(defaults.integer(forKey: "SID"))", method: "BIO", query: nil)
            }
        }
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
                        self.ac.isEnabled = true
                        self.pw.isEnabled = true
                    }
                }
            }else if (item["Result"] as! String) == "Fail"{
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.ac.isEnabled = true
                    self.pw.isEnabled = true
                    self.ac.becomeFirstResponder()
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
    func errorMessage(errorCode:Int) -> String{
        
        var strMessage = ""
        
        switch errorCode {
            
        case LAError.Code.authenticationFailed.rawValue:
            strMessage = "Authentication Failed"
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "User Cancel"
            
        case LAError.Code.systemCancel.rawValue:
            strMessage = "System Cancel"
            
        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.biometryNotAvailable.rawValue:
            strMessage = "TouchI or FaceID DNot Available"
            
        case LAError.Code.biometryNotEnrolled.rawValue:
            strMessage = "TouchID or FaceID Not Enrolled"
            
        case LAError.Code.biometryLockout.rawValue:
            strMessage = "TouchID or FaceID Lockout Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "App Cancel"
            
        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"
            
        default:
            strMessage = ""
            
        }
        return strMessage
    }
    
    func Authenticate(completion: @escaping ((Bool) -> ())){
        
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?
        
        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if isValidSensor {
            //Device have BiometricSensor
            //It Supports TouchID
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Touch / Face ID authentication",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        // Touch / Face ID recognized success here
                        completion(true)
                    } else {
                        //If not recognized then
                        if let error = error {
                            let strMessage = self.errorMessage(errorCode: error._code)
                            if strMessage != ""{
                                
                            }
                        }
                        completion(false)
                    }
            })
        } else {
            
            let strMessage = self.errorMessage(errorCode: (error?._code)!)
            if strMessage != ""{
                
            }
        }
        
    }
    
    func delegate(){
        network.delegate = self
    }
    
    func layout(){
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
    }
    
    func setup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKb))
        view.addGestureRecognizer(tap)
        defaults.bool(forKey: "useBio") ? (bioLock.isEnabled = true) : (bioLock.isEnabled = false)
        if defaults.bool(forKey: "useBio"){
            bioLogin(bioLock)
        }
    }
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad(){
        super.viewDidLoad()
        
        delegate()
        
        layout()
        
        setup()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.bool(forKey: "useBio") ? (bioLock.isEnabled = true) : (bioLock.isEnabled = false)
    }
    
}
