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
    fileprivate class func generateURLRequest(_ httpMethod: String, region: String, path: String, parameters: [String: AnyObject]?) -> URLRequest? {
        if let configurations = configurations {
            var urlComponent = URLComponents()
            urlComponent.scheme = configurations[BasicKeys.Scheme] as? String
            urlComponent.host = (configurations[BasicKeys.Host] as! [String: String])[region]
            urlComponent.path = path
            
            if let parameters = parameters {
                var queryItems = [URLQueryItem]()
                for (key, value) in parameters {
                    let queryItem = URLQueryItem(name: key, value: value as? String)
                    queryItems.append(queryItem)
                }
                    
                urlComponent.queryItems = queryItems
            }
            
            if let url = urlComponent.url {
                let urlRequest = NSMutableURLRequest(url: url)
                urlRequest.httpMethod = httpMethod
                return urlRequest as URLRequest
            }
        }
        return nil
    }
    
    /* Convert "Pirlo#1588" to "Pirlo-1588" */
    fileprivate class func convertBattleTag(_ original: String) -> String {
        let result = original.replacingOccurrences(of: Separator.BattleTag_OriginalSeparator, with: Separator.BattleTag_APISepartor)
        return result
    }
    
    /* pathKey = BasicKeys.PathKeys.xxx
     tokens = [Token.xxx: String] */
    fileprivate class func generatePath(_ pathKey: String, tokens: [String: String]?) -> String? {
        if let configurations = configurations,
            let paths = configurations[BasicKeys.Path] as? [String: String],
            var pathString = paths[pathKey] {
            
            if let tokens = tokens {
                for (token, replacement) in tokens {
                    pathString = pathString.replacingOccurrences(of: token, with: replacement)
                }
            }
            
            return pathString
        }
        
        return nil
    }
    
    fileprivate class func deserializeJSONData(_ data: Data) throws -> Any {
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return result
        } catch {
            throw error
        }
    }
    
    fileprivate class func requestBlizzardAPI(_ request: URLRequest, requestKey: String, completion: @escaping (_ result: Any?, _ error: NSError?) -> Void) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(nil, NSError(domain: requestKey, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: error!.localizedDescription]]))
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)!.statusCode
            guard statusCode >= 200 && statusCode < 300 else {
                completion(nil, NSError(domain: requestKey, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Request returns un-successful StatusCode"]]))
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: requestKey, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Return empty data"]]))
                return
            }
            
            // Take care response data
            do {
                let result = try self.deserializeJSONData(data)
                completion(result, nil)
            } catch {
                completion(nil, NSError(domain: requestKey, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Failed to deserialize JSON response"]]))
                return
            }
        }) 
        
        task.resume()
    }
    
    // MARK: - API Functions
    class func requestCareerProfile(_ region: String, locale: String, battleTag: String, completion: @escaping (_ result: [[String: Any]]?, _ error: NSError?) -> Void) {
        let convertedBattleTag = convertBattleTag(battleTag)
        if let configurations = configurations,
            let api_key = configurations[BasicKeys.API_Key],
            let path = generatePath(PathKeys.CareerProfile, tokens: [Token.BattleTag_Token: convertedBattleTag]) {
            
            let parameters = [ParameterKeys.API_Key: api_key, ParameterKeys.Locale: locale] as [String : Any]
            
            // Create URLRequest
            if let urlRequest = generateURLRequest(HttpMethod.Get, region: region, path: path, parameters: parameters as [String : AnyObject]?) {
                // Run URLRequest
                requestBlizzardAPI(urlRequest, requestKey: PathKeys.CareerProfile, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        completion(nil, error)
                        return
                    }
                    
                    if let responseBody = result as? [String: String], let _ = responseBody[ResponseKeys.ErrorCode], let _ = responseBody[ResponseKeys.ErrorReason] {
                        completion(nil, NSError(domain: PathKeys.CareerProfile, code: 1, userInfo: [NSLocalizedDescriptionKey: responseBody]))
                    } else if let result = result, let heroes = self.decodeCareerProfile(result) {
                        completion(heroes, nil)
                    } else {
                        completion(nil, error)
                    }
                })
            }
        }
    }
    
    class func requestHeroProfile(_ region: String, locale: String, battleTag: String, heroId: NSNumber, completion: @escaping (_ result: [String: Any]?, _ error: NSError?) -> Void) {
        let convertedBattleTag = convertBattleTag(battleTag)
        if let configurations = configurations,
            let api_key = configurations[BasicKeys.API_Key],
            let path = generatePath(PathKeys.HeroProfile, tokens: [Token.BattleTag_Token: convertedBattleTag, Token.HeroID_Token: heroId.stringValue]) {
            
            let parameters = [ParameterKeys.API_Key: api_key, ParameterKeys.Locale: locale] as [String : Any]
            
            // Create URLRequest
            if let urlRequest = generateURLRequest(HttpMethod.Get, region: region, path: path, parameters: parameters as [String : AnyObject]?) {
                // Run URLRequest
                requestBlizzardAPI(urlRequest, requestKey: PathKeys.HeroProfile, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        completion(nil, error)
                        return
                    }
                    
                    if let responseBody = result as? [String: String], let _ = responseBody[ResponseKeys.ErrorCode], let _ = responseBody[ResponseKeys.ErrorReason] {
                        completion(nil, NSError(domain: PathKeys.HeroProfile, code: 1, userInfo: [NSLocalizedDescriptionKey: responseBody]))
                    } else if let result = result, var hero = self.decodeHeroProfile(result) {
                        hero[Hero.Keys.Region] = region
                        hero[Hero.Keys.Locale] = locale
                        hero[Hero.Keys.BattleTag] = battleTag
                        completion(hero, nil)
                    } else {
                        completion(nil, error)
                    }
                })
            }
        }
    }
    
    class func requestItemData(_ region: String, locale: String, itemTooltipParams: String, completion: @escaping (_ result: [String: Any]?, _ error: NSError?) -> Void) {
        if let configurations = configurations,
            let api_Key = configurations[BasicKeys.API_Key],
            let path = generatePath(PathKeys.ItemData, tokens: [Token.ItemTooltipParams: itemTooltipParams]) {
            
            let parameters = [ParameterKeys.API_Key: api_Key, ParameterKeys.Locale: locale] as [String : Any]
            
            // Create URLRequest
            if let urlRequest = generateURLRequest(HttpMethod.Get, region: region, path: path, parameters: parameters as [String : AnyObject]?) {
                // Run URLRequest
                requestBlizzardAPI(urlRequest, requestKey: PathKeys.ItemData, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        completion(nil, error)
                        return
                    }
                    
                    if let responseBody = result as? [String: String], let _ = responseBody[ResponseKeys.ErrorCode], let _ = responseBody[ResponseKeys.ErrorReason] {
                        completion(nil, NSError(domain: PathKeys.ItemData, code: 1, userInfo: [NSLocalizedDescriptionKey: responseBody]))
                    } else if let result = result, var detailItem = self.decodeItemData(result) {
                        detailItem[DetailItem.Keys.Locale] = locale
                        completion(detailItem, nil)
                    } else {
                        completion(nil, error)
                    }
                })
            }
        }
    }
    
    // MARK: - Download Image Funtion
    class func downloadImage(_ url: URL, completion: @escaping (_ result: Data?, _ error: NSError?) -> Void) {
        let domain = "DownloadImage"
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                completion(nil, NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Request returns error: \(error?.localizedDescription)"]]))
                return
            }
            
            let statusCode: Int = (response as? HTTPURLResponse)!.statusCode
            guard statusCode >= 200 && statusCode < 300 else {
                completion(nil, NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Request returns un-successful StatusCode"]]))
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: [ResponseKeys.ErrorReason: "Return empty data"]]))
                return
            }
            
            completion(data, nil)
        }) 
        
        task.resume()
    }
}
