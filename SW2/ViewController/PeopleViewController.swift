//
//  PeopleViewController.swift
//  SW2
//
//  Created by Vladislav Barinov on 23.05.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class PeopleViewController: UIViewController {
    
    var peopleArray = Array<People>()
    var peopleForSegue: People?
    
    
    let activityIndicator: UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
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
               if segue.identifier == "peopleVC" {
                   let peopleSecondVC = segue.destination as! PeopleDetailTableViewController
                   
                   if let people = peopleForSegue {
                    peopleSecondVC.people = people
                }
        }
        
        
    }
    func fetchData(_ complition: @escaping () -> ()) {
        guard let url = URL(string: "https://swapi.dev/api/people/") else { return }
             AF.request(url, method: .get).validate().responseJSON { (responseData) in
                 switch responseData.result {
                 case .success(let data):
                     let jsonData = JSON(data)
                     let resultArray = jsonData["results"].array
                     for item in resultArray! {
                         
                         let jsonPeople = JSON(item)
                         let name = jsonPeople["name"].stringValue
                         let url = jsonPeople["url"].stringValue
                         let people = People(url: url, name: name)
                         self.peopleArray.append(people)
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

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleTableViewCell
        let people = peopleArray[indexPath.row]
        
        cell.nameLabel.text = people.name
        
        guard let peopleUrl = URL(string: "https://starwars-visualguide.com/assets/img/characters/\(Helper.shered.getLastIndexFromUrl(people.url) ?? 2).jpg") else { return cell }
        cell.peopleImage.sd_setImage(with: peopleUrl, placeholderImage: #imageLiteral(resourceName: "people"), options: .lowPriority)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedPeople = peopleArray[indexPath.row]
        peopleForSegue = selectedPeople
        
        performSegue(withIdentifier: "peopleVC", sender: self)
        
    }
    
    
}
