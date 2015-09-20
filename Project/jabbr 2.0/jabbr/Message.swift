//
//  Message.swift
//  jabbr
//
//  Created by Adrian Wisaksana on 9/20/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MMX


class Message: NSObject, JSQMessageData {

    let underlyingMessage: MMXMessage
    
    lazy var type: MessageType = {
        return MessageType(rawValue: self.underlyingMessage.messageContent["type"] as! String)
        }()!
    
    lazy var mediaContent: JSQMessageMediaData! = {
        let messageContent = self.underlyingMessage.messageContent
        
        switch self.type {
        case .Text:
            return nil
        case .Location:
            //            let location = CLLocation(latitude: (messageContent["latitude"] as! NSString).doubleValue, longitude: (messageContent["longitude"] as! NSString).doubleValue)
            let locationMediaItem = JSQLocationMediaItem()
            locationMediaItem.appliesMediaViewMaskAsOutgoing = false
            //            locationMediaItem.setLocation(location, withCompletionHandler: self.completion)
            return locationMediaItem
        case .Photo:
            let photoMediaItem = JSQPhotoMediaItem()
            photoMediaItem.appliesMediaViewMaskAsOutgoing = false
            photoMediaItem.image = nil
            return photoMediaItem
        case .Video:
            let videoMediaItem = JSQVideoMediaItem()
            videoMediaItem.appliesMediaViewMaskAsOutgoing = false
            videoMediaItem.fileURL = nil
            videoMediaItem.isReadyToPlay = false
            return videoMediaItem
        }
        }()
    
    init(message: MMXMessage) {
        self.underlyingMessage = message
    }
    
    func senderId() -> String! {
        return underlyingMessage.sender.username
    }
    
    func senderDisplayName() -> String! {
        return (underlyingMessage.sender.displayName != nil) ? underlyingMessage.sender.displayName : underlyingMessage.sender.username
    }
    
    func date() -> NSDate! {
        if let date = underlyingMessage.timestamp {
            return date
        }
        
        return NSDate()
    }
    
    func isMediaMessage() -> Bool {
        return (type != MessageType.Text)
    }
    
    func messageHash() -> UInt {
        // FIXME:
        //        let contentHash = isMediaMessage() ? Int(media().mediaHash()) : text().hash
        //        return UInt(senderId().hash ^ date().hash ^ contentHash)
        return UInt(abs(underlyingMessage.messageID.hash))
    }
    
    func text() -> String! {
        return underlyingMessage.messageContent["message"] as! String
    }
    
    func media() -> JSQMessageMediaData! {
        return mediaContent
    }
    
    override var description: String {
        return "senderId is \(senderId()), messageContent is \(underlyingMessage.messageContent)"
    }
    
    
}
