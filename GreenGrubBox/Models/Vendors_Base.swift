

import Foundation
/*{
 "_id": "5a796d0c55f0770aac18d8d4",
 "mobile": 7799885522,
 "businessName": "Restaurant",
 "password": "$2a$10$Zr8QVO5.XLWo.uHOMWy1nO4vo6PtNkqEpNRAbsWB1F4Phmjku3.lS",
 "email": "sanket@gmail.com",
 "updatedAt": 1517901237727,
 "createdAt": 1517901237727,
 "status": 1,
 "isProfileCompleted": false,
 "address": {
 "zipcode": "",
 "countryCode": "",
 "country": "",
 "stateCode": "",
 "state": "",
 "city": ""
 },
 "vendorGeo": {
 "coordinates": [
 0,
 0
 ],
 "type": "Point"
 },
 "vendorIcon": "https://s3.us-east-2.amazonaws.com/waterfront-concerts/img-1517815761083.jpg",
 "rating": 5,
 "category": "This is for ",
 "description": "This is vendor2 description",
 "__v": 0,
 "type": 1
 }*/

public class Vendors_Base {
    public var  miles : String =  ""
    public var  Images : [String] =  []
	public var _id : String =  ""
	public var mobile : String = ""
	public var businessName : String = ""
    public var Name : String = ""
	public var password : String = ""
	public var email : String = ""
	public var updatedAt : Int64 = 0
	public var createdAt : Int64 = 0
	public var status : Int = 0
	public var isProfileCompleted : Bool?
	public var address : Address?
	public var geo : Geo?
    public var  dropBoxIcon : String = ""
	public var vendorIcon : String = ""
	public var __v : Int = 0
    public var rating : Float = 0.0
    public var category : String = ""
    public var description: String = ""
    public var type : Int = 0
  public var webLink : String = ""
    public var yelpLink: String = ""
    public class func modelsFromDictionaryArray(array:NSArray) -> [Vendors_Base]
    {
        var models:[Vendors_Base] = []
        for item in array
        {
            models.append(Vendors_Base(dictionary: item as! NSDictionary)!)
        }
        return models
    }
	required public init?(dictionary: NSDictionary) {
         if (dictionary["_id"] != nil) {
        _id = (dictionary["_id"] as? String)!
            
        }
        
        
        if (dictionary["yelpLink"] != nil) {
            yelpLink = (dictionary["yelpLink"] as? String)!
            
        }
        
        
        if (dictionary["webLink"] != nil) {
            webLink = (dictionary["webLink"] as? String)!
            
        }
        
        if (dictionary["images"] != nil) {
            
            if dictionary["images"] is [String]{
                 Images = (dictionary["images"] as? [String])!
            }
        }
        
        if (dictionary["miles"] != nil) {
            miles = (dictionary["miles"] as? String)!
        }
        
        
        if (dictionary["mobile"] != nil) {
            if let mobileInt = (dictionary["mobile"] as? String) {
                mobile = mobileInt
            }
            
            
            /*else{
                let mobileString:String? = (dictionary["mobile"] as! NSNumber).debugDescription
                let myTest : String = "45566441411222"
                let optionalString: String? = "4255919377"
                if let string = mobileString, let myInt = Int64(string){
                    print("Int : \(myInt)")
                    mobile = myInt
                }
               //let demo  =  myTest.toI
                // mobile = demo
            }*/
        //mobile = (dictionary["mobile"] as? Int)!
        }
        print(mobile)
            if (dictionary["businessName"] != nil) {
                businessName = (dictionary["businessName"] as? String)!
        }
        if (dictionary["name"] != nil) {
           Name = (dictionary["name"] as? String)!
        }
        
          if (dictionary["password"] != nil) {
        password = (dictionary["password"] as? String)!
            
        }
         if (dictionary["email"] != nil) {
        email = (dictionary["email"] as? String)!
        }
        if (dictionary["updatedAt"] != nil) {
            if let updateInt = (dictionary["updatedAt"] as? Int64) {
              updatedAt = updateInt
            }
            
        
        }
        if (dictionary["createdAt"] != nil) {
            if let updateInt = (dictionary["createdAt"] as? Int64) {
                createdAt = updateInt
            } 
       // createdAt = (dictionary["createdAt"] as? Int)!
        }
        if (dictionary["status"] != nil) {
        status = (dictionary["status"] as? Int)!
        }
            if (dictionary["isProfileCompleted"] != nil) {
		isProfileCompleted = dictionary["isProfileCompleted"] as? Bool
            }
		if (dictionary["address"] != nil) { address = Address(dictionary: dictionary["address"] as! NSDictionary) }
		if (dictionary["geo"] != nil) {
            geo = Geo(dictionary: dictionary["geo"] as! NSDictionary)
            
        }
        if (dictionary["vendorIcon"] != nil) {
        vendorIcon = (dictionary["vendorIcon"] as? String)!
        }
        
        
        
        if (dictionary["dropBoxIcon"] != nil) {
            dropBoxIcon = (dictionary["dropBoxIcon"] as? String)!
        }
         if (dictionary["__v"] != nil) {
        __v = (dictionary["__v"] as? Int)!
        }
        
          if (dictionary["rating"] != nil) {
            if dictionary["rating"] is Float {
             rating  = (dictionary["rating"] as? Float)!
            }
            if dictionary["rating"] is Int {
                 let r: Int  = (dictionary["rating"] as? Int)!
                rating = Float(r)
            }
        }
              if (dictionary["category"] != nil) {
        category = (dictionary["category"] as? String)!
            }
                  if (dictionary["description"] != nil) {
        description = (dictionary["description"] as? String)!
                }
        
         if (dictionary["type"] != nil) {
        type = (dictionary["type"] as? Int)!
        }
	}
	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.mobile, forKey: "mobile")
		dictionary.setValue(self.businessName, forKey: "businessName")
        dictionary.setValue(self.Name, forKey: "name")
		dictionary.setValue(self.password, forKey: "password")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.updatedAt, forKey: "updatedAt")
		dictionary.setValue(self.createdAt, forKey: "createdAt")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.isProfileCompleted, forKey: "isProfileCompleted")
		dictionary.setValue(self.address?.dictionaryRepresentation(), forKey: "address")
		dictionary.setValue(self.geo?.dictionaryRepresentation(), forKey: "vendorGeo")
		dictionary.setValue(self.vendorIcon, forKey: "vendorIcon")
        dictionary.setValue(self.Images, forKey: "images")
        dictionary.setValue(self.miles, forKey: "miles")
	    dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.category, forKey: "category")
        dictionary.setValue(self.rating, forKey: "rating")
        dictionary.setValue(self.dropBoxIcon, forKey: "dropBoxIcon")
        dictionary.setValue(self.webLink, forKey: "webLink")
        dictionary.setValue(self.yelpLink, forKey: "webLink")
        
		return dictionary
	}
}
