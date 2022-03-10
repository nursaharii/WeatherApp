//
//  CityDetailVC.swift
//  WeatherApp
//
//  Created by Nurşah on 10.03.2022.
//

import UIKit
import RxSwift
import RxAlamofire
import JGProgressHUD
import RxCocoa
import SwiftyJSON

class CityDetailVC: UIViewController {
    var disposeBag = DisposeBag()
    @IBOutlet weak var homeBtn: UIButton!
    let hud = JGProgressHUD(style: .light)
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var iconPhrase: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var precipitation: UILabel!
    var keyName = String()
    var cityName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconPhrase.adjustsFontSizeToFitWidth = true
        //city.adjustsFontSizeToFitWidth = true
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        if !keyName.isEmpty {
            parseForecasts(keyName: keyName)
        }
        
    }
    
    //MARK: parse
        func parseForecasts (keyName: String){
            let url = URL.hourlyForecasts(key: keyName)
            RxAlamofire.json(.get,url).observe(on: MainScheduler.instance).subscribe({ [unowned self] in
                if let data = $0.element {
                   let jsonData = JSON(data)
                    let tempV = jsonData[0]["Temperature"]["Value"].stringValue
                    let iconP = jsonData[0]["IconPhrase"].stringValue
                    let iconV = jsonData[0]["WeatherIcon"].stringValue
                    let precipitationV = jsonData[0]["PrecipitationProbability"].stringValue
                    self.doSomething(iconPharse: iconP,temp: tempV,icon: iconV,precipitation:precipitationV)
                }
            }).disposed(by: disposeBag)
            title = cityName
            self.city.text = cityName
         }

    func doSomething(iconPharse: String,temp: String,icon: String,precipitation: String){
        self.iconPhrase.text = iconPharse
        let tempC = convertToCelsius(fahrenheit: Double(temp) ?? 0.0)
        self.temp.text = "\(tempC) C° / \(temp) F°"
        self.img.image = UIImage(named: icon)
        self.precipitation.text = "🌧: %\(precipitation)"
        hud.dismiss()
    }

    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "goBack", sender: nil)
    }
    
    func convertToCelsius(fahrenheit: Double) -> Int {
        return Int(5.0 / 9.0 * (fahrenheit - 32.0))
    }
}


