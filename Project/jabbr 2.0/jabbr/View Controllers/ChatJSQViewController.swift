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
    
    var username = ""
    var messages = [JSQMessageData]()
    var channel: MMXChannel?
    let incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
    let outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    
    
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        // set username
        self.username = MMXUser.currentUser().username

        self.senderDisplayName = self.username
        self.senderId = self.username
        
        getChannelWithName("techcrunch")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // receive  message
        MMX.start()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveMessage:", name: MMXDidReceiveMessageNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func didReceiveMessage(notification: NSNotification) {
        
        /**
        *  Show the typing indicator to be shown
        */
        showTypingIndicator = !self.showTypingIndicator
        
        /**
        *  Scroll to actually view the indicator
        */
        scrollToBottomAnimated(true)
        
        /**
        *  Upon receiving a message, you should:
        *
        *  1. Play sound (optional)
        *  2. Add new id<JSQMessageData> object to your data source
        *  3. Call `finishReceivingMessage`
        */
        let tmp : [NSObject : AnyObject] = notification.userInfo!
        let mmxMessage = tmp[MMXMessageKey] as! MMXMessage
        
        /**
        *  Allow typing indicator to show
        */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            let message = Message(message: mmxMessage)
            self.messages.append(message)
            JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
            self.finishReceivingMessageAnimated(true)
            
            if message.isMediaMessage() {
                
                switch message.type {
                case .Text:
                    //return nil
                    print("Text")
                case .Location:
                    let location = CLLocation(latitude: (mmxMessage.messageContent["latitude"] as! NSString).doubleValue, longitude: (mmxMessage.messageContent["longitude"] as! NSString).doubleValue)
                    let locationMediaItem = JSQLocationMediaItem()
                    locationMediaItem.setLocation(location) {
                        self.collectionView?.reloadData()
                    }
                    message.mediaContent = locationMediaItem
                default:
                    break
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getChannelWithName(name: String) {
        
        // get mmx channel with name
        MMXChannel.channelForName(name, isPublic: true, success:
            { (channel) in
                
                self.channel = channel
                
                if (channel.isSubscribed) {
                    
                    // get messages
                    let dateComponents = NSDateComponents()
                    dateComponents.hour = -3
                    
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
                            
                        },
                        failure: { (error) -> Void in
                            if (error != nil) {
                                print(error.description)
                            }
                    })
                    
                } else {
                    
                    channel.subscribeWithSuccess({
                        print("Subscribed.")
                        }, failure: { (error) -> Void in
                            
                    })
                    
                }
                
            },
            failure: {(error) in
                if (error != nil) {
                    print(error.description)
                }
        })
        
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        /**
        *  Sending a message. Your implementation of this method should do *at least* the following:
        *
        *  1. Play sound (optional)
        *  2. Add new id<JSQMessageData> object to your data source
        *  3. Call `finishSendingMessage`
        */
        
        let messageContent = [
            "type": MessageType.Text.rawValue,
            "message": text,
        ]
        let mmxMessage = MMXMessage(toChannel: channel, messageContent: messageContent)
        mmxMessage.sendWithSuccess( { () -> Void in
//            let message = Message(message: mmxMessage)
//            self.messages.append(message)
            self.finishSendingMessageAnimated(true)
            }) { (error) -> Void in
                print(error)
        }
    }
    
    // MARK: - JSQ Collection View Code
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        messages.removeAtIndex(indexPath.item)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        
        if message.senderId() == senderId {
            return outgoingBubbleImageView
        }
        
        return incomingBubbleImageView
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.item]
        let nameParts = message.senderDisplayName().componentsSeparatedByString(" ")
        let initials = (nameParts.map{($0 as NSString).substringToIndex(1)}.joinWithSeparator("") as NSString).substringToIndex(min(nameParts.count, 2)).uppercaseString
        
        return JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.65, alpha: 1.0), font: UIFont.systemFontOfSize(14.0), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date())
        }
        
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        
        /**
        *  iOS7-style sender name labels
        */
        if message.senderId() == senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            if previousMessage.senderId()  == message.senderId() {
                return nil
            }
        }
        
        /**
        *  Don't specify attributes to use the defaults.
        */
        return NSAttributedString(string: message.senderDisplayName())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    // MARK: UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if !message.isMediaMessage() {
            if message.senderId() == senderId {
                cell.textView!.textColor = UIColor.blackColor()
            } else {
                cell.textView!.textColor = UIColor.whiteColor()
            }
            
            // FIXME: 1
            cell.textView!.linkTextAttributes = [
                NSForegroundColorAttributeName : cell.textView?.textColor as! AnyObject,
                NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue | NSUnderlineStyle.PatternSolid.rawValue
            ]
        }
        
        return cell
    }
    
    // MARK: JSQMessagesCollectionViewDelegateFlowLayout methods
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        /**
        *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
        */
        
        /**
        *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
        *  The other label height delegate methods should follow similarly
        *
        *  Show a timestamp for every 3rd message
        */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        /**
        *  iOS7-style sender name labels
        */
        let currentMessage = messages[indexPath.item]
        if currentMessage.senderId() == senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            if previousMessage.senderId() == currentMessage.senderId() {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0.0
    }
    
    
    // MARK: Helper methods
    
    func currentRecipient() -> MMXUser {
        let currentRecipient = MMXUser()
        currentRecipient.username = "echo_bot"
        
        return currentRecipient
    }

    
    
}
