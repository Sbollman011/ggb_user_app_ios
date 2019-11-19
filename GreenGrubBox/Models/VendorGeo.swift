
import Foundation
 

public class Geo {
	public var coordinates : [Double] = []
	public var type : String = "1"

    public class func modelsFromDictionaryArray(array:NSArray) -> [Geo]
    {
        var models:[Geo] = []
        for item in array
        {
            models.append(Geo(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		if (dictionary["coordinates"] != nil) {
 coordinates = (dictionary["coordinates"] as! [Double]
            )
            
            
            
        }
        type = (dictionary["type"] as? String)!
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.type, forKey: "type")
       dictionary.setValue(self.coordinates, forKey: "type")
		return dictionary
	}

}
