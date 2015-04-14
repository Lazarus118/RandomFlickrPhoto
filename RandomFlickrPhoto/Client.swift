//
//  Client.swift
//  RandomFlickrPhoto
//
//  Created by Dr. Paul R. Zahrl on 03/04/15.
//  Copyright (c) 2015 Dr. Paul R. Zahrl. All rights reserved.
//

import UIKit

class Client: NSObject {

    let URLSession = NSURLSession.sharedSession()
    
    func fetchImageForUserID(userID: String, completionHandler:(success: Bool, photoTitle: String, photoData: NSData?, errorString: String?) -> Void) {
        
        // Array of method arguments
        let methodArguments = [
            ArgumentKeys.METHOD: Methods.GET_PUBLIC_PHOTOS,
            ArgumentKeys.API_KEY: Constants.API_KEY,
            ArgumentKeys.USER_ID: userID,
            ArgumentKeys.EXTRAS: Constants.EXTRAS,
            ArgumentKeys.FORMAT: Constants.DATA_FORMAT,
            ArgumentKeys.NO_JSON_CALLBACK: Constants.NO_JSON_CALLBACK
        ]

        // Initialize session and URL
        let URL = NSURL(string: Constants.BASE_URL + escapeArguments(methodArguments))
        let request = NSURLRequest(URL: URL!)
        
        // Initialize GET task
        let task = URLSession.dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let error = error? {
                println("Error \(error)")
            } else {
                var parsingError: NSError? = nil
                
                /* Sample JSON response:
                { "photos":
                { "page": 1,
                "pages": 1,
                "perpage": 100,
                "total": 1,
                "photo":
                [
                { "id": "16990141301", "owner": "132115085@N04", "secret": "c778c07777", "server": "7592", "farm": 8, "title": "Ice cream in Rome", "ispublic": 1, "isfriend": 0, "isfamily": 0, "url_m": "https:\/\/farm8.staticflickr.com\/7592\/16990141301_c778c07777.jpg", "height_m": "500", "width_m": "375" }
                ]
                },
                "stat": "ok"
                }
                */
                
                /* JSON response for wrong user:
                { "stat": "fail",
                "code": 1,
                "message": "User not found" } */
                
                // Parse data: JSON serialization of received data
                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
                
                // Convert JSON Object photos to Swift dictionary
                if let code = parsedResult.valueForKey("code") as? Int {
                    if code == 1 {
                        completionHandler(success: false, photoTitle: "", photoData: nil, errorString: "Error code 1")
                        return
                    }
                }
                
                if let photosDictionary = parsedResult.valueForKey("photos") as? [String: AnyObject] {
                    // Convert JSON Array of JSON Objects to Swift array of dictionaries
                    if let photoArrayOfDictionaries = photosDictionary["photo"] as? [[String: AnyObject]] {
                        // Grab random image
                        let randomPhotoDictionary = photoArrayOfDictionaries[Int(arc4random() % UInt32(photoArrayOfDictionaries.count))]
                        // Get URL and title of random image
                        let photoTitle = randomPhotoDictionary["title"] as? String
                        let photoURL = NSURL(string: (randomPhotoDictionary["url_m"] as? String)!)
                        // Check for image and display it along with title
                        if let photoData = NSData(contentsOfURL: photoURL!) {
                            completionHandler(success: true, photoTitle: photoTitle!, photoData: photoData, errorString: nil)
                        } else {
                            println("Image doesn't exist \(photoURL!)")
                        }
                    } else {
                        println("Key photo doesn't exist in JSON response")
                    }
                } else {
                    println("Key photos doesn't exist in JSON response")
                }
            }
        }
        task.resume()
    }

    // Escape arguments for URL conformity, i. e. encode characters with percent and replace spaces with +
    func escapeArguments(arguments: [String: String]) -> String {
        var URLArguments = [String]()
        for (key, value) in arguments {
            // Escape string value
            let escapedString = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            // Replace spaces with +
            let replacedString = escapedString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
            URLArguments += [key + "=" + "\(replacedString)"]
        }
        return (URLArguments.isEmpty ? "" : "?") + join("&", URLArguments)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        
        return Singleton.sharedInstance
    }

}
