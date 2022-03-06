//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import UIKit
import Alamofire
import CoreLocation
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPhrase: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var city: UILabel!
    let locationManager = CLLocationManager()
    var url = URL(string: "")
    var lat = String()
    var lon = String()
    var Cities = [LocalCoordinate]()
    var key = String()
    var County = [HourlyForecasts]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        print(lat)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchVC" {
                    let destinationVC = segue.destination as! SearchVC
                }
    }
    

    
   func parseLocation (url:URL) {
        AF.request(url).validate().responseDecodable(of: LocalCoordinate.self) { response in
            guard let cities = response.value else {return}
            self.city.text = cities.city.localizedName
            self.key = cities.key
            self.parseForecasts(url: URL.hourlyForecasts(city: self.key)!)
            
        }
    }
    
   func parseForecasts (url: URL){
        AF.request(url).validate().responseDecodable(of: HourlyForecasts.self) { response in
            guard let forecasts = response.value else {return}
            
        }
        
    }
    
   
    
    @objc func search() {
        
        performSegue(withIdentifier: "toSearchVC", sender: nil)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        self.lat = String(location.latitude)
        self.lon = String(location.longitude)
        if !lat.isEmpty && !lon.isEmpty {
            parseLocation(url: URL.localCoordinateUrl(lat: self.lat, lon: self.lon)!)
        }
       // self.url = URL.localCoordinateUrl(lat: latitudeString, lon: longitudeString)
        
    }
}
