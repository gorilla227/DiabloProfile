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
    class func getBorderColor(colorKey: String) -> UIColor {
        switch colorKey {
        case "green":
            return UIColor.greenColor()
        case "orange":
            return UIColor.orangeColor()
        case "blue":
            return UIColor.blueColor()
        case "yellow":
            return UIColor.yellowColor()
        case "white":
            return UIColor.grayColor()
        default:
            return UIColor.clearColor()
        }
    }
    
    class func getTextColor(colorKey: String?) -> UIColor {
        if let colorKey = colorKey {
            switch colorKey {
            case "green":
                return UIColor.greenColor()
            case "orange":
                return UIColor.orangeColor()
            case "blue":
                return UIColor(red: 146.0 / 255.0, green: 128.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
            case "yellow":
                return UIColor.yellowColor()
            case "white":
                return UIColor.whiteColor()
            case "gray":
                return UIColor.grayColor()
            default:
                break
            }
        }
        return UIColor.whiteColor()
    }
    
    class func convertNumberToString(number: NSNumber, withFractionDigits: Int) -> String? {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.maximumFractionDigits = withFractionDigits
        numberFormatter.minimumFractionDigits = withFractionDigits
        return numberFormatter.stringFromNumber(number)
    }
    
    class func rangeOfLastRoundBracketString(rawString: String) -> NSRange? {
        if let startIndex = rawString.rangeOfString("(", options: .BackwardsSearch, range: nil, locale: nil)?.startIndex,
            endIndex = rawString.rangeOfString(")", options: .BackwardsSearch, range: nil, locale: nil)?.endIndex {
            
            return NSMakeRange(rawString.characters.startIndex.distanceTo(startIndex), startIndex.distanceTo(endIndex))
        }
        return nil
    }
    
    class func attributeString(rawString: String, characterSet: NSCharacterSet, defaultAttributes: [String: AnyObject], specialAttributes: [String: AnyObject]) -> NSAttributedString {
        let result = NSMutableAttributedString(string: rawString, attributes: defaultAttributes)
        var startIndex = rawString.startIndex
        
        while let rangeOfSpecialCharacter = rawString.rangeOfCharacterFromSet(characterSet, options: .ForcedOrderingSearch, range: startIndex..<rawString.endIndex) {
            if String(rawString.characters[rangeOfSpecialCharacter.startIndex]) == "." {
                if rangeOfSpecialCharacter.startIndex == rawString.characters.endIndex.predecessor() {
                    break
                }

                let successorString = String(rawString.characters[rangeOfSpecialCharacter.startIndex.successor()])
                if !characterSet.characterIsMember(successorString.utf16.first!){
                    startIndex = rangeOfSpecialCharacter.startIndex.successor()
                    continue
                }
            }
            
            let loc = rawString.characters.startIndex.distanceTo(rangeOfSpecialCharacter.startIndex)
            result.setAttributes(specialAttributes, range: NSMakeRange(loc, 1))
            startIndex = rangeOfSpecialCharacter.startIndex.successor()
        }
        return result
    }
}

extension StringAndColor {
    static let NumbersCharacterSet = NSCharacterSet(charactersInString: "1234567890.%+")
}