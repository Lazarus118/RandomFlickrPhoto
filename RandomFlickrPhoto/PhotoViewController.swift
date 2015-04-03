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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide UI elements and navigation bar
        imageView.hidden = true
        titleLabel.hidden = true
        detailLabel.hidden = true
        checkingUserIDLabel.hidden = false
        self.navigationController!.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        // Fetch image as soon as view appears
        fetchImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchImage() {
        Client.sharedInstance().fetchImageForUserID(userID!, completionHandler: { (success, photoTitle, photoData, errorString) -> Void in
            if success == false {
                self.showError()
                return
            } else {
                // Update UI
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView.image = UIImage(data: photoData!)
                    self.detailLabel.text = photoTitle
                    self.checkingUserIDLabel.hidden = true
                    self.imageView.hidden = false
                    self.titleLabel.hidden = false
                    self.detailLabel.hidden = false
                    self.navigationController?.navigationBarHidden = false
                    self.refreshButton.enabled = true
                })
            }
        })
    }

    func showError() {
        let alertController = UIAlertController(title: "Error", message: "The user ID doesn't exist", preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { action in
            self.navigationController!.popViewControllerAnimated(false)
            self.navigationController?.navigationBarHidden = false
            return
        }
        alertController.addAction(okButton)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
