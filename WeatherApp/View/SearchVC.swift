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
    var dictionary : [String:String] = [:]
    var userDF : [String:String] = [:]
    let storedName = UserDefaults.standard
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Şehir Seçimi"
        searchBar.delegate = self
        userDF = UserDefaults.standard.object(forKey: "key") as? [String:String] ?? [:]
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userDF.count
    }
    //MARK: numberOfRowsInSection içerisinde dönen değer kadar veriyi tablo içerisinde göstermek için kullanılır.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        var content = cell.defaultContentConfiguration()
        let array = Array(userDF.keys)//UserDefaults Dictionary olarak tanımlandığı için öncelikle keyler Array içerisine alındı.
        let city = array[indexPath.row] // tablo satırlarında bulunan key değerleri çekildi ve value'lar text olarak yazıldı.
        content.text = userDF[city]
        cell.contentConfiguration = content
        return cell
    }
    //MARK: Seçilen veri değererinin detay sayfasına aktarılma işini yapan fonksiyon
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let array = Array(userDF.keys)
        selectedItem = array[indexPath.row]
        self.key = selectedItem
        self.cityName = userDF[self.key] ?? ""
        performSegue(withIdentifier: "toCityDetail", sender: nil)
    }
    
    //MARK: geoposition api verilerini çekmek için yazıldı.
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
        }).disposed(by: disposeBag)
        hud.dismiss()
    }
    
    func getData(key: String,city: String) {
        if userDF.count == 5 {
            userDF.removeValue(forKey: userDF.first!.key)
        }
        filteredCities.append(city)
       
        userDF[key] = city
        UserDefaults.standard.set(userDF,forKey: "key")
        tableView.reloadData()
    }
    //MARK: Detay sayfasına navigate edilirken bu sayfadan yollanacak veriler tanımlandı.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCityDetail" {
            let destinatonVC = segue.destination as! CityDetailVC
            destinatonVC.keyName = key
            destinatonVC.cityName = cityName
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
    // Arama yapıldıktan sonra enter tuşu ile arama yapılabilmesi sağlandı.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.lowerSearch = searchBar.text!.lowercased()
        citybyNameParse(city: self.lowerSearch)
        self.search()
        
    }
    //Cencel butonuna tıklanınca çalışan foksiyon
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.lowerSearch = ""
        searchBar.resignFirstResponder()
        self.search()
        tableView.reloadData()
    }
}
