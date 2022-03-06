//
//  OneDayForecast.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import Foundation

struct HourlyForecasts: Decodable {
    let dateTime: String
    let weatherIcon: Int
    let iconPhrase: String
    let hasPrecipitation, isDaylight: Bool
    let temperature: Temperature
    let precipitationProbability: Int
    
    enum CodingKeys: String, CodingKey {
            case dateTime = "DateTime"
            case weatherIcon = "WeatherIcon"
            case iconPhrase = "IconPhrase"
            case hasPrecipitation = "HasPrecipitation"
            case isDaylight = "IsDaylight"
            case temperature = "Temperature"
            case precipitationProbability = "PrecipitationProbability"
        }
}

// MARK: - Temperature
struct Temperature: Decodable {
    let value: Int
    let unit: String
    
    enum CodingKeys: String, CodingKey {
            case value = "Value"
            case unit = "Unit"
        }
}
