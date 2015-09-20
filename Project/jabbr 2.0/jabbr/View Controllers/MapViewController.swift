//
//  MapViewController.swift
//  jabbr
//
//  Created by Adrian Wisaksana on 9/19/15.
//  Copyright © 2015 BeingAdrian. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 500
    var circle: MKCircle?
    var circleRadius = 100.00
    let builder = AGSGTTriggerBuilder()
//    var circleView: MKCircleView?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var hotspotMakeView: UIView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var hotspotTextField: UITextField!
    @IBOutlet weak var hotspotSlider: UISlider!
    
    @IBAction func currentLocationButtonPressed(sender: AnyObject) {
        if let CL = currentLocation {
            centerMapOnLocation(CL)
        }
    }
    @IBAction func addButtonTapped(sender: AnyObject) {
        if let CL = currentLocation {
            centerMapOnLocation(CL)
            addRadiusCircle(CL)
        }

        UIView.animateWithDuration(0.3,
            animations: {
            self.currentLocationButton.alpha = 0.0
            self.addButton.alpha = 0.0
        },
            completion: { void in
                self.addButton.hidden = true
                self.currentLocationButton.hidden = true
                UIView.animateWithDuration(0.5, animations: {
                    self.hotspotMakeView.hidden = false
                    self.hotspotMakeView.alpha = 1.0
                    })
        })
    }
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        hotspotTextField.resignFirstResponder()
        removeRadiusCircle()
        hotspotTextField.text = ""
        UIView.animateWithDuration(0.3,
            animations: {
                self.hotspotMakeView.alpha = 0.0
            },
            completion: { void in
                self.hotspotMakeView.hidden = true
                self.addButton.hidden = false
                self.currentLocationButton.hidden = false
                UIView.animateWithDuration(0.5, animations: {
                    self.addButton.alpha = 1.0
                    self.currentLocationButton.alpha = 1.0
                })
        })
    }
    @IBAction func hotspotRadiusSliderAction(sender: AnyObject) {
        circleRadius = Double(hotspotSlider.value)
        removeRadiusCircle()
        if let CL = currentLocation {
            centerMapOnLocation(CL)
            addRadiusCircle(CL)
        }
        
    }
    @IBAction func confirmButtonTapped(sender: AnyObject) {
        builder.triggerId = hotspotTextField.text
        builder.tags = []
        builder.direction = "enter"
        builder.notificationText = "You are near an event!"
        let params = builder.build()
        AGSGTApiClient.sharedClient().postPath("trigger/create", parameters: params, success: {
            //THROW THE SERVER STUFF HERE!
            }, failure: {error in
                print("Trigger create error: %@", error.userInfo)
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let locationManager = CLLocationManager()
        hotspotTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        locationManager.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        currentLocation = locationManager.location
        if let CL = currentLocation {
            centerMapOnLocation(CL)
        }
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
//                currentLocation = locationManager.location
//                if let CL = currentLocation {
//                    centerMapOnLocation(CL)
//                }
//                
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blueColor()
            circle.fillColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.2)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        currentLocation = locationManager.location
        circle = MKCircle(centerCoordinate: location.coordinate, radius: circleRadius as CLLocationDistance)
        self.mapView.addOverlay(circle!)
    }
    
    func removeRadiusCircle(){
        if let c = circle {
            self.mapView.removeOverlay(c)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways){
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
