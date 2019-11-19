
import Foundation

public class AssignStatus {
	public var type : String?
	public var _id : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [AssignStatus]
    {
        var models:[AssignStatus] = []
        for item in array
        {
            models.append(AssignStatus(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		type = dictionary["type"] as? String
		_id = dictionary["_id"] as? String
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self._id, forKey: "_id")

		return dictionary
	}

}
