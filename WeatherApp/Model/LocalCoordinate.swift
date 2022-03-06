//
//  LocalCoordinate.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import Foundation

struct LocalCoordinate: Decodable {
    let key: String
    let country: Country
    let city: City

    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case country = "Country"
        case city = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea
struct City: Decodable {
    let localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

// MARK: - Country
struct Country: Decodable {
    let localizedName: String

    enum CodingKeys: String, CodingKey {
        case localizedName = "LocalizedName"
    }
}
