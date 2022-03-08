//
//  citybyName.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import Foundation

struct CitybyName: Decodable {
    let key: String, cityDetail: [CityDetail]

    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case cityDetail = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea
struct CityDetail: Decodable {
    let id, localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

