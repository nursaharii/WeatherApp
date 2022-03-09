//
//  SearchVC.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import UIKit
import RxAlamofire
import RxSwift
import RxCocoa
import SwiftyJSON
import JGProgressHUD

class SearchVC: UITableViewController {
    var key = String()
    var cityName = String()
    var lowerSearch = String()
    var cities : [String] = []
    var filteredCities: [String] = []
    var selectedItem = String()
    var disposeBag = DisposeBag()
    var dictionary = 
    let storedName = UserDefaults.standard.object(forKey: "city")
    let storedKey = UserDefaults.standard.object(forKey: "key")
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Şehir Seçimi"
        searchBar.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        var content = cell.defaultContentConfiguration()
        let city = filteredCities[indexPath.row]
        content.text = city
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = filteredCities[indexPath.row]
        performSegue(withIdentifier: "toMainVC", sender: nil)
        
    }
    
    func citybyNameParse(city : String) {
        let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "Loading"
                hud.show(in: self.view)
        RxAlamofire.json(.get,URL.weatherCityUrl(city: city)).observe(on: MainScheduler.instance).subscribe({ [unowned self] in
            if let data = $0.element {
                let jsonData = JSON(data)
                let keyV = jsonData[0]["Key"].stringValue
                let cityV = jsonData[0]["AdministrativeArea"]["LocalizedName"].stringValue
                getData(key: keyV,city: cityV)
                
            }
        })
        hud.dismiss()
    }
    
    func getData(key: String,city: String) {
        self.cityName = city
        self.key = key
        filteredCities.append(city)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainVC" {
            let destinatonVC = segue.destination as! ViewController
            destinatonVC.keyName = key
            destinatonVC.cityName = lowerSearch
        }
    }
    
    func search() {
        if lowerSearch.isEmpty {
            filteredCities = cities
            return
        }
        filteredCities = cities.filter({ city in
            if let _ = city.lowercased().range(of: searchBar.text!, options: .caseInsensitive) {
                return true
            }
            return false
        })
        
        
    }
}


// MARK: - UISearchBarDelegate

extension SearchVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.lowerSearch = searchBar.text!.lowercased()
        citybyNameParse(city: self.lowerSearch)
        self.search()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.lowerSearch = ""
        searchBar.resignFirstResponder()
        self.search()
        tableView.reloadData()
    }
}
