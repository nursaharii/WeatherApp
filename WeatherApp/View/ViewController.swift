//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import RxAlamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPhrase: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var city: UILabel!
    let locationManager = CLLocationManager()
    
    var lat = String() ; var cityName = String() ;  var lon = String() ;  var keyName = String()
    var Cities = [LocalCoordinate]()
    var County = [HourlyForecasts]()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("test"+lat)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //parseForecasts(keyName: keyName)
    }
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchVC" {
                    let destinationVC = segue.destination as! SearchVC
                }
    }*/
    
    func parse (lat:String,lon: String) {
        _ = json(.get,URL.localCoordinateUrl(lat: lat, lon: lon)).flatMap({ data -> Observable<Any> in
            let jsonData = JSON(data)
            let value = jsonData["Key"].stringValue
            let cityV = jsonData["LocalizedName"].stringValue
            self.city.text = cityV
            print("value:" + value)
            return json(.get,URL.hourlyForecasts(key: value))
        }).observe(on: MainScheduler.instance).subscribe{ [unowned self] in
            if let data = $0.element {
                let jsonData = JSON(data)
                let tempV = jsonData[0]["Temperature"]["Value"].stringValue
                let iconP = jsonData[0]["IconPhrase"].stringValue
                self.doSomething(iconPharse: iconP,temp: tempV)
            }
        }.disposed(by: disposeBag)
    }

    func doSomething(iconPharse: String,temp: String){
        self.iconPhrase.text = iconPharse
        self.temp.text = "\(temp) F°"
    }
  
   
    @objc func search() {
        lat = ""
        lon = ""
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
           //parseLocation(url: URL.localCoordinateUrl(lat: self.lat, lon: self.lon)!)
            parse(lat: lat,lon: lon)
        }
       // self.url = URL.localCoordinateUrl(lat: latitudeString, lon: longitudeString)
        
    }
}
