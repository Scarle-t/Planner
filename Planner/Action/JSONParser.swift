//
//  JSONParser.swift
//  fyp
//
//  Created by Scarlet on 16/4/2019.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class JSONParser: NSObject{
    fileprivate var jsonResult = NSArray()
    fileprivate var jsonElement = NSDictionary()
    fileprivate var returnDict = [NSDictionary]()
    
    fileprivate var nestedResult = NSArray()
    fileprivate var nestedElement = [NSDictionary]()
    fileprivate var nestedDict = [[NSDictionary]]()
    
    func parse(_ data: Data) -> [NSDictionary]?{
        returnDict.removeAll()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            let alert = UIAlertController(title: "JSON Parser Error:", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            return nil
        }
        
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            returnDict.append(jsonElement)
        }
        return returnDict
    }
    
    func parseNested(_ data: Data) -> [[NSDictionary]]?{
        nestedDict.removeAll()
        do{
            nestedResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            let alert = UIAlertController(title: "JSON Parser Error:", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            return nil
        }
        
        for i in 0 ..< nestedResult.count
        {
            nestedElement = nestedResult[i] as! [NSDictionary]
            nestedDict.append(nestedElement)
        }
        return nestedDict
    }
}
