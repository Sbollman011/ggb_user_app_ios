

import Foundation
 

public class Data_Box {
	public var _id : String?
	public var boxId : String?
	public var status : Int?
	public var boxIcon : String?
    public var boxPrefix : String?
    public var boxPrice: Int?
    public var boxTitle : String?
    public var boxType : String?
    public var inventoryTime: String?
    public var userCheckOutTime : String?
    public var vendorName : String?
      public var returnInventory : Bool?
    
    
    /*{
     "_id" = 5a7464ef6c07230cba87dda2;
     boxIcon = "https://static.pexels.com/photos/248797/pexels-photo-248797.jpeg";
     boxId = C000004;
     boxPrefix = C;
     boxPrice = 1;
     boxTitle = "Soup_Container";
     boxType = " Cool_Cup";
     inventoryTime = "1 hr ago";
     status = 2;
     userCheckOutTime = "12 secs ago";
     vendorName = Ted;
     }*/
    
    
    
    
    

    public class func modelsFromDictionaryArray(array:NSArray) -> [Data_Box]
    {
        var models:[Data_Box] = []
        for item in array
        {
            models.append(Data_Box(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    

	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		status = dictionary["status"] as? Int
        boxId  = dictionary["boxId"] as? String
        boxIcon = dictionary["boxIcon"] as? String
        boxPrefix = dictionary["boxPrefix"] as? String
        boxPrice = dictionary["boxPrice"] as? Int
        boxTitle = dictionary["boxTitle"] as? String
        boxType = dictionary["boxType"] as? String
        inventoryTime = dictionary["inventoryTime"] as? String
        userCheckOutTime = dictionary["userCheckOutTime"] as? String
        vendorName = dictionary["vendorName"] as? String
        returnInventory = dictionary["returnInventory"] as? Bool
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.status, forKey: "status")
		

        dictionary.setValue(self.boxId, forKey: "boxId")

        dictionary.setValue(self.boxIcon, forKey: "boxIcon")


        dictionary.setValue(self.boxPrefix, forKey: "boxPrefix")

        dictionary.setValue(self.boxPrice, forKey: "boxPrice")

    
        dictionary.setValue(self.boxTitle, forKey: "boxTitle")


        dictionary.setValue(self.boxType, forKey: "boxType")

        dictionary.setValue(self.inventoryTime, forKey: "inventoryTime")

     
        dictionary.setValue(self.userCheckOutTime, forKey: "userCheckOutTime")

       
        dictionary.setValue(self.vendorName, forKey: "vendorName")

         dictionary.setValue(self.returnInventory, forKey: "vendorName")
        
        
        
        
        
        
        
        
        
		return dictionary
	}

}
