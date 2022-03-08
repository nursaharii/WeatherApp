//
//  URLExtension.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import Foundation

extension URL {
    static func weatherCityUrl(city: String) -> String {
        return  "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=cId7nh27mDivBhAO3s9u4cuBqCiLihbu&q=\(city)"
    }
    static func localCoordinateUrl(lat: String,lon: String)-> String {
        return "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=cId7nh27mDivBhAO3s9u4cuBqCiLihbu&q=\(lat)%2C\(lon)"
    }
    static func hourlyForecasts(key: String) -> String {
        return "http://dataservice.accuweather.com/forecasts/v1/hourly/1hour/\(key)?apikey=cId7nh27mDivBhAO3s9u4cuBqCiLihbu"
    }
}
