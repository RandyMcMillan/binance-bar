//
//  PreferencesWindow.swift
//  BinanceBar
//
//  Created by Ian Grail on 12/26/17.
//  Copyright © 2017 Ian Grail. All rights reserved.
//

import Cocoa

let DEFAULT_SYMBOL = "ETHBTC"

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var symbolTextField: NSTextField!
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName : NSNib.Name? {
        return NSNib.Name("PreferencesWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        let defaults = UserDefaults.standard
        let city = defaults.string(forKey: "symbol") ?? DEFAULT_SYMBOL
        symbolTextField.stringValue = city
    }
    
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(symbolTextField.stringValue, forKey: "symbol")
        delegate?.preferencesDidUpdate()
    }
}
