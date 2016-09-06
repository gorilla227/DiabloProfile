//
//  BlizzardAPI.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/14/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation

class BlizzardAPI {
    // MARK: - Private Functions
    /* region = US/EU/CN/KR/TW,
     path is generated from class func 'generatePath', 
     parameters = [ParameterKeys.xxx: String] */
    private class func generateURLRequest(httpMethod: String, region: String, path: String, parameters: [String: AnyObject]?) -> NSURLRequest? {
        if let configurations = configurations {
            let urlComponent = NSURLComponents()
            urlComponent.scheme = configurations[BasicKeys.Scheme] as? String
            urlComponent.host = (configurations[BasicKeys.Host] as! [String: String])[region]
            urlComponent.path = path
            
            if let parameters = parameters {
                var queryItems = [NSURLQueryItem]()
                for (key, value) in parameters {
                    let queryItem = NSURLQueryItem(name: key, value: value as? String)
                    queryItems.append(queryItem)
                }
                    
                urlComponent.queryItems = queryItems
            }
            
            if let url = urlComponent.URL {
                let urlRequest = NSMutableURLRequest(URL: url)
                urlRequest.HTTPMethod = httpMethod
                return urlRequest
            }
        }
        return nil
    }
    
    /* Convert "Pirlo#1588" to "Pirlo-1588" */
    private class func convertBattleTag(original: String) -> String {
        let result = original.stringByReplacingOccurrencesOfString(Separator.BattleTag_OriginalSeparator, withString: Separator.BattleTag_APISepartor)
        return result
    }
    
    /* pathKey = BasicKeys.PathKeys.xxx
     tokens = [Token.xxx: String] */
    private class func generatePath(pathKey: String, tokens: [String: String]?) -> String? {
        if let configurations = configurations,
            let paths = configurations[BasicKeys.Path] as? [String: String],
            var pathString = paths[pathKey] {
            
            if let tokens = tokens {
                for (token, replacement) in tokens {
                    pathString = pathString.stringByReplacingOccurrencesOfString(token, withString: replacement)
                }
            }
            
            return pathString
        }
        
        return nil
    }
    
