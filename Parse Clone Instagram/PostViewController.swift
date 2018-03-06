//
//  SecondViewController.swift
//  Parse Clone Instagram
//
//  Created by inan on 30.01.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController , UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    let imagePicker = UIImagePickerController()
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.hideKeyboard))
        self.view.addGestureRecognizer(keyboardRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.choosePhoto))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("İmage Selected Error")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = image
    }
    
    @objc func choosePhoto(){
        
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }

    @IBAction func ShareButtonClicked(_ sender: UIButton) {
        
        let object = PFObject(className: "Posts")
        
        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        let imageFile = PFFile(name: "image.jpg", data: data!)
        
        let uuid = UUID().uuidString
        
        object["postimage"] = imageFile
        object["postcomment"] = commentText.text!
        object["postedowner"] = PFUser.current()?.username!
        object["postuuid"] = "\(String(describing: PFUser.current()?.username!)) \(uuid)"
        
        object.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                
                self.commentText.text = ""
                self.imageView.image = UIImage(named: "select.png")
                self.tabBarController?.selectedIndex = 0
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue : "newPost"), object: nil)
            }
        }
        
    }
    
    
}

