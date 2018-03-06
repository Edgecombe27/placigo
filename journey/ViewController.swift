//
//  ViewController.swift
//  journey
//
//  Created by Spencer Edgecombe on 3/5/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
 
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var markButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var markCreateView: UIView!
    @IBOutlet var markTitleTextField: UITextField!
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var rightViewExtended = false
    var textColor : UIColor!
    var userLocation : CLLocation!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let borderWidth : CGFloat = 0.75
        let borderColor = UIColor.lightGray.cgColor
        
        markButton.layer.cornerRadius = markButton.bounds.height/2.0
        markButton.layer.masksToBounds = true
        markButton.layer.borderWidth = borderWidth
        markButton.layer.borderColor = borderColor
        menuButton.layer.cornerRadius = menuButton.bounds.height/2.0
        menuButton.layer.masksToBounds = true
        menuButton.layer.borderWidth = borderWidth
        menuButton.layer.borderColor = borderColor
        locationButton.layer.cornerRadius = locationButton.bounds.height/2.0
        locationButton.layer.masksToBounds = true
        locationButton.layer.borderWidth = borderWidth
        locationButton.layer.borderColor = borderColor
        markCreateView.layer.cornerRadius = markCreateView.bounds.height/2.0
        markCreateView.layer.masksToBounds = true
        markCreateView.layer.borderWidth = borderWidth
        markCreateView.layer.borderColor = borderColor
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create and Add MapView to our main view
        createMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    func createMapView()
    {
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        contentView.addSubview(mapView)
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    @IBAction func markTapped(_ sender: Any) {
        
        openMarkCreateView()
        
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        
    }
    
    @IBAction func locationTapped(_ sender: Any) {
        determineCurrentLocation()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        closeMarkCreateView()
        placeAnnotation(title: markTitleTextField.text!, subtitle: "", lat: userLocation.coordinate.latitude, long: userLocation.coordinate.longitude)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        closeMarkCreateView()
    }
    
    func closeMarkCreateView() {
        markTitleTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.335, animations: {
            self.markCreateView.alpha = 0
        }, completion: { (flag) in
            self.markCreateView.isHidden = true
        })
    }
    
    func openMarkCreateView() {
        self.markCreateView.alpha = 0
        markCreateView.isHidden = false
        
        UIView.animate(withDuration: 0.35, animations: {
            self.markCreateView.alpha = 1
        }, completion: { (flag) in
            self.markTitleTextField.becomeFirstResponder()
        })
    }
    
    func placeAnnotation(title : String, subtitle: String, lat : CLLocationDegrees, long : CLLocationDegrees) {
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(lat, long);
        myAnnotation.title = title
        myAnnotation.subtitle = subtitle
        mapView.addAnnotation(myAnnotation)
        
    }
    
}




