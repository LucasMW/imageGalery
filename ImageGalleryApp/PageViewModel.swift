//
//  ImageLoader.swift
//  ImageGalleryApp
//
//  Created by Lucas Menezes on 5/5/20.
//  Copyright © 2020 Lucas Menezes. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class PageViewModel: ObservableObject {
    @Published var urls : [URL] = []
    func loadPhotos(query : String, page : Int = 1) {
       let api = API()
        api.search(query: query, completion: { (page) in
            print("return \(page?.photo?.count) itens")
            for photo in page?.photo ?? [] {
                let id = photo.id ?? ""
                print(id)
                self.urls.removeAll()
                api.getAllImagesForId(id: id) { (sizes) in
                    print(sizes.count)
                    let size = sizes.last
                    let url = size?.source ?? ""
                    self.urls.append(URL(string: url)!)
                }
                
            }
        }, page: 1)
    }
}
