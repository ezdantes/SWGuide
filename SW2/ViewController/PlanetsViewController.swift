//
//  PlanetsViewController.swift
//  SW2
//
//  Created by Vladislav Barinov on 22.05.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class PlanetsViewController: UIViewController {
    
    var planetArray = Array<Planet>()
    var planetForSegue: Planet?
    
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        ai.hidesWhenStopped = true
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
               activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fetchData {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "planetVC" {
            let planetSecondVC = segue.destination as! PlanetDetailViewController
          
            if let planet = planetForSegue {
                planetSecondVC.planet = planet
            }
        }
    }
    
    func fetchData(_ complition: @escaping () -> ()) {
        
        guard let url = URL(string: "https://swapi.dev/api/planets/") else { return }
        AF.request(url, method: .get).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                let jsonData = JSON(data)
                let resultArray = jsonData["results"].array
                for item in resultArray! {
                    
                    
                    let jsonPlanet = JSON(item)
                    let name = jsonPlanet["name"].stringValue
                    let population = jsonPlanet["population"].stringValue
                    let diameeter = jsonPlanet["diameter"].stringValue
                    let url = jsonPlanet["url"].stringValue
                    
                    let planet = Planet(url: url, name: name, population: population, diameter: diameeter)
                    self.planetArray.append(planet)
                }
                
                complition()

            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
}

extension PlanetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath) as! PlanetTableViewCell
        let planet = planetArray[indexPath.row]
        
        
      
        cell.planetName.text = planet.name
        cell.diameterLabel.text = planet.diameter
        cell.populationLabel.text = planet.population
        
        guard let imageUrl = URL(string: "https://starwars-visualguide.com/assets/img/planets/\(Helper.shered.getLastIndexFromUrl(planet.url) ?? 2).jpg") else { return cell }
        cell.planetImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "planets"), options: .lowPriority)
        
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPlanet = planetArray[indexPath.row]
        planetForSegue = selectedPlanet
       
        
        performSegue(withIdentifier: "planetVC", sender: self)
    }
}
