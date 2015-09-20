//
//  MapViewController.swift
//  jabbr
//
//  Created by Adrian Wisaksana on 9/19/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import UIKit
import MMX


class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // create mmx public forum
        MMXChannel.createWithName(
            "techcrunch",
            summary: "Techcrunch Disrupt 2015 Hackathon is awesome.",
            isPublic: true,
            success: {(channel) -> Void in
                
            },
            failure: {(error) -> Void in
                
        })
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

}
