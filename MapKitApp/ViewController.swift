//
//  ViewController.swift
//  MapKitApp
//
//  Created by Mohsin on 30/06/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    
    var artworks = [Artwork]()

    
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    
    let regionRadius: CLLocationDistance = 1000

    let karachiLocation = CLLocation(latitude: 24.893405, longitude: 67.057495)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.mapView.delegate = self
        
        self.centerMapOnLocation(self.initialLocation)
        
//        let artwork = Artwork(title: "King David Kalakaua",
//            locationName: "Waikiki Gateway Park",
//            discipline: "Sculpture",
//            coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
//        
//        mapView.addAnnotation(artwork)

        loadInitialData()
        mapView.addAnnotations(artworks)
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Artwork {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIView
                view.pinColor = annotation.pinColor()

            }
            return view
        }
        return nil
    }
    
    // When the user taps a map annotation pin, the callout shows an info button. If the user taps this info button, the mapView(_:annotationView:calloutAccessoryControlTapped:) method is called.
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let location = view.annotation as Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    
    
    func loadInitialData() {
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json");
        var readError : NSError?
        var data: NSData = NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(0),
            error: &readError)!
        
        // 2
        var error: NSError?
        var jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions(0), error: &error)
        
        // 3
        //if let jsonObject = jsonObject as? [String: AnyObject] where error == nil,
        

        if error == nil{
            jsonObject = jsonObject as [String: AnyObject]
        }
        
        // 4
        var jsonData = JSONValue.fromObject(jsonObject)!["data"]!.array
        for artworkJSON in jsonData! {
            if let artworkJSON = artworkJSON.array{
                // 5
                if let artwork = Artwork.fromJSON(artworkJSON){
                    artworks.append(artwork)
                }
            }
        }
        
    }
    
}


