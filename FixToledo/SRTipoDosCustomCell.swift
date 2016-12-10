//
//  SRTipoDosCustomCell.swift
//  App_Test_YOANA
//
//  Created by User on 16/11/16.
//  Copyright © 2016 icologic. All rights reserved.
//

import UIKit

class SRTipoDosCustomCell: UITableViewCell {
    
    @IBOutlet weak var tipo: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var estadoImagen: UIImageView!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var estado: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
