//
//  NuevaIncidenciaViewController.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 13/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices
import CoreLocation
import MapKit

class NuevaIncidenciaViewController: UIViewController{
    
    var photoSelected = false
    var newCoordinate : CLLocationCoordinate2D!
    var customLocation : CLLocation?
    var apuestasArray = ["Seguridad", "Limpieza", "Zonas verdes", "Alumbrado", "Otros"]
    var locationManager = CLLocationManager()
    var ciudad = ""
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imagenUsuario: UIImageView!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var tipoIncidencia: UITextField!
    @IBOutlet weak var descripcionIncidencia: UITextView!
    @IBOutlet weak var imagenIncidencia: UIImageView!
    @IBOutlet weak var direccionIncidencia: UILabel!
    @IBOutlet weak var tituloIncidencia: UITextField!
    
    
    @IBAction func elegirImagen(_ sender: Any) {
        pickerPhoto()
    }
    
    
    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func localizar(_ sender: Any) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) || (authorizationStatus == nil) {
            locationManager.requestWhenInUseAuthorization()
        }else if(authorizationStatus == CLAuthorizationStatus.denied){
            self.ShowAlertVC(titleData: "Aviso", messageData: "Se necesita permiso de acceso a localización")
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    @IBAction func enviarIncidencia(_ sender: Any) {
        if photoSelected == true && descripcionIncidencia.text != "" && tituloIncidencia.text != ""{
            let incidencia = PFObject(className: "Incidencia")
            incidencia["descripcion"] = descripcionIncidencia.text
            let imageData = UIImageJPEGRepresentation(self.imagenIncidencia.image!, 0.5)
            let imageFile = PFFile(name: "image.jpg", data: imageData!)
            incidencia["imagen"] = imageFile
            incidencia["username"] = PFUser.current()?.username
            incidencia["direccion"] = direccionIncidencia.text
            incidencia["tipo"] = tipoIncidencia.text
            incidencia["titulo"] = tituloIncidencia.text
            incidencia["location"] = PFGeoPoint(location: customLocation)
            incidencia["estado"] = "Pendiente"
            incidencia["fecha"] = fecha.text
            
            actIndicator.isHidden = false
            actIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            incidencia.saveInBackground{(success, error) in
                
                self.actIndicator.isHidden = true
                self.actIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if success{
                    self.ShowAlertVC(titleData: "Publicación completada", messageData: "La incidencia ha sido publicada correctamente")
                }else{
                    self.ShowAlertVC(titleData: "Aviso", messageData: "Error en la publicación")
                }
                
            }
        }else{
            self.ShowAlertVC(titleData: "Aviso", messageData: "Rellena todos los campos")
        }
    }
    
    @IBAction func enviar(_ sender: Any) {
        if photoSelected == true && descripcionIncidencia.text != "" {
            let incidencia = PFObject(className: "Incidencia")
            incidencia["descripcion"] = descripcionIncidencia.text
            let imageData = UIImageJPEGRepresentation(self.imagenIncidencia.image!, 0.5)
            let imageFile = PFFile(name: "image.jpg", data: imageData!)
            incidencia["imagen"] = imageFile
            incidencia["username"] = PFUser.current()?.username
            incidencia["direccion"] = direccionIncidencia.text
            incidencia["tipo"] = "Tipo prueba"
            incidencia["titulo"] = "Prueba"
            incidencia["location"] = PFGeoPoint(location: customLocation)
            incidencia["estado"] = "Pendiente"
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            incidencia.saveInBackground{(success, error) in
                if success{
                    
                    self.ShowAlertVC(titleData: "Publicación completada", messageData: "La incidencia ha sido publicada correctamente")
                    UIApplication.shared.endIgnoringInteractionEvents()
                }else{
                    self.ShowAlertVC(titleData: "Aviso", messageData: "Error en la publicación")
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagenUsuario.layer.cornerRadius = imagenUsuario.frame.width / 2
        imagenUsuario.layer.borderWidth = 0.5
        imagenUsuario.layer.borderColor = UIColor.black.cgColor
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        actIndicator.isHidden = true
        crearPicker(myTextField: tipoIncidencia, myArray: apuestasArray, myTag: 0, myDelegateVC: self, myDataSourceVC: self)
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        dateFormatter.locale = NSLocale(localeIdentifier: "es_ES") as Locale!
        
        fecha.text = dateFormatter.string(from: Date())
        nombreUsuario.text = PFUser.current()?.username
        let fotoUsuario = PFUser.current()?["foto"] as! PFFile
        fotoUsuario.getDataInBackground{(imageData, error) in
            if error == nil{
                let imageDownloaded = UIImage(data: imageData!)
                self.imagenUsuario.image = imageDownloaded
            }else{
                print("Error en imagen foto")
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func crearPicker(myTextField : UITextField, myArray : [String], myTag : Int, myDelegateVC : UIPickerViewDelegate, myDataSourceVC : UIPickerViewDataSource){
        
        let myPickerView = UIPickerView()
        myPickerView.delegate = myDelegateVC
        myPickerView.dataSource = myDataSourceVC
        myPickerView.tag = myTag
        myTextField.inputView = myPickerView
        myTextField.text = myArray[0]
        
    }
    
    func ShowAlertVC(titleData:String, messageData:String)
    {
        let AlertVC = UIAlertController(title: titleData, message: messageData, preferredStyle: .alert)
        AlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(AlertVC, animated: true, completion: nil)
    }
    func dameLocalizacion(){
        CLGeocoder().reverseGeocodeLocation(self.customLocation!, completionHandler: { (placemarks, error) -> Void in
            // 2 -> creamos una par de variables o propiedades vacias de momento
            var calle = ""
            var subCalle = ""
            var customTitle = ""
            if let customPlacemarks = placemarks?[0]{
                if customPlacemarks.thoroughfare != nil{ // no debemos confundir una cadena vacia con un valor nil
                    //calle = customPlacemarks.locality!
                    calle = customPlacemarks.thoroughfare!
                }
                if customPlacemarks.subThoroughfare != nil{
                    subCalle = customPlacemarks.country!
                    self.ciudad = subCalle
                }
                //customTitle = "\(calle)" + "·" + "\(subCalle)" // Aun Aqui puede que ninguno de los dos tenga info // PUEDE CASCARNOS
                customTitle = "\(calle)"
            }
            if customTitle == ""{
                customTitle = "Punto añadido el \(NSDate())"
            }
            self.direccionIncidencia.text = customTitle
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
//MARK: - PICKER PHOTO
extension NuevaIncidenciaViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func pickerPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            showPhotoMenu()
        }else{
            choosePhotoFromLIbrary()
        }
    }
    
    func showPhotoMenu(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAccion = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let takePhotoAction = UIAlertAction(title: "Toma la foto", style: .default) { (alert) in
            self.takePhotoWithCamera()
        }
        let chooseFromLibraryAction = UIAlertAction(title: "Escoge desde la librería", style: .default) { Void in
            self.choosePhotoFromLIbrary()
        }
        alertController.addAction(cancelAccion)
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseFromLibraryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLIbrary(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagenIncidencia.image = image
            photoSelected = true
        } else{
            print("Something went wrong")
        }
        //ocultarImagenBTN.hidden = false
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - DELEGADO (Siempre se entera si la posicion cambia)
extension NuevaIncidenciaViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        newCoordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let newCoordinateData = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        customLocation = newCoordinateData
        locationManager.stopUpdatingLocation()
        dameLocalizacion()
    }
    private func locationManager(manager: CLLocationManager,
                    didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if (status == CLAuthorizationStatus.notDetermined) {
            locationManager.requestWhenInUseAuthorization()
            
        } else {
            locationManager.startUpdatingLocation()
        }
    }
}
extension NuevaIncidenciaViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
}
//MARK: - DELEGATE / DATASOURCE DE PICKERVIEW
extension NuevaIncidenciaViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    //func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
      //  return 1
    //}
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return apuestasArray.count
        /*
         if pickerView.tag == 0{
         return apuestasArray.count
         }*/
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return apuestasArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipoIncidencia.text = apuestasArray[row]
    }
    
}
