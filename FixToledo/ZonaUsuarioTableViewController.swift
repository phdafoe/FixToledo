//
//  ZonaUsuarioTableViewController.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 26/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import UIKit
import Parse

class ZonaUsuarioTableViewController: UITableViewController {
    
    var listaIncidencias = [IncidenciaModel]()
    
    @IBAction func volverAHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cerrarSesion(_ sender: Any) {
        PFUser.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SRTipoTresCustomCell", bundle: nil), forCellReuseIdentifier: "TipoTresCustomCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        traerIncidencias()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaIncidencias.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipoTresCustomCell", for: indexPath) as! SRTipoTresCustomCell
        let objeto = listaIncidencias[indexPath.row]
        
        cell.titulo.text = objeto.titulo
        cell.descripcion.text = objeto.descripcion
        cell.fecha.text = objeto.fecha
        cell.tipo.text = objeto.tipo
        //cell.estado.text = objeto.estado
        //cell.estadoImagen.image = dameImagenEstado(nombre: objeto.estado!)
        cell.imagenEstado.image = dameImagenEstado(nombre: objeto.estado!)
        
        objeto.foto?.getDataInBackground{(imageData, error) in
            if error == nil{
                let imageDownloaded = UIImage(data: imageData!)
                cell.imagen.image = imageDownloaded
            }else{
                print("Error en imagen \(indexPath.row)")
            }
        }
        
        if ((indexPath.row % 2) == 1) {
            cell.backgroundColor = UIColor(red:1, green:0.97, blue:0.86, alpha:1.0)//corn silk
        }
        else
        {
            //cell.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0) //white smoke
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 110
        //return 280 //tipo 2
        return 192 //tipo 3
    }

    func traerIncidencias(){
        let query = PFQuery(className: "Incidencia")
        query.whereKey("username", equalTo: (PFUser.current()?.username)!)
        
        listaIncidencias.removeAll()
        query.findObjectsInBackground{
            (objects: [PFObject]?, error) -> Void in
            if error == nil{
                if let objectsData = objects{
                    for object in objectsData{
                        /*
                         let postFinal = ECArrayParseDownload(aDescripcionData: object["descriptionData"] as! String,
                         aUsernameData: object["username"] as! String,
                         aImageData: object["imageFile"] as! PFFile)
                         self.postDataParse.append(postFinal)*/
                        let incidencia = IncidenciaModel(aTitulo: object["titulo"] as! String,
                                                         aDescripcion: object["descripcion"] as! String,
                                                         aUsername: object["username"] as! String,
                                                         aEstado: object["estado"] as! String,
                                                         aTipo: object["tipo"] as! String,
                                                         aCoordenadas: object["location"] as! PFGeoPoint,
                                                         aFecha: object["fecha"] as! String)
                        incidencia.foto = object["imagen"] as? PFFile
                        self.listaIncidencias.append(incidencia)
                    }
                    self.tableView.reloadData()
                }
            }else{
                print("Error: \(error!)")
            }
        }
    }
    func dameImagenEstado(nombre : String) -> UIImage{
        var i = ""
        switch nombre {
        case "Pendiente":
            i = "iconoEnRevision"
            break
        case "En proceso":
            i = "iconoTrabajando"
            break
        case "Resuelta":
            i = "iconoTrabajoRealizado"
        default:
            i = "iconoRechazado"
        }
        return UIImage(named: i)!
    }

}
