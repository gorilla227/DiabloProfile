//
//  StringAndColor.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/3.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import UIKit

class StringAndColor {
    class func getBorderColor(_ colorKey: String?) -> UIColor {
        if let colorKey = colorKey {
            switch colorKey {
            case "green":
                return UIColor.green
            case "orange":
                return UIColor.orange
            case "blue":
                return UIColor.blue
            case "yellow":
                return UIColor.yellow
            case "white":
                return UIColor.gray
            default:
                return UIColor.clear
            }
        }
        return UIColor.clear
    }
    
    class func getTextColor(_ colorKey: String?) -> UIColor {
        if let colorKey = colorKey {
            switch colorKey {
            case "green":
                return UIColor.green
            case "orange":
                return UIColor.orange
            case "blue":
                return UIColor(red: 146.0 / 255.0, green: 128.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
            case "yellow":
                return UIColor.yellow
            case "white":
                return UIColor.white
            case "gray":
                return UIColor.gray
            default:
                break
            }
        }
        return UIColor.white
    }
    
    class func convertNumberToString(_ number: NSNumber, withFractionDigits: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = withFractionDigits
        numberFormatter.minimumFractionDigits = withFractionDigits
        return numberFormatter.string(from: number)
    }
    
    class func rangeOfLastRoundBracketString(_ rawString: String) -> NSRange? {
        if let startIndex = rawString.range(of: "(", options: .backwards, range: nil, locale: nil)?.lowerBound,
            let endIndex = rawString.range(of: ")", options: .backwards, range: nil, locale: nil)?.upperBound {
            return NSMakeRange(rawString.characters.distance(from: rawString.startIndex, to: startIndex), rawString.characters.distance(from: startIndex, to: endIndex))
        }
        return nil
    }
    
    class func attributeString(_ rawString: String, characterSet: CharacterSet, defaultAttributes: [String: AnyObject], specialAttributes: [String: AnyObject]) -> NSAttributedString {
        let result = NSMutableAttributedString(string: rawString, attributes: defaultAttributes)
        var startIndex = rawString.startIndex
        
        while let rangeOfSpecialCharacter = rawString.rangeOfCharacter(from: characterSet, options: .forcedOrdering, range: startIndex..<rawString.endIndex) {
            if String(rawString.characters[rangeOfSpecialCharacter.lowerBound]) == "." {
                if rangeOfSpecialCharacter.lowerBound == rawString.characters.index(before: rawString.characters.endIndex) {
                    break
                }
                
                let successorString = String(rawString.characters[rawString.characters.index(after: rangeOfSpecialCharacter.lowerBound)])
                if !characterSet.contains(UnicodeScalar(successorString.utf16.first!)!){
                    startIndex = rawString.characters.index(after: rangeOfSpecialCharacter.lowerBound)
                    continue
                }
            }
            
            let loc = rawString.characters.distance(from: rawString.characters.startIndex, to: rangeOfSpecialCharacter.lowerBound)
            result.setAttributes(specialAttributes, range: NSMakeRange(loc, 1))
            startIndex = rawString.characters.index(after: rangeOfSpecialCharacter.lowerBound)
        }
        return result
    }
}

extension StringAndColor {
    static let NumbersCharacterSet = CharacterSet(charactersIn: "1234567890.%+")
}
