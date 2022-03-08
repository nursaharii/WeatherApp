//
//  LocalCoordinate.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import Foundation

struct LocalCoordinate: Decodable {
    let key: String
    let city: City

    enum CodingKeys: String, CodingKey {
        case key = "Key"
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

