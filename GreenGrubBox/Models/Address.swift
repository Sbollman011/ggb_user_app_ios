/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Address {
    
    public var formattedAddress : String = ""
	public var zipcode : String = ""
	public var countryCode : String = ""
	public var country : String = ""
	public var stateCode : String = ""
	public var state : String = ""
	public var city : String = ""

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let address_list = Address.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Address Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Address]
    {
        var models:[Address] = []
        for item in array
        {
            models.append(Address(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let address = Address(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Address Instance.
*/
	required public init?(dictionary: NSDictionary) {

        zipcode = (dictionary["zipcode"] as? String)!
        countryCode = (dictionary["countryCode"] as? String)!
        country = (dictionary["country"] as? String)!
        stateCode = (dictionary["stateCode"] as? String)!
        state = (dictionary["state"] as? String)!
        city = (dictionary["city"] as? String)!
        
        if dictionary["formattedAddress"] != nil {
        
        formattedAddress =  (dictionary["formattedAddress"] as? String)!
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.zipcode, forKey: "zipcode")
		dictionary.setValue(self.countryCode, forKey: "countryCode")
		dictionary.setValue(self.country, forKey: "country")
		dictionary.setValue(self.stateCode, forKey: "stateCode")
		dictionary.setValue(self.state, forKey: "state")
		dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.formattedAddress, forKey: "formattedAddress")
		return dictionary
	}

}
