//
//  ViewController.swift
//  RandomFlickrPhoto
//
//  Created by Dr. Paul R. Zahrl on 31/03/15.
//  Copyright (c) 2015 Dr. Paul R. Zahrl. All rights reserved.
//

/* Use flickr.urls.lookupGallery, flickr.galleries.getList or flickr.galleries.getInfo to retrieve gallery ID. */

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhoto" {
            (segue.destinationViewController as PhotoViewController).userID = textField.text
        }
    }
}

