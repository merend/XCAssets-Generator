//
//  AppDelegate.swift
//  Assets-Generator
//
//  Created by Eren Demirbüken on 11/04/2017.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var window: NSWindow!
    var assetCatalogViewController: AssetCatalogCreator!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.assetCatalogViewController = AssetCatalogCreator(nibName: NSNib.Name(rawValue: "AssetsGenerator"), bundle: nil)
        window.contentView?.addSubview(self.assetCatalogViewController.view)
        self.assetCatalogViewController.view.frame = (window.contentView?.bounds)!
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

