
import Foundation

public class User {
	public var checkOutTime : Int?
	public var _id : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		checkOutTime = dictionary["checkOutTime"] as? Int
		_id = dictionary["_id"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.checkOutTime, forKey: "checkOutTime")
		dictionary.setValue(self._id, forKey: "_id")

		return dictionary
	}

}
