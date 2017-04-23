//
//  ContentCreator.swift
//  Assets-Generator
//
//  Created by Eren Demirbüken on 11/04/2017.
//

import Foundation
import Cocoa

class ContentCreator: AnyObject {
    
    func createContentDictionary() -> NSMutableDictionary? {
        let bundlePath = Bundle.main.path(forResource: "Content", ofType: "plist")
        let  resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath!)
        return resultDictionary!
    }
    
    func writeDictionaryContent(content: AnyObject, atPath: String) {
        let theJSONData = try! JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
        let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii)
        let file = "Contents.json"
        do {
            try theJSONText!.write(toFile: atPath + "/" + file, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            NSLog("Content.json write error");
        }
    }
    
    func contentDictionarys(atPath: String) -> NSMutableDictionary?{
        let file = "Contents.json"
        let realPath = atPath + "/" + file
        if hasContentJson(atPath: realPath) {
            
            let data : Data? = FileManager.default.contents(atPath: realPath)
            if let data = data{
                return try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSMutableDictionary
            }
        }else{
            return self.createContentDictionary();
        }
        return nil;
    }
    
    func hasContentJson (atPath: String) -> Bool{
        var isDirectory : ObjCBool = false
        if FileManager.default.fileExists(atPath: atPath, isDirectory:&isDirectory) {
            return true;
        } else {
            return false;
        }
    }
}
