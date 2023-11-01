//
//  HomeViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class HomeViewController: UIViewController {

    
    private let dota2HeroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(dota2HeroesTableView)
        
        configureNavigationBarWithLogo()
        
        dota2HeroesTableView.delegate = self
        dota2HeroesTableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           dota2HeroesTableView.frame = view.frame
       }
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
         return cell
    }
}

/*
let headers = [
"X-RapidAPI-Key": "361176a0famsh390ccdf8f0c68bep11ebf4jsn4a36018de2de",
"X-RapidAPI-Host": "dota2-heroes.p.rapidapi.com"
]

let url = URL(string: "https://dota2-heroes.p.rapidapi.com/heroes/english")!

var request = URLRequest(url: url)
request.httpMethod = "GET"
request.allHTTPHeaderFields = headers

let session = URLSession.shared

let dataTask = session.dataTask(with: request) { (data, response, error) in
if let error = error {
    print("Помилка: \(error)")
} else if let data = data, let httpResponse = response as? HTTPURLResponse {
    if httpResponse.statusCode == 200 {
        do {
            // Обробка даних відповіді, наприклад, розпарсіння JSON:
            if let jsonText = String(data: data, encoding: .utf8) {
                   print("JSON-відповідь: \(jsonText)")
               
            }
        } catch {
            print("Помилка розпарсіння JSON: \(error)")
        }
    } else {
        print("Помилка сервера: Статус \(httpResponse.statusCode)")
    }
}
}
dataTask.resume()
*/
