//
//  Network.swift
//  fyp
//
//  Created by Scarlet on 16/4/2019.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

protocol NetworkDelegate: class{
    func reachabilityError()
    func httpErrorHandle(httpStatus: HTTPURLResponse)
    func URLSessionError(error: Error?)
    func ResponseHandle(data: Data)
}

extension NetworkDelegate{
    func httpErrorHandle(httpStatus: HTTPURLResponse){
        SVProgressHUD.showInfo(withStatus: "HTTP Error\n\(httpStatus.statusCode)")
        SVProgressHUD.dismiss(withDelay: 3)
    }
    func reachabilityError(){
        SVProgressHUD.showError(withStatus: "Cannot connect to the Internet.")
        SVProgressHUD.dismiss(withDelay: 3)
    }
    func URLSessionError(error: Error?){
        SVProgressHUD.showInfo(withStatus: "URL Session Error\n\(error ?? Error.self as! Error)")
        SVProgressHUD.dismiss(withDelay: 3)
    }
}

class Network: NSObject{
    
    weak var delegate: NetworkDelegate?
    
    func send(url action: String, method: String, query content: String?){
        
        if Reachability().isConnectedToNetwork(){
            var request = URLRequest(url: URL(string: action)!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = method
            if let content = content{
                request.httpBody = content.data(using: .utf8)
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    self.delegate?.URLSessionError(error: error)
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    self.delegate?.httpErrorHandle(httpStatus: httpStatus)
                    return
                }
                self.delegate?.ResponseHandle(data: data)
            }
            task.resume()
        }else{
            self.delegate?.reachabilityError()
        }
    }
    
    func send(url action: String, method: String, query content: String?, completion: ((Data?)->())?){
        
        if Reachability().isConnectedToNetwork(){
            var request = URLRequest(url: URL(string: action)!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = method
            if let content = content{
                request.httpBody = content.data(using: .utf8)
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    self.delegate?.URLSessionError(error: error)
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    self.delegate?.httpErrorHandle(httpStatus: httpStatus)
                    return
                }
                completion?(data)
            }
            task.resume()
        }else{
            self.delegate?.reachabilityError()
        }
    }
    
}
