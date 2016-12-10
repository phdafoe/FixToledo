//
//  ViewController.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 8/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let configuracionVC = self.storyboard?.instantiateViewController(withIdentifier: "homeTableViewController") as! HomeTableViewController
        let navController = UINavigationController(rootViewController: configuracionVC)
        self.present(navController, animated: true, completion: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

