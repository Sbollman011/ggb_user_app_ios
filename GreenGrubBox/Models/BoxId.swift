
import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class BoxId {
	public var _id : String?
	public var boxId : String?
	public var boxType : String?
	public var updatedAt : Int?
	public var createdAt : Int?
	public var status : Int?
	public var assignStatus : AssignStatus?
	public var __v : Int?


    public class func modelsFromDictionaryArray(array:NSArray) -> [BoxId]
    {
        var models:[BoxId] = []
        for item in array
        {
            models.append(BoxId(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		boxId = dictionary["boxId"] as? String
		boxType = dictionary["boxType"] as? String
		updatedAt = dictionary["updatedAt"] as? Int
		createdAt = dictionary["createdAt"] as? Int
		status = dictionary["status"] as? Int
		if (dictionary["assignStatus"] != nil) { assignStatus = AssignStatus(dictionary: dictionary["assignStatus"] as! NSDictionary) }
		__v = dictionary["__v"] as? Int
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.boxId, forKey: "boxId")
		dictionary.setValue(self.boxType, forKey: "boxType")
		dictionary.setValue(self.updatedAt, forKey: "updatedAt")
		dictionary.setValue(self.createdAt, forKey: "createdAt")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.assignStatus?.dictionaryRepresentation(), forKey: "assignStatus")
		dictionary.setValue(self.__v, forKey: "__v")

		return dictionary
	}

}
