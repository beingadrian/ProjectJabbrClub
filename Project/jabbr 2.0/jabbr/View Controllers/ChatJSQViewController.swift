//
//  ChatJSQViewController.swift
//  jabbr
//
//  Created by Adrian Wisaksana on 9/20/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import UIKit
import MMX
import JSQMessagesViewController

class ChatJSQViewController: JSQMessagesViewController {
    
    // MARK: - Properties
    
    var userName = ""
    var messages = [JSQMessage]()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        // set username
        self.userName = MMXUser.currentUser().username
        
        // get mmx channel with name
        MMXChannel.channelForName("techcrunch", isPublic: true, success:
            { (channel) in
                
                if (channel.isSubscribed) {
                    
                    print("Subscribing techcrunch.")
                    
                    // send message
                    //                    let message = MMXMessage(toChannel: channel, messageContent: ["message": "Greetings."])
                    //
                    //                    message.sendWithSuccess( {
                    //                        print(message)
                    //                    }) { (error) -> Void in
                    //                        if (error != nil) {
                    //                            print(error.description)
                    //                        }
                    //                    }
                    
                    // get messages
                    let dateComponents = NSDateComponents()
                    dateComponents.hour = -1
                    
                    let theCalendar = NSCalendar.currentCalendar()
                    let now = NSDate()
                    let anHourAgo = theCalendar.dateByAddingComponents(
                        dateComponents,
                        toDate: now,
                        options: NSCalendarOptions(rawValue: 0))
                    
                    channel.messagesBetweenStartDate(anHourAgo, endDate: now,
                        limit: 10,
                        offset: 0,
                        ascending: false,
                        success: { (totalCount, messages) -> Void in
                            for message in messages as! [MMXMessage] {
                                let jsqMessage = JSQMessage(senderId: message.sender.username, displayName: message.sender.username, text: message.messageContent["message"]! as! String)
                                self.messages.append(jsqMessage)
                                self.collectionView!.reloadData()
                            }
                        },
                        failure: { (error) -> Void in
                            if (error != nil) {
                                print(error.description)
                            }
                    })
                    
                } else {
                    print("Going to subscribe.")
                }
                
                
            },
            failure: {(error) in
                
                if (error != nil) {
                    print(error.description)
                }
                
        })


        // other setting
        self.collectionView!.reloadData()
        self.senderDisplayName = self.userName
        self.senderId = self.userName
        
        // test
        print(messages)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - JSQ Collection View Code
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let data = self.messages[indexPath.row]
        return data
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = self.messages[indexPath.row]
        
        if (data.senderId == self.senderId) {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return nil
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.messages.count
        
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        let newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text);
        messages += [newMessage]
        self.finishSendingMessage()
        
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
        // code here
        
    }

}
