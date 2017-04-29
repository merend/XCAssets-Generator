//
//  FolderGenerator.swift
//  Assets-Generator
//
//  Created by Eren Demirbüken on 11/04/2017.
//


import Foundation
import Cocoa


class FolderGenerator: NSObject {
    
    func findScaleFactor(fileName:String) -> String
    {
        if(fileName.lowercased().contains("@3x")){
            return "@3x"
        } else  if(fileName.lowercased().contains("@2x")){
            return "@2x"
        }else{
            return "@1x"
        }
    }
    
    func generateAssetCatalogX(name:String, destinationPath:URL, iphonePath:URL , ipadPath:URL){
        let fileManager = FileManager.default
        var iPhoneFolderContent = [URL]()
        var iPadFolderContent = [URL]()
        
        do {
            
            iPhoneFolderContent = try fileManager.contentsOfDirectory( at: iphonePath, includingPropertiesForKeys: nil, options: [])
            iPhoneFolderContent = iPhoneFolderContent.filter{ $0.pathExtension == "png" || $0.pathExtension == "jpeg"}
            
            iPadFolderContent = try fileManager.contentsOfDirectory( at: ipadPath, includingPropertiesForKeys: nil, options: [])
            iPadFolderContent = iPadFolderContent.filter{ $0.pathExtension == "png" || $0.pathExtension == "jpeg"}
            
        } catch {
            print(error.localizedDescription)
        }
        
        let xcAssetPath:String = destinationPath.path + "/" + name + ".xcassets"
        do {
            try fileManager.createDirectory(atPath: xcAssetPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        enumareFiles(fileList: iPhoneFolderContent, isIphone:true, suffix:"-iPhone", xcAssetPath: xcAssetPath)
        enumareFiles(fileList: iPadFolderContent, isIphone:false, suffix:"-iPad", xcAssetPath: xcAssetPath)
    }
    func enumareFiles(fileList:[URL] ,isIphone:Bool, suffix:String, xcAssetPath:String )
    {
        
        for imageUrl:URL in fileList
        {
            let imageSetName:String = imageUrl.deletingPathExtension().lastPathComponent;
            let imageSetPath:String = xcAssetPath + "/" + imageSetName.cutScaleExtension() + ".imageset"
            let imageExtension:String  = imageUrl.pathExtension
            let scale:String  = findScaleFactor(fileName: imageSetName)
            
            do {
                var isDirectory : ObjCBool = false
                if !FileManager.default.fileExists(atPath: imageSetPath, isDirectory:&isDirectory) {
                    try FileManager.default.createDirectory(atPath: imageSetPath, withIntermediateDirectories: true, attributes: nil)
                }
            } catch {
                print("Error occured while creating imageset" + error.localizedDescription)
            }
            guard let realImage:NSImage = NSImage(contentsOf: imageUrl) else {
                print("image could not be found:", imageUrl.absoluteString)
                return;
            }
            
            let fileSaveName = imageSetName + suffix + "." + imageExtension;
            writeImageToDirectory(image: realImage, atPath: imageSetPath + "/" + fileSaveName)
            saveImageToContentJson(contentJsonPath: imageSetPath, scale: scale, isIphone: isIphone, imageFileName: fileSaveName);
        }
    }
    
    func writeImageToDirectory(image i: NSImage, atPath p: String)
    {
        let data = i.tiffRepresentation
        let bitmap = NSBitmapImageRep(data: data!)
        
        let finalData = bitmap!.representation(using: .PNG, properties: [:])
        
        do {
            try finalData?.write(to: URL(fileURLWithPath: p), options: .atomic)
        } catch {
            print(error)
        }
    }
    
    func saveImageToContentJson(contentJsonPath:String, scale:String, isIphone:Bool, imageFileName:String)
    {
        let contentCreator = ContentCreator()
        let contentDictionary = contentCreator.contentDictionarys(atPath:contentJsonPath)
        let contentImages = contentDictionary!["images"] as! NSArray
        var index = 0
        //index order where predefined in Content.plist
        if isIphone{
            if(scale.lowercased() == "@2x"){
                index = 1
            }else if(scale.lowercased() == "@3x"){
                index = 2
            }
        }else{
            if(scale.lowercased() == "@1x"){
                index = 3
            }else{
                index = 4
            }
        }
        
        let choosenDic:NSMutableDictionary = (contentImages[index] as! NSMutableDictionary).mutableCopy() as! NSMutableDictionary
        choosenDic.setValue(imageFileName, forKey: "filename")
        
        let mutableCopyOfContentImages = contentImages.mutableCopy() as! NSMutableArray
        mutableCopyOfContentImages[index] = choosenDic;
        
        let mutableCopyOfContentDictionary = contentDictionary?.mutableCopy() as! NSMutableDictionary
        mutableCopyOfContentDictionary.setValue(mutableCopyOfContentImages, forKey: "images")
        contentCreator.writeDictionaryContent(content: mutableCopyOfContentDictionary, atPath: contentJsonPath)
    }
    
}
