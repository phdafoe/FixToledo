//
//  HomeTableViewController.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 13/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import UIKit
import Parse

class HomeTableViewController: UITableViewController {
    
    var listaIncidencias = [IncidenciaModel]()
    
    let objetoPrueba = IncidenciaModel(aTitulo: "Título de la incidencia", aDescripcion: "Descripción de la incidencia con toda la información que se considere necesaria", aUsername: "yo", aEstado: "Pendiente", aTipo: "Daño en acera", aCoordenadas: PFGeoPoint(latitude:37.708813, longitude:-122.526398), aFecha : "")
    
    @IBAction func irNuevaIncidencia(_ sender: Any) {
        if PFUser.current() != nil{
            let configuracionVC = self.storyboard?.instantiateViewController(withIdentifier: "nuevaIncidenciaViewController") as! NuevaIncidenciaViewController
            let navController = UINavigationController(rootViewController: configuracionVC)
            self.present(navController, animated: true, completion: nil)
        }else{
            /*
            let configuracionVC = self.storyboard?.instantiateViewController(withIdentifier: "nuevaIncidenciaViewController") as! NuevaIncidenciaViewController
            let navController = UINavigationController(rootViewController: configuracionVC)
            self.present(navController, animated: true, completion: nil)
            */
            let configuracionVC = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: configuracionVC)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func irZonaUsuario(_ sender: Any) {
        if PFUser.current() != nil{
            //ZonaUsuarioTableViewController
            let configuracionVC = self.storyboard?.instantiateViewController(withIdentifier: "zonaUsuarioTableViewController") as! ZonaUsuarioTableViewController
            let navController = UINavigationController(rootViewController: configuracionVC)
            self.present(navController, animated: true, completion: nil)
        }else{
            let configuracionVC = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: configuracionVC)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.register(UINib(nibName: "IncidenciaTableViewCell", bundle: nil), forCellReuseIdentifier: "incidenciaTableViewCell")
        tableView.register(UINib(nibName: "SRTipoDosCustomCell", bundle: nil), forCellReuseIdentifier: "TipoDosCustomCell")
        tableView.register(UINib(nibName: "SRTipoTresCustomCell", bundle: nil), forCellReuseIdentifier: "TipoTresCustomCell")
        
        //traerIncidencias()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        traerIncidencias()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 10
        return listaIncidencias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objeto = listaIncidencias[indexPath.row]
        if listaIncidencias[indexPath.row].tipo == "Seguridad"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipoTresCustomCell", for: indexPath) as! SRTipoTresCustomCell
            cell.titulo.text = objeto.titulo
            cell.descripcion.text = objeto.descripcion
            cell.fecha.text = objeto.fecha
            cell.tipo.text = objeto.tipo
            cell.imagenEstado.image = dameImagenEstado(nombre: objeto.estado!)
            
            objeto.foto?.getDataInBackground{(imageData, error) in
                if error == nil{
                    let imageDownloaded = UIImage(data: imageData!)
                    cell.imagen.image = imageDownloaded
                }else{
                    print("Error en imagen \(indexPath.row)")
                }
            }
            cell.estado.text = objeto.estado
            return cell
        }else if listaIncidencias[indexPath.row].tipo == "Alumbrado"{
            let cellDos = tableView.dequeueReusableCell(withIdentifier: "TipoDosCustomCell", for: indexPath) as! SRTipoDosCustomCell
            cellDos.titulo.text = objeto.titulo
            cellDos.descripcion.text = objeto.descripcion
            cellDos.fecha.text = objeto.fecha
            cellDos.tipo.text = objeto.tipo
            cellDos.estadoImagen.image = dameImagenEstado(nombre: objeto.estado!)
            objeto.foto?.getDataInBackground{(imageData, error) in
                if error == nil{
                    let imageDownloaded = UIImage(data: imageData!)
                    cellDos.imagen.image = imageDownloaded
                }else{
                    print("Error en imagen \(indexPath.row)")
                }
            }
            cellDos.estado.text = objeto.estado
            return cellDos
        }else{
            
            let cellTres = tableView.dequeueReusableCell(withIdentifier: "incidenciaTableViewCell", for: indexPath) as! IncidenciaTableViewCell
            cellTres.titulo.text = objeto.titulo
            cellTres.descripcion.text = objeto.descripcion
            cellTres.fecha.text = objeto.fecha
            cellTres.tipo.text = objeto.tipo
            cellTres.imagenEstado.image = dameImagenEstado(nombre: objeto.estado!)
            objeto.foto?.getDataInBackground{(imageData, error) in
                if error == nil{
                    let imageDownloaded = UIImage(data: imageData!)
                    cellTres.foto.image = imageDownloaded
                }else{
                    print("Error en imagen \(indexPath.row)")
                }
            }
            cellTres.estado.text = objeto.estado
            return cellTres
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if listaIncidencias[indexPath.row].tipo == "Seguridad"{
            return 280
        }else if listaIncidencias[indexPath.row].tipo == "Alumbrado"{
            return 280
        }else{
            return 238
        }
        
    }
    
    func traerIncidencias(){
        let query = PFQuery(className: "Incidencia")
        
        //query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        listaIncidencias.removeAll()
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground{
            (objects: [PFObject]?, error) -> Void in
            if error == nil{
                if let objectsData = objects{
                    for object in objectsData{
                        
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
                    /*
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
                     */
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let incidencia = listaIncidencias[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "vistaIncidenciaViewController") as! VistaIncidenciaViewController
        vc.incidencia = incidencia
        navigationController?.pushViewController(vc, animated: true)
    }
    
   

}
