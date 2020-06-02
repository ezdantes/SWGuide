//
//  PlanetTableViewCell.swift
//  SW2
//
//  Created by Vladislav Barinov on 22.05.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import UIKit

class PlanetTableViewCell: UITableViewCell {
    @IBOutlet weak var planetImage: UIImageView!
    
    @IBOutlet weak var planetName: UILabel!
    
    @IBOutlet weak var populationLabel: UILabel!
    
    @IBOutlet weak var diameterLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
