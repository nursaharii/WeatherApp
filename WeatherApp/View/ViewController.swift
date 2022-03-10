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
import JGProgressHUD

class ViewController: UIViewController {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPhrase: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var precipitation: UILabel!
    let locationManager = CLLocationManager()
    let hud = JGProgressHUD(style: .light)
    var lat = String() ; var lon = String()
    var Cities = [LocalCoordinate]()
    var County = [HourlyForecasts]()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconPhrase.adjustsFontSizeToFitWidth = true
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search)) // Arama butonu
        
        //MARK: Uygulama açıldığı an kullanıcının konumunu alabilmek için viewDidLoad içerisine yazıldı.(CoreLocation)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    //MARK: Zincirleme API verisi çekmek için yazıldı.(RxAlamofire,RxSwift ve SwiftyJSON)
    func parse (lat:String,lon: String) {
        _ = json(.get,URL.localCoordinateUrl(lat: lat, lon: lon)).flatMap({ data -> Observable<Any> in
            let jsonData = JSON(data)
            let value = jsonData["Key"].stringValue
            let cityV = jsonData["LocalizedName"].stringValue
            self.city.text = cityV
            return json(.get,URL.hourlyForecasts(key: value))
        }).observe(on: MainScheduler.instance).subscribe{ [unowned self] in
            if let data = $0.element {
                let jsonData = JSON(data)
                let tempV = jsonData[0]["Temperature"]["Value"].stringValue
                let iconP = jsonData[0]["IconPhrase"].stringValue
                let iconV = jsonData[0]["WeatherIcon"].stringValue
                let precipitationV = jsonData[0]["PrecipitationProbability"].stringValue
                self.doSomething(iconPharse: iconP,temp: tempV,icon : iconV,precipitation: precipitationV)
            }
        }.disposed(by: disposeBag)
        
    }
    
    //MARK: parse fonksiyonu içerisinde birden fazla iş yapmamak için ayrı bir fonksiyon yazıldı. fonksiyon içerisindeki değişkenler parse fonksiyonunun JSON verilerinden basleniyor.
    func doSomething(iconPharse: String,temp: String,icon: String,precipitation:String){
            self.iconPhrase.text = iconPharse
            let tempC = convertToCelsius(fahrenheit: Double(temp) ?? 0.0)
            self.temp.text = "\(tempC) C° / \(temp) F°"
            self.icon.image = UIImage(named: icon)
            self.precipitation.text = "🌧: %\(precipitation)"
            hud.dismiss()
        }
        
    //MARK: viewDiLoad içinde oluşturulmuş BarButton'un ne yapacağını belirlemek için yazılan fonksiyon
        @objc func search() {
            performSegue(withIdentifier: "toSearchVC", sender: nil)
        
        }
        //MARK: Fahrenhiet to Celsius
        func convertToCelsius(fahrenheit: Double) -> Int {
            return Int(5.0 / 9.0 * (fahrenheit - 32.0))
        }
}

//MARK: - CLLocationManagerDelegate


extension ViewController: CLLocationManagerDelegate {
    //MARK: Kullanıcı konum bilgilerini almak için yazıldı. parse fonksiyonu bu fonksiyonda alınan lat ve lon değişkenlerinden beslenmekte.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        self.lat = String(location.latitude)
        self.lon = String(location.longitude)
        if !lat.isEmpty && !lon.isEmpty{
            parse(lat: lat,lon: lon)
        }
    }
}
