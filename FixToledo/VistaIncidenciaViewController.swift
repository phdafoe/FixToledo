//
//  VistaIncidenciaViewController.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 27/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import UIKit
import MapKit

class VistaIncidenciaViewController: UIViewController, MKMapViewDelegate {
    
    var incidencia : IncidenciaModel?
    
    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var tipo: UILabel!
    
    @IBOutlet weak var descripcion: UILabel!
    
    
    let regionRadius: CLLocationDistance = 100
    
    @IBOutlet weak var mapView: MKMapView!
    
    /*
     let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
     
     let mapItem = MKMapItem(placemark: placemark)
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        incidencia?.foto?.getDataInBackground{(imageData, error) in
            if error == nil{
                let imageDownloaded = UIImage(data: imageData!)
                self.foto.image = imageDownloaded
            }else{
                print("Error en imagen foto")
            }
        }
        tipo.text = incidencia?.tipo
        self.title = incidencia?.titulo
        descripcion.text = incidencia?.descripcion
        let initialLocation = CLLocation(latitude: (incidencia?.coordenadas?.latitude)!, longitude: (incidencia?.coordenadas?.longitude)!)
        centerMapOnLocation(location: initialLocation)
        /*
        let coordinate = mapView.convertPoint(initialLocation,toCoordinateFromView: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        */
        
        let newYorkLocation = CLLocationCoordinate2DMake((incidencia?.coordenadas?.latitude)!, (incidencia?.coordenadas?.longitude)!)
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newYorkLocation
        dropPin.title = "Incidencia"
        mapView.addAnnotation(dropPin)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
