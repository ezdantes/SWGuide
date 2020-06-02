//
//  SpaceShipViewController.swift
//  SW2
//
//  Created by Vladislav Barinov on 20.05.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SpaceShipViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var shipArray = Array<Ship>()
    var shipForSegue: Ship?
    
    let activityIndicator:UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.color = #colorLiteral(red: 0.3814989328, green: 0.7257468104, blue: 0.6625655293, alpha: 1)
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fetchData {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SpaceShipVC" {
            let secondShipVC = segue.destination as! SpaceShipDetailViewController
            
            if let ship = shipForSegue {
                secondShipVC.ship = ship
            }
        }
        
    }
    
    func fetchData(_ complition: @escaping () -> ()){
        guard let url = URL(string: "https://swapi.dev/api/starships") else { return }
        AF.request(url, method: .get).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                let jsonData = JSON(data)
                let resultArray = jsonData["results"].array
                
                for item in resultArray! {
                    let jsonShips = JSON(item)
                    
                    
                    let name = jsonShips["name"].stringValue
                    let model = jsonShips["model"].stringValue
                    let starshipClass = jsonShips["starship_class"].stringValue
                    let url = jsonShips["url"].stringValue
                    let ship = Ship(url: url, name: name, model: model, starshipClass: starshipClass)
                    self.shipArray.append(ship)
                }
                complition()
                
                
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error
                    .localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}
extension SpaceShipViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellShip", for: indexPath) as! ShipTableViewCell
          let ship = shipArray[indexPath.row]
        
        
        
      
        cell.nameLabel.text = ship.name
        cell.modelShipLabel.text = ship.model
        cell.classShipLabel.text = ship.starshipClass
        
        guard let imageUrl = URL(string: "https://starwars-visualguide.com/assets/img/starships/\(Helper.shered.getLastIndexFromUrl(ship.url) ?? 2).jpg") else { return cell }
        
        cell.shipImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "planet123"), options: .lowPriority)
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedShip = shipArray[indexPath.row]
        shipForSegue = selectedShip
        
        performSegue(withIdentifier: "SpaceShipVC", sender: self)
        
    }
    
}
