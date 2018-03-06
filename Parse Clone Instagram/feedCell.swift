//
//  feedCell.swift
//  Parse Clone Instagram
//
//  Created by inan on 3.03.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit
import Parse

class feedCell: UITableViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var uuidText: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var comment: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        uuidText.isHidden = true
        // Configure the view for the selected state
    }
    @IBAction func likeButton(_ sender: Any) {
        let likeObject = PFObject(className: "Likes")
        likeObject["from"] = PFUser.current()?.username!
        likeObject["to"] = uuidText.text!
        
        likeObject.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }else{
                print("Like Saved")
            }
        
        }
        
    }
    @IBAction func commentButton(_ sender: Any) {
    }
    
}
