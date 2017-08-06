//
//  ViewController.swift
//  weatherApp
//
//  Created by Karen Fuentes on 8/6/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import UIKit
class ForcastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let weatherEndPoint = "http://api.aerisapi.com/forecasts/11101?client_id=t3bblqduiR2oBUR04P4R9&client_secret=iddPKCKlS05RuMRlJv8v6f00zh0hV99ALVGN0qer"
    var weeklyWeather = [Forcast]()
    @IBOutlet weak var forcastTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        forcastTableView.delegate = self
        forcastTableView.dataSource = self
        getData()
 
    }
    
    func getData() {
        APIRequestManager.manager.getData(endPoint: weatherEndPoint) { (data:Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options: []) {
                    if let wholeDict = jsonData as? [String:Any],
                        let response = wholeDict["response"] as? [[String:Any]],
                        let object = response[0]["periods"] as? [[String:Any]] {
                        self.weeklyWeather = Forcast.parseForcast(from: object)
                       // dump(object)
                        dump(self.weeklyWeather)
                    
                        DispatchQueue.main.async {
                           self.forcastTableView.reloadData()

                        }
                    }
                }
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeather.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weather", for: indexPath) as! WeatherTableViewCell
        
        let isoDate = weeklyWeather[indexPath.row].dateTimeISO
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([ .month,.day], from: date)
        let finalDate = calendar.date(from:components)
        
        cell.maxTemp?.text = "Max: " + String(weeklyWeather[indexPath.row].maxTempC) + "°C"
        cell.minTemp?.text = "Min: " + String(weeklyWeather[indexPath.row].minTempC) + "°C"
        cell.date.text = String(describing: finalDate!)
        cell.weatherIcon.image = UIImage(named: weeklyWeather[indexPath.row].icon)
        return cell
    }
    
   


}

