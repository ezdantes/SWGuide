//
//  ViewController.swift
//  SW2
//
//  Created by Vladislav Barinov on 20.05.2020.
//  Copyright © 2020 Vladislav Barinov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    
    var arrayFilms = Array<Film>()
    
    let activityIndicator: UIActivityIndicatorView = {
       
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.startAnimating()
        ai.color = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        return ai
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "sw2"))
//        tableView.backgroundView?.alpha = 0.7
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
   
        getData {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
      
    }

 
    

    func getData(_ complition: @escaping () -> ()) {
        
              
              guard let url = URL(string: "https://swapi.dev/api/films") else { return }
              AF.request(url, method: .get).validate().responseJSON { (dateResponse) in
                  switch dateResponse.result {
                  case .success(let data):
                      let jsonData = JSON(data)
                      let jsonArray = jsonData["results"].array
                      
                      for item in jsonArray! {
                          let jsonItem = JSON(item)
                        let url = jsonItem["url"].stringValue
                          let episodeID = jsonItem["episode_id"].intValue
                          let title = jsonItem["title"].stringValue
                          let date = jsonItem["release_date"].stringValue
                          let director = jsonItem["director"].stringValue
                          
                          let film = Film(url: url, episodeID: episodeID, title: title, director: director, releaseDate: date)
                          self.arrayFilms.append(film)
                        
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
    

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilmTableViewCell
        let film = arrayFilms[indexPath.row]
        
     
        
        cell.nameLabel.text = film.title
        cell.dateLabel.text = film.releaseDate
        cell.descLabel.text = film.director
        
        guard let filmImgURL = URL(string: "https://starwars-visualguide.com/assets/img/films/\(film.episodeID ?? 1).jpg") else {return cell}
        
        cell.coverImage.sd_setImage(with: filmImgURL, placeholderImage: #imageLiteral(resourceName: "sw2"), options: .lowPriority)
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
     }
         
}
