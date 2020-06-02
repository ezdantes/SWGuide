//
//  SpaceShipDetailViewController.swift
//  SW2
//
//  Created by Vladislav Barinov on 31.05.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import UIKit

class SpaceShipDetailViewController: UIViewController {
    
    var ship: Ship?

    @IBOutlet weak var spaceShipName: UILabel!
    @IBOutlet weak var spaceShipImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spaceShipName.text = ship?.name

    }
    

   

}
