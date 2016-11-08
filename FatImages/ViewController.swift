//
//  ViewController.swift
//  FatImages
//
//  Created by DLab on 11/8/16.
//  Copyright © 2016 Dlabiwritecode. All rights reserved.
//

import UIKit


enum BigImages: String {
    case whale = "https://lh3.googleusercontent.com/16zRJrj3ae3G4kCDO9CeTHj_dyhCvQsUDU0VF0nZqHPGueg9A9ykdXTc6ds0TkgoE1eaNW-SLKlVrwDDZPE=s0#w=4800&h=3567"
    case shark = "https://lh3.googleusercontent.com/BCoVLCGTcWErtKbD9Nx7vNKlQ0R3RDsBpOa8iA70mGW2XcC76jKS09pDX_Rad6rjyXQCxngEYi3Sy3uJgd99=s0#w=4713&h=3846"
    case seaLion = "https://lh3.googleusercontent.com/ibcT9pm_NEdh9jDiKnq0NGuV2yrl5UkVxu-7LbhMjnzhD84mC6hfaNlb-Ht0phXKH4TtLxi12zheyNEezA=s0#w=4626&h=3701"
}

class ViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    
    
    // This method downloads a huge image. blocking the main queue and
    // the UI. Avoid using this.
    @IBAction func synchronousDownload(sender: UIBarButtonItem) {
        
        // Get the url for the image,
        // Obtain the NSData with the image
        // Turn it into a UIImage
        // Display it
        
        if let url = NSURL(string: BigImages.seaLion.rawValue) {
            let imgData = NSData(contentsOfURL: url)
            let image = UIImage(data: imgData!)
            self.photoView.image = image
        }
        
        
    }
    
    // This method avoids blocking the main thread by creating a new queue
    // that runs in the background...
    @IBAction func simpleAsynchrounousDownload(sender: UIBarButtonItem) {
        
        // Get the url for the image,
        // create a queue from scratch,
        // call dispatch_async to send a closure to the downloads queue
        
        if let url = NSURL(string: BigImages.shark.rawValue) {
            let download = dispatch_queue_create("download", nil)
            
            dispatch_async(download) { Void in
                let imgData = NSData(contentsOfURL: url)
                let img = UIImage(data: imgData!)
                
                dispatch_async(dispatch_get_main_queue()) { Void in
                    self.photoView.image = img
                }
            }
        }
    }
    
    // This code downloads the huge image in a global queue and uses a completion closure
    @IBAction func asynchronousDownload(sender: UIBarButtonItem) {
        withBigImage { (image) in
            self.photoView.image = image
        }
    }
    
    func withBigImage(completionHandler handler: (image: UIImage) -> ()) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { Void in
            if let url = NSURL(string: BigImages.whale.rawValue) {
                if let imgData = NSData(contentsOfURL: url) {
                    if let img = UIImage(data: imgData) {
                        
                        dispatch_async(dispatch_get_main_queue()) { Void in
                            handler(image: img)
                        }
                        
                    }
                }
            }
        }
    }

    
    @IBAction func setTransparencyOfImage(sender: UISlider) {
        photoView.alpha = CGFloat(sender.value)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

