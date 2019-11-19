

import Foundation

public class Package_Base {
	public var _id : String?
	public var days : Int?
	public var value : String?
	public var name : String?
	public var updatedAt : Int?
	public var createdAt : Int?
	public var status : Int?
	public var __v : Int?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Package_Base]
    {
        var models:[Package_Base] = []
        for item in array
        {
            models.append(Package_Base(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		days = dictionary["days"] as? Int
		value = dictionary["value"] as? String
		name = dictionary["name"] as? String
		updatedAt = dictionary["updatedAt"] as? Int
		createdAt = dictionary["createdAt"] as? Int
		status = dictionary["status"] as? Int
		__v = dictionary["__v"] as? Int
	}

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
        
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.days, forKey: "days")
		dictionary.setValue(self.value, forKey: "value")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.updatedAt, forKey: "updatedAt")
		dictionary.setValue(self.createdAt, forKey: "createdAt")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.__v, forKey: "__v")

		return dictionary
	}
}
