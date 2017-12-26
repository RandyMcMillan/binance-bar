//
//  StatusMenuController.swift
//  BinanceBar
//
//  Created by Ian Grail on 12/26/17.
//  Copyright © 2017 Ian Grail. All rights reserved.
//
// Ref: http://footle.org/WeatherBar/
//

import Cocoa

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var tickersView: TickersView!
    var tickersMenuItem: NSMenuItem!
    var preferencesWindow: PreferencesWindow!
    var updateTimer: Timer!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let binanceApi = BinanceAPI()
    
    override func awakeFromNib() {
        statusItem.title = "BinanceBar"
        statusItem.menu = statusMenu
        let icon = NSImage(named: NSImage.Name("statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        tickersMenuItem = statusMenu.item(withTitle: "Tickers")
        tickersMenuItem.view = tickersView
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self
        schedUpdate()
    }
    
    func schedUpdate() {
        updateTickers()
        if (updateTimer != nil) {
            updateTimer.invalidate()
        }
        updateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateTickers), userInfo: nil, repeats: true)
    }
    
    @objc func updateTickers() {
        let defaults = UserDefaults.standard
        let symbol = defaults.string(forKey: "symbol") ?? DEFAULT_SYMBOL
        
        binanceApi.updateTickers() { tickers in
            var ticker: BinanceAPI.Ticker = tickers[0]
            for item in tickers {
                if (item.symbol == symbol) {
                    ticker = item
                }
            }
            let selected = "\(ticker.symbol) - \(ticker.price)"
            NSLog(selected)
            
            // do UI updates on the main thread
            DispatchQueue.main.async {
                self.statusItem.title = selected
                self.tickersView.update(tickers)
            }
        }
    }
    
    func preferencesDidUpdate() {
        schedUpdate()
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        schedUpdate()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
