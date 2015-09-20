//
//  ClubsViewController.swift
//  jabbr
//
//  Created by Adrian Wisaksana on 9/19/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import UIKit
import MMX


class ClubsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var clubTableView: UITableView!
    var selectedClubTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set club table view
        clubTableView.delegate = self
        clubTableView.dataSource = self
        
        // mmx login
        loginToMMX("jimmy", password: "jimmy")
        
        // TODO: get and show clubs
        
        
        
    }
    
    func loginToMMX(username: String, password: String) {
        
        // mmx log in
        let username = username
        let password = password
        
        let credential = NSURLCredential(user: username, password: password, persistence: .None)
        
        MMXUser.logInWithCredential(credential,
            success: { (user) -> Void in
                
                print("Successfully logged in.")
                
            },
            failure: { (error) -> Void in
                
        })

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let chatVC = segue.destinationViewController as! ChatViewController
        chatVC.clubTitle = selectedClubTitle
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
        
    }


}


extension ClubsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = clubTableView.dequeueReusableCellWithIdentifier("ChatGroupCell") as! ClubTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.clubTitleLabel.text = "Techcrunch"
        default:
            break
        }

        
        return cell
        
    }
    
}

extension ClubsViewController: UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        clubTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = self.clubTableView.cellForRowAtIndexPath(indexPath) as! ClubTableViewCell
        
        selectedClubTitle = cell.clubTitleLabel.text!
        
        performSegueWithIdentifier("ChatViewController", sender: self)
        
    }
    
}
