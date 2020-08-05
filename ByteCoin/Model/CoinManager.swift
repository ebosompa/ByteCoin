//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ coinManager: CoinManager, price : Double)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
//bitcoin average

    
    let baseURL = "https://bitcoinaverage-global-bitcoin-index-v1.p.rapidapi.com/indices/global/ticker/BTC"
    //&fiat=jpy&rapidapi-key="
    
    
    
    var delegate: CoinManagerDelegate?
    
    //coinapi
    //let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    //let apiKey = "YOUR_API_KEY_HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)?rapidapi-key=\(K.apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    //var backToString = String(data: safeData, encoding: String.Encoding.utf8) as String?
                    //print(backToString ?? "Nil")
                    if let coinData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, price: coinData)
                        //print(coinData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let last = decodedData.last
            return last
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}


