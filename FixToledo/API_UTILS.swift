//
//  API_UTILS.swift
//  FixToledo
//
//  Created by User on 10/12/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import Foundation
import UIKit


func muestraAlertVC(_ titleData : String, messageData : String) -> UIAlertController {
    let alertVC = UIAlertController(title: titleData, message: messageData, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alertVC
}
