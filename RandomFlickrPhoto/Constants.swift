//
//  Constants.swift
//  RandomFlickrPhoto
//
//  Created by Dr. Paul R. Zahrl on 03/04/15.
//  Copyright (c) 2015 Dr. Paul R. Zahrl. All rights reserved.
//


extension Client {

    // MARK: - Constants
    
    struct Constants {
        // MARK: API Key
        static let API_KEY: String = "YOUR_API_KEY"
        
        // MARK: URLs
        static let BASE_URL = "https://api.flickr.com/services/rest/"
        
        // MARK: Default values
        static let EXTRAS = "url_m"
        static let DATA_FORMAT = "json"
        static let NO_JSON_CALLBACK = "1"
    }
    
    // MARK: - Methods
    
    struct Methods {
        // MARK: Get photos
        static let GET_PUBLIC_PHOTOS = "flickr.people.getPublicPhotos"
    }
    
    // MARK: - Argument keys
    
    struct ArgumentKeys {
        static let METHOD = "method"
        static let API_KEY = "api_key"
        static let USER_ID = "user_id"
        static let EXTRAS = "extras"
        static let FORMAT = "format"
        static let NO_JSON_CALLBACK = "nojsoncallback"
    }
    
    // MARK: - JSON Response Keys
    
    struct JSONResponseKeys {
        static let PHOTOS = "photos"
        static let PHOTOS_PHOTO = "photo"
        static let PHOTOS_PHOTO_TITLE = "title"
        static let PHOTOS_PHOTO_URL = "url_m"
    }
}
