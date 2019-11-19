

import Foundation
 

public class BoxHIstoryModel {
	public var status : Int = 0
	public var data : [Data_Box]?
    public var isMore: Bool = false
  public class func modelsFromDictionaryArray(array:NSArray) -> [BoxHIstoryModel]
    {
        var models:[BoxHIstoryModel] = []
        for item in array
        {
            models.append(BoxHIstoryModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

        status = (dictionary["status"] as? Int)!
        if (dictionary["data"] != nil) {
            data = Data_Box.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray)
            
            
        }
        
        if (dictionary["isMore"] != nil) {
            isMore =  dictionary["isMore"] as! Bool
            
        }
        
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.status, forKey: "status")

		return dictionary
	}

}
