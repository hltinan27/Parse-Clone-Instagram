//
//  FirstViewController.swift
//  Parse Clone Instagram
//
//  Created by inan on 30.01.2018.
//  Copyright © 2018 inan. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    var postOwnerArray = [String]()
    var postCommentArray = [String]()
    var PostUuidArray = [String]()
    var postImageArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.getData), name: NSNotification.Name(rawValue : "newPost"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postOwnerArray.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        cell.username.text = postOwnerArray[indexPath.row]
        cell.comment.text = postCommentArray[indexPath.row]
        cell.uuidText.text = PostUuidArray[indexPath.row]
        
        postImageArray[indexPath.row].getDataInBackground { (data, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                
                cell.imageCell.image = UIImage(data: data!)
            }
        }
        return cell
    }

    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        PFUser.logOutInBackground { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Warning", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                UserDefaults.standard.removeObject(forKey: "user")
                UserDefaults.standard.synchronize()
                
                let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignInVCViewController
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = signIn
                delegate.rememberLogin()
            }
        }
        
    }
    
    @objc func getData(){
        
        let query = PFQuery(className: "Posts")
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (posts, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                self.postImageArray.removeAll(keepingCapacity: true)
                self.postOwnerArray.removeAll(keepingCapacity: true)
                self.postCommentArray.removeAll(keepingCapacity: true)
                
                for post in posts! {
                    self.postOwnerArray.append(post.object(forKey: "postedowner") as! String)
                    self.postCommentArray.append(post.object(forKey: "postcomment") as! String)
                    self.PostUuidArray.append(post.object(forKey: "postuuid") as! String)
                    self.postImageArray.append(post.object(forKey: "postimage") as! PFFile)
                }
                self.tableView.reloadData()
                
            }
        }
    }
    
}

