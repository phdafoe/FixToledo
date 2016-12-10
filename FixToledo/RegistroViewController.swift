//
//  RegistroViewController.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 13/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import UIKit
import Parse

class RegistroViewController: UIViewController {
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var correoTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imagen: UIImageView!
    
    //MARK: - IBActions
    @IBAction func registrar(_ sender: AnyObject) {
        if correoTF.text != "" && passTF.text != "" && nombreTF.text != "" && imagen.image != nil{
            registroParse()
        }else{
            present(muestraAlertVC("Error", messageData: "Introduce todos los datos"), animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        imagen.addGestureRecognizer(tapGesture)
        imagen.isUserInteractionEnabled = true
        imagen.layer.cornerRadius = imagen.frame.width / 2
        imagen.layer.borderColor = UIColor.black.cgColor
        imagen.layer.borderWidth = 0.5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        pickerPhoto()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func registroParse(){
        let user = PFUser()
        user.username = nombreTF.text
        user.password = passTF.text
        user.email = correoTF.text
        let imageData = UIImageJPEGRepresentation(self.imagen.image!, 0.5)
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        user["foto"] = imageFile
        // Sign up the user asynchronously
        
        actIndicator.isHidden = false
        actIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        user.signUpInBackground(block: { (succeed, error) -> Void in
            self.actIndicator.isHidden = true
            self.actIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                self.present(muestraAlertVC("Error", messageData: "\(error)"), animated: true, completion: nil)
                
            } else {
                print("registrado")
                self.performSegue(withIdentifier: "desdeRegistro", sender: self)
            }
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.current() != nil{
            self.performSegue(withIdentifier: "desdeRegistro", sender: self)
        }
    }

    
}
//MARK: - PICKER PHOTO
extension RegistroViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
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
            imagen.image = image
        } else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
}
