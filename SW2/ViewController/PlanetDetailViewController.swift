//
//  PlanetDetailViewController.swift
//  SW2
//
//  Created by Vladislav Barinov on 29.05.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import UIKit
import SDWebImage

class PlanetDetailViewController: UIViewController {
    @IBOutlet weak var planetImage: UIImageView!
    
    @IBOutlet weak var planetName: UILabel!
    var planet: Planet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planetName.text = planet?.name
        
        guard let imageUrl = URL(string: "https://starwars-visualguide.com/assets/img/planets/\(Helper.shered.getLastIndexFromUrl(planet?.url) ?? 2).jpg") else { return }
        
        planetImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "planet123"), options: .lowPriority)
    }
  

}
