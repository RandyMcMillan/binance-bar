//
//  TickersView.swift
//  BinanceBar
//
//  Created by Ian Grail on 12/26/17.
//  Copyright © 2017 Ian Grail. All rights reserved.
//

import Cocoa

var tickers: [BinanceAPI.Ticker] = []

class TickersView: NSView {

    @IBOutlet weak var symbolField: NSTextField!
    @IBOutlet weak var priceField: NSTextField!
    @IBOutlet weak var table: NSTableView!
    
    func update(_ _tickers: [BinanceAPI.Ticker]) {
        tickers = _tickers
        let defaults = UserDefaults.standard
        let symbol = defaults.string(forKey: "symbol") ?? DEFAULT_SYMBOL
        var ticker: BinanceAPI.Ticker = tickers[0]
        for item in tickers {
            if (item.symbol == symbol) {
                ticker = item
                // do UI updates on the main thread
                DispatchQueue.main.async {
                    self.symbolField.stringValue = ticker.symbol
                    self.priceField.stringValue = ticker.price
                }
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return tickers[row]
    }
    
}
