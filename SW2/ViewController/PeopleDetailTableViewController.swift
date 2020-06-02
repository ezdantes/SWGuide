//
//  PeopleDetailTableViewController.swift
//  SW2
//
//  Created by Vladislav Barinov on 01.06.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import Foundation
import UIKit




class PeopleDetailTableViewController: UITableViewController {
    var people: People?
    
    @IBOutlet weak var namePeople: UILabel!
    @IBOutlet weak var imagePeople: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        namePeople.text = people?.name
        
        guard let peopleUrl = URL(string: "https://starwars-visualguide.com/assets/img/characters/\(Helper.shered.getLastIndexFromUrl(people?.url) ?? 2).jpg") else { return }
               imagePeople.sd_setImage(with: peopleUrl, placeholderImage: #imageLiteral(resourceName: "peple"), options: .lowPriority)
    }
}
