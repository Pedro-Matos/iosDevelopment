//
//  LocationsTableViewCell.swift
//  GeoMapping-Swift
//
//  Created by Pedro Ferreira de Matos on 18/05/17.
//  Copyright © 2017 Pedro Ferreira de Matos. All rights reserved.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var coords: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
