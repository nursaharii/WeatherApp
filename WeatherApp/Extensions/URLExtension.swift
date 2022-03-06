//
//  URLExtension.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import Foundation

extension URL {
    static func weatherCityUrl(city: String) -> URL? {
        return URL(string: "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=qevMCNGEVWocyBM07BYAmBHLFw7xSs4G&q=\(city)&language=tr-TR")
    }
    static func localCoordinateUrl(lat: String,lon: String)-> URL? {
        return URL(string: "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=qevMCNGEVWocyBM07BYAmBHLFw7xSs4G&q=\(lat)%2C\(lon)&language=tr-TR")
    }
    static func hourlyForecasts(city: String) -> URL? {
        return URL(string: "http://dataservice.accuweather.com/forecasts/v1/daily/1day/\(city)?apikey=qevMCNGEVWocyBM07BYAmBHLFw7xSs4G&language=tr-Tr")
    }
}
