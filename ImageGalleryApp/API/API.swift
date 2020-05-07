//
//  API.swift
//  ImageGalleryApp
//
//  Created by Lucas Menezes on 5/1/20.
//  Copyright © 2020 Lucas Menezes. All rights reserved.
//

import Foundation
import Alamofire

class API {
    let key = "f9cc014fa76b098f9e82f1c288379ea1"
    let base = "https://api.flickr.com/services/rest/?"
    
    //search for photo ids
    func search(query: String, completion : @escaping (PhotoPage?)->(), page : Int = 1) {
        //https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f9cc014fa76b098f9e82f1c288379ea1&tags=Cat&page=1&format=json&nojsoncallback=1
        let url = "\(base)method=flickr.photos.search&api_key=\(key)&tags=\(query)&page=1&format=json&nojsoncallback=\(page)"
        let request = Alamofire.request(url)
        request.responseJSON { (response) in
            switch response.result {
            case .success(let json):
                guard let parsed = PhotosResponse(JSON: json as? [String : Any] ?? [:])  else {
                    completion(nil)
                    return
                }
                completion(parsed.photos)
            case .failure(let error):
                print(error)
                print(response.error)
                completion(nil)
            }
            
        }
            
    }
    func getAllImagesForId(id : String, completion : @escaping ([PhotoSize])->()){
           // https://api.flickr.com/services/rest/method=flickr.photos.getSizes&api_key=f9cc014fa76b098f9e82f1c288379ea1&photo_id=31456463045&format=json&nojsoncallback=1
            let url = "\(base)method=flickr.photos.getSizes&api_key=\(key)&photo_id=\(id)&format=json&nojsoncallback=1"
            let request = Alamofire.request(url)
            request.responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    guard let parsed = getSizesResponse(JSON: json as? [String : Any] ?? [:])  else {
                        completion([])
                        return
                    }
                    completion(parsed.sizeCluster?.sizes ?? [])
                case .failure(let error):
                    print(error)
                    completion([])
                }
            }
        }
    
    
}
