//
//  Forcast.swift
//  weatherApp
//
//  Created by Karen Fuentes on 8/6/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import Foundation
class Forcast {
    var maxTempC: Int
    var maxTempF: Int
    var minTempC: Int
    var minTempF: Int
    var dateTimeISO: String
    var icon: String
    
    init?(from Dict: [String: Any]) {
        if let maxC = Dict["maxTempC"] as? Int,
            let maxF = Dict["maxTempF"] as? Int,
            let minC = Dict["minTempC"] as? Int,
            let minF = Dict["minTempF"] as? Int,
            let timeStamp = Dict["dateTimeISO"] as? String,
            let icon = Dict["icon"] as? String {
                self.maxTempC = maxC
                self.maxTempF = maxF
                self.minTempC = minC
                self.minTempF = minF
                self.dateTimeISO = timeStamp
                self.icon = icon
        }
        else {
            return nil
        }
    }
    static func parseForcast(from array:[[String:Any]]) -> [Forcast] {
        var weather = [Forcast]()
        for forcastDict in array {
            if let dailyWeather = Forcast(from: forcastDict) {
                weather.append(dailyWeather)
            }
        }
        return weather
    }
}