    private class func deserializeJSONData(data: NSData) throws -> AnyObject? {
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            return result
        } catch {
            throw error
        }
    }
    
    private class func requestBlizzardAPI(request: NSURLRequest, requestKey: String, completion: (result: AnyObject?, error: NSError?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else {
                completion(result: nil, error: NSError(domain: requestKey, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Request returns error: \(error?.localizedDescription)"]]))
                return
            }
            
            guard let statusCode: Int = (response as? NSHTTPURLResponse)!.statusCode where statusCode >= 200 && statusCode < 300 else {
                completion(result: nil, error: NSError(domain: requestKey, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Request returns un-successful StatusCode"]]))
                return
            }
            
            guard let data = data else {
                completion(result: nil, error: NSError(domain: requestKey, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Return empty data"]]))
                return
            }
            
            // Take care response data
            do {
                let result = try self.deserializeJSONData(data)
                completion(result: result, error: nil)
            } catch {
                completion(result: nil, error: NSError(domain: requestKey, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Failed to deserialize JSON response"]]))
                return
            }
        }
        
        task.resume()
    }
    
    // MARK: - API Functions
    class func requestCareerProfile(region: String, locale: String, battleTag: String, completion: (result: [[String: AnyObject]]?, error: NSError?) -> Void) {
        let convertedBattleTag = convertBattleTag(battleTag)
        if let configurations = configurations,
            let api_key = configurations[BasicKeys.API_Key],
            let path = generatePath(PathKeys.CareerProfile, tokens: [Token.BattleTag_Token: convertedBattleTag]) {
            
            let parameters = [ParameterKeys.API_Key: api_key, ParameterKeys.Locale: locale]
            
            // Create URLRequest
            if let urlRequest = generateURLRequest(HttpMethod.Get, region: region, path: path, parameters: parameters) {
                // Run URLRequest
                requestBlizzardAPI(urlRequest, requestKey: PathKeys.CareerProfile, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        completion(result: nil, error: error)
                        return
                    }
                    
                    if let responseBody = result as? [String: String], let _ = responseBody[ResponseKeys.ErrorCode], let _ = responseBody[ResponseKeys.ErrorReason] {
                        completion(result: nil, error: NSError(domain: PathKeys.CareerProfile, code: 1, userInfo: [NSLocalizedDescriptionKey: responseBody]))
                    } else if let result = result, let heroes = self.decodeCareerProfile(result) {
                        completion(result: heroes, error: nil)
                    } else {
                        completion(result: nil, error: error)
                    }
                })
            }
        }
    }
    
    class func requestHeroProfile(region: String, locale: String, battleTag: String, heroId: NSNumber, completion: (result: [String: AnyObject]?, error: NSError?) -> Void) {
        let convertedBattleTag = convertBattleTag(battleTag)
        if let configurations = configurations,
            let api_key = configurations[BasicKeys.API_Key],
            let path = generatePath(PathKeys.HeroProfile, tokens: [Token.BattleTag_Token: convertedBattleTag, Token.HeroID_Token: heroId.stringValue]) {
            
            let parameters = [ParameterKeys.API_Key: api_key, ParameterKeys.Locale: locale]
            
            // Create URLRequest
            if let urlRequest = generateURLRequest(HttpMethod.Get, region: region, path: path, parameters: parameters) {
                // Run URLRequest
                requestBlizzardAPI(urlRequest, requestKey: PathKeys.HeroProfile, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        completion(result: nil, error: error)
                        return
                    }
                    
                    if let responseBody = result as? [String: String], let _ = responseBody[ResponseKeys.ErrorCode], let _ = responseBody[ResponseKeys.ErrorReason] {
                        completion(result: nil, error: NSError(domain: PathKeys.HeroProfile, code: 1, userInfo: [NSLocalizedDescriptionKey: responseBody]))
                    } else if let result = result, var hero = self.decodeHeroProfile(result) {
                        hero[Hero.Keys.Region] = region
                        hero[Hero.Keys.Locale] = locale
                        hero[Hero.Keys.BattleTag] = battleTag
                        completion(result: hero, error: nil)
                    } else {
                        completion(result: nil, error: error)
                    }
                })
            }
        }
    }
    
    class func requestItemData(region: String, locale: String, itemTooltipParams: String, completion: (result: [String: AnyObject]?, error: NSError?) -> Void) {
        if let configurations = configurations,
            let api_Key = configurations[BasicKeys.API_Key],
            let path = generatePath(PathKeys.ItemData, tokens: [Token.ItemTooltipParams: itemTooltipParams]) {
            
            let parameters = [ParameterKeys.API_Key: api_Key, ParameterKeys.Locale: locale]
            
            // Create URLRequest
            if let urlRequest = generateURLRequest(HttpMethod.Get, region: region, path: path, parameters: parameters) {
                // Run URLRequest
                requestBlizzardAPI(urlRequest, requestKey: PathKeys.ItemData, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        completion(result: nil, error: error)
                        return
                    }
                    
                    if let responseBody = result as? [String: String], let _ = responseBody[ResponseKeys.ErrorCode], let _ = responseBody[ResponseKeys.ErrorReason] {
                        completion(result: nil, error: NSError(domain: PathKeys.ItemData, code: 1, userInfo: [NSLocalizedDescriptionKey: responseBody]))
                    } else if let result = result, var detailItem = self.decodeItemData(result) {
                        detailItem[DetailItem.Keys.Locale] = locale
                        completion(result: detailItem, error: nil)
                    } else {
                        completion(result: nil, error: error)
                    }
                })
            }
        }
    }
    
    // MARK: - Download Image Funtion
    class func downloadImage(url: NSURL, completion: (result: NSData?, error: NSError?) -> Void) {
        let domain = "DownloadImage"
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            guard error == nil else {
                completion(result: nil, error: NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Request returns error: \(error?.localizedDescription)"]]))
                return
            }
            
            guard let statusCode: Int = (response as? NSHTTPURLResponse)!.statusCode where statusCode >= 200 && statusCode < 300 else {
                completion(result: nil, error: NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Request returns un-successful StatusCode"]]))
                return
            }
            
            guard let data = data else {
                completion(result: nil, error: NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Return empty data"]]))
                return
            }
            
            completion(result: data, error: nil)
        }
        
        task.resume()
    }
}