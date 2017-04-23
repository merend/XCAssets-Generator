//
//  String.swift
//  Assets-Generator
//
//  Created by Eren Demirbüken on 11/04/2017.
//


import Foundation


extension String {
    
    func cutScaleExtension()-> String{
        let range = self.range(of: "@(.*)", options:.regularExpression)
        if let r = range{
            return self.replacingCharacters(in:r, with: "")
        }
        return self;
    }
    
}
