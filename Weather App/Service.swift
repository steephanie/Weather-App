//
//  Service.swift
//  Weather App
//
//  Created by Stephanie Silva on 06/02/24.
//

import Foundation
import CoreLocation

class Service {
    
    private let apiKey: String = "579be2bd9097eaca1d67fc6088f30bc5"
    private let session = URLSession.shared
    
    func fecthData(coord: Coord, _ completion: @escaping (ForecastResponse?) -> Void) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coord.lat)&lon=\(coord.lon)&lang=pt_br&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(nil)
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(forecastResponse)
            } catch {
                print(String(data: data, encoding: .utf8) ?? "")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
}

// MARK: - ForecastResponse
struct ForecastResponse: Codable {
    var coord: Coord
    let current: Forecast
    let hourly: [Forecast]
    let daily: [DailyForecast]
}

// MARK: - Coord
struct Coord: Codable {
    var lon, lat: Double
    let name: String
}

// MARK: - Forecast
struct Forecast: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, temp, humidity
        case windSpeed = "wind_speed"
        case weather
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - DailyForecast
struct DailyForecast: Codable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
