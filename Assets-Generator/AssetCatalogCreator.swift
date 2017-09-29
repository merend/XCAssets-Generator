//
//  AppDelegate.swift
//  Assets-Generator
//
//  Created by Eren Demirbüken on 11/04/2017.
//
import Cocoa

enum Buttons: Int {
    case iphonePathButton = 1
    case ipadPathButton = 2
    case destinationButton = 3
}

class AssetCatalogCreator: NSViewController {

    var assetIphoneFolderPath: URL!
    var assetIpadFolderPath: URL!
    var assetDestinationFolderPath: URL!
    @IBOutlet weak var iphonePathTextField: NSTextField!
    @IBOutlet weak var ipadPathTextField: NSTextField!
    @IBOutlet weak var destinationPathTextField: NSTextField!
    @IBOutlet weak var assetFileName: NSTextField!
    
    override func viewDidLoad() {
        if #available(OSX 10.10, *) {
            super.viewDidLoad()
        } else {
            
        }
    }
}

// MARK: Helper
extension AssetCatalogCreator {
    func openPanel() -> NSOpenPanel {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        return openPanel
    }
    
    func dialogOK(text: String) {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = text
        myPopup.alertStyle = NSAlert.Style.warning
        myPopup.addButton(withTitle: "OK")
        myPopup.runModal()
    }
}

extension AssetCatalogCreator {
    @IBAction func generateAction(sender: AnyObject) {
    
        guard self.assetFileName!.stringValue.characters.count != 0 else {
            self.dialogOK(text: "Please enter XCAsset name")
            return
        }
        
        guard (self.assetIphoneFolderPath) != nil else {
            self.dialogOK(text: "Please select iphone images path")
            return
        }
        guard (self.assetIpadFolderPath) != nil else {
            self.dialogOK(text: "Please select ipad images path")
            return
        }
        
        guard (self.assetDestinationFolderPath) != nil else {
            self.dialogOK(text: "Please select destination path for XCAsset")
            return
        }
      
        FolderGenerator().generateAssetCatalogX(name: self.assetFileName!.stringValue,destinationPath:assetDestinationFolderPath , iphonePath: assetIphoneFolderPath, ipadPath: assetIpadFolderPath)
    }
    
    @IBAction func selectImagesFolder(sender: NSButton) {
        let panel = openPanel()
        let clicked = panel.runModal()
        
        if clicked.rawValue == NSFileHandlingPanelOKButton {
            for url in panel.urls {
                
                let button: Buttons = Buttons(rawValue: sender.tag)!
                
                switch button
                {
                case .iphonePathButton:
                    assetIphoneFolderPath = url
                    iphonePathTextField.stringValue = assetIphoneFolderPath.absoluteString
                case .ipadPathButton:
                    assetIpadFolderPath = url
                    ipadPathTextField.stringValue = assetIpadFolderPath.absoluteString
                case .destinationButton:
                    assetDestinationFolderPath = url
                    destinationPathTextField.stringValue = assetDestinationFolderPath.absoluteString
                }
            }
        }
    }
}
