//
//  citybyName.swift
//  WeatherApp
//
//  Created by Nurşah on 6.03.2022.
//

import Foundation

struct CitybyName: Codable {
    let key: String
    let country:CountryDetail, cityDetail: CityDetail

    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case country = "Country"
        case cityDetail = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea
struct CityDetail: Codable {
    let id, localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

struct CountryDetail : Codable {
    let localizedName, englishName: String
}
