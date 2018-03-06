//
//  SignInVCViewController.swift
//  Parse Clone Instagram
//
//  Created by inan on 30.01.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit
import Parse

class SignInVCViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        }

    

    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            PFUser.logInWithUsername(inBackground: emailText.text!, password: passwordText.text!, block: { (user, error) in
                if error != nil{
                    let alert = UIAlertController(title: "Warning", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }else{
                    
                    UserDefaults.standard.set(self.emailText.text!, forKey: "user")
                    UserDefaults.standard.synchronize()
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogin()
                }
            })
            
        }else{
            let alert = UIAlertController(title: "Warning", message: "Username and password Needed!", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            let user = PFUser()
            user.email = emailText.text!
            user.username = emailText.text!
            user.password = passwordText.text!
            user.signUpInBackground(block: { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Warning", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    UserDefaults.standard.set(self.emailText.text!, forKey: "user")
                    UserDefaults.standard.synchronize()
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogin()
                }
            })
            
        }else{
            let alert = UIAlertController(title: "Warning", message: "Username and password Needed!", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
