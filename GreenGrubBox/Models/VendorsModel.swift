//
//  VendorsModel.swift
//  GreenGrubBox
//
//  Created by Ankit on 2/2/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import Foundation
import UIKit
public class VendorsModel {
    public var _id : String?
    public var distance : Float?
    public var name : String?
    public var Menu : String?
    public var image : String?
   
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [VendorsModel]
    {
        var models:[VendorsModel] = []
        for item in array
        {
            models.append(VendorsModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary) {
        _id = dictionary["_id"] as? String
        distance = dictionary["distance"] as? Float
        name = dictionary["name"] as? String
        Menu = dictionary["Menu"] as? String
        image = dictionary["image"] as? String
        
        
        
        
        
    }
    
    
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.distance, forKey: "distance")
         dictionary.setValue(self.name, forKey: "name")
        
           dictionary.setValue(self.Menu, forKey: "Menu")
           dictionary.setValue(self.image, forKey: "image")
        return dictionary
    }
    
}
