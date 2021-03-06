//
//  FeedViewController.swift
//  Parsestagram
//
//  Created by Khalen Hudson on 3/2/19.
//  Copyright © 2019 Khalen Hudson. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className:"Posts")
        query.includeKey(["author", "Comments", "Comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let Comments = (post["Comments"] as! [PFObject])
        return Comments.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        let Comments = (post["Comments"] as! [PFObject])
        
        if indexPath.row == 0{
            let user = post["author"] as! PFUser
            
            cell.usernameLabel.text = user.username
            
            cell.captionLabel.text = post["Caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")  as! CommentCell
            
            let Comment = Comments[indexPath.row - 1]
            cell.commentLabel.text = Comment["text"] as? String
            
            let user = Comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let Comment = PFObject(className: "Comments")
        Comment["text"] = "This is a random comment"
        Comment["post"] = post
        Comment["author"] = PFUser.current()!
        
        post.add(Comment, forKey: "Comments")
        
        post.saveInBackground { (success, error) in
            if success{
                print("Comment saved!")
            } else{
                print("Error saving comment")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    
}
