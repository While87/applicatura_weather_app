//
//  WeatherData.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 15.09.2021.
//

import Foundation

struct WeatherData: Codable {
    let current: Current
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Date
    let temp: Float
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Date
    let humidity: Float
    let wind_speed: Float
    let temp: Temp
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Float
}

struct Temp: Codable {
    let day: Float
    let night: Float
}
