//
//  IncidenciaModel.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 13/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import Foundation
import UIKit
import Parse

class IncidenciaModel: NSObject {
    
    var descripcion : String?
    var username : String?
    var foto : PFFile?
    var estado : String?
    var tipo : String?
    var coordenadas : PFGeoPoint?
    var calle : String?
    var fecha : String?
    var titulo : String?
    
    init(aTitulo : String, aDescripcion : String, aUsername : String, aEstado : String, aTipo : String, aCoordenadas : PFGeoPoint, aFecha : String){
        self.descripcion = aDescripcion
        self.username = aUsername
        self.estado = aEstado
        self.tipo = aTipo
        self.coordenadas = aCoordenadas
        self.fecha = aFecha
        self.titulo = aTitulo
        super.init()
    }
}
