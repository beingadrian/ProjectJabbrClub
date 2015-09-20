//
//  MessageType.swift
//  jabbr
//
//  Created by Adrian Wisaksana on 9/20/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import Foundation

enum MessageType: String, CustomStringConvertible {
    case Text = "text"
    case Location = "location"
    case Photo = "photo"
    case Video = "video"
    
    var description: String {
        
        switch self {
            
        case .Text:
            return "text"
        case .Location:
            return "location"
        case .Photo:
            return "photo"
        case .Video:
            return "video"
        }
    }
}