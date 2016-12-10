//
//  LoginViewController.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 13/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    
    @IBAction func entrar(_ sender: AnyObject) {
        if nombreTF.text != "" && passTF.text != ""{
            login()
        }else{
            self.present(muestraAlertVC("Error", messageData: "Introduce los datos"), animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func irRegistro(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "registroViewController") as! RegistroViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func login(){
        // Send a request to login
        actIndicator.isHidden = false
        actIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        PFUser.logInWithUsername(inBackground: nombreTF.text!, password: passTF.text!, block: { (user, errorLogin) -> Void in
            self.actIndicator.isHidden = true
            self.actIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if user != nil {
                print("login")
                self.performSegue(withIdentifier: "desdeLogin", sender: self)
            } else {
                self.present(muestraAlertVC("Error", messageData: "\(errorLogin)"), animated: true, completion: nil)
            }
        })
    }
    
    /*
    func login(){
        PFUser.logInWithUsername(inBackground: nombreTF.text!, password: passTF.text! ) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("Logado")
                let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "homeTableViewController") as! HomeTableViewController
                self.show(vc as! UIViewController, sender: vc)
            } else {
                let errorString = error!.userInfo["error"] as? NSString
                self.ShowAlertVC("Error", messageData: errorString as! String)
                print("Error login")
            }
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.current() != nil{
            self.performSegue(withIdentifier: "desdeLogin", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
