//
//  ChatViewController.swift
//  jabbr
//
//  Created by Adrian Wisaksana on 9/19/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import UIKit
import MMX
import JSQMessagesViewController


class ChatViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var chatTitleItemLabel: UINavigationItem!

    var clubTitle = ""
    var messages: [MMXMessage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTitleItemLabel.title = clubTitle
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)

    }

}


