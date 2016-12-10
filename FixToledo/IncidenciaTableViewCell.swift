//
//  IncidenciaTableViewCell.swift
//  FixToledo
//
//  Created by Yoana Ugarte García on 13/11/16.
//  Copyright © 2016 Yoana Ugarte García. All rights reserved.
//

import UIKit

class IncidenciaTableViewCell: UITableViewCell {

    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var imagenEstado: UIImageView!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var tipo: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
