//
//  PhotoViewController.swift
//  RandomFlickrPhoto
//
//  Created by Dr. Paul R. Zahrl on 01/04/15.
//  Copyright (c) 2015 Dr. Paul R. Zahrl. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var checkingUserIDLabel: UILabel!
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        refreshButton.enabled = false
        fetchImage()
    }
    
    var userID: String?
    
    struct MethodArguments {
        let USER_ID = "132115085@N04"
        let EXTRAS = "url_m"
        let DATA_FORMAT = "json"
        let NO_JSON_CALLBACK = "1"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.hidden = true
        titleLabel.hidden = true
        detailLabel.hidden = true
        
        checkingUserIDLabel.hidden = false
        
        self.navigationController!.navigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        fetchImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchImage() {
        println("fetchImage")
        // Create array of method arguments
        let methodArguments = [
            "method": Methods.GET_PUBLIC_PHOTOS,
            "api_key": API_KEY,
            "user_id": self.userID!,
            "extras": MethodArguments().EXTRAS,
            "format": MethodArguments().DATA_FORMAT,
            "nojsoncallback": MethodArguments().NO_JSON_CALLBACK
        ]
        
        // Initialize session and URL
        let URL = NSURL(string: BASE_URL + escapeArguments(methodArguments))
        println(BASE_URL + escapeArguments(methodArguments))
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
                        self.showError()
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
                            dispatch_async(dispatch_get_main_queue(), {
                                self.imageView.image = UIImage(data: photoData)
                                self.detailLabel.text = photoTitle
                                self.checkingUserIDLabel.hidden = true
                                self.imageView.hidden = false
                                self.titleLabel.hidden = false
                                self.detailLabel.hidden = false
                                self.navigationController?.navigationBarHidden = false
                                self.refreshButton.enabled = true
                            })
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
    


    func showError() {
        let alertController = UIAlertController(title: "Error", message: "The user ID doesn't exist", preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in
            self.navigationController!.popViewControllerAnimated(true)
            self.navigationController?.navigationBarHidden = false
            return
        }
        alertController.addAction(okButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
