//
//  BinanceAPI.swift
//  BinanceBar
//
//  Created by Ian Grail on 12/26/17.
//  Copyright © 2017 Ian Grail. All rights reserved.
//

import Foundation

class BinanceAPI {
    let API_KEY = "your-api-key-here"
    let BASE_URL = "https://api.binance.com/"
    let ENDPOINT = "api/v1/ticker/allPrices"
    
    struct Ticker {
        var symbol: String
        var price: String
    }
    
    func tickersFromJSONData(_ data: Data) -> [Ticker]? {
        typealias JSONDict = [[String: Any]]
        let json : JSONDict

        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var tickers: [Ticker] = [];
        for item in json {
            let ticker = Ticker(
                symbol: item["symbol"] as! String,
                price: item["price"] as! String
            )
            tickers.append(ticker)
        }
        
        return tickers
    }
    
    func updateTickers(success: @escaping ([Ticker]) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "\(BASE_URL)\(ENDPOINT)")
        let task = session.dataTask(with: url!) { data, response, err in
            // first check for a hard error
            if let error = err {
                NSLog("binance api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let tickers = self.tickersFromJSONData(data!) {
                        success(tickers)
                    }
                case 401: // unauthorized
                    NSLog("binance api returned an 'unauthorized' response. Did you set your API key?")
                default:
                    NSLog("binance api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
}
