//
//  ContentView.swift
//  ImageGalleryApp
//
//  Created by Lucas Menezes on 5/1/20.
//  Copyright © 2020 Lucas Menezes. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

let code = UIImage(named: "code")!
let bf = UIImage(named: "bf")!
struct ContentView : View {
    
    var images : [UIImage] = [code, bf, code, bf, code, bf, code, bf ]
    @State var urls : [URL] = []
    @State private var query = ""
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                .padding(.horizontal, 30.0)
                .frame(width: nil, height: 30.0)
                Text("Image Gallery").font(.system(size:34))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                
            }.padding(.horizontal, 3).background(Color.black, alignment: .bottom)
            HStack {
                Text("Search")
                TextField("??", text: $query) .font(Font.system(size: 15, weight: .medium, design: .serif))
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Search", action: {
                    
                    let api = API()
                    api.search(query: self.query, completion: { (page) in
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
                    
                    })
            }.padding(.horizontal, 20)
            GridView(images: images)
        }
        
    }
}
struct GridView: View {
    var images : [UIImage] = []
    var urls : [URL?] = []
    var rows : Int = 0
    init(images: [UIImage]){
        self.images = images
        rows = images.count/2
    }
    var body: some View {
        List {
            ForEach(0..<rows) {
                i in
                HStack(alignment: .center) {
                    ForEach(0..<2) {
                       j in
//                        Image(uiImage: self.images[i*2+j])
//                        .resizable().scaledToFit()
                        WebImage(url: URL(string: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic"))
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .onSuccess { image, cacheType in
                            // Success
                        }
                        .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                        .placeholder(Image(uiImage: self.images[i*2+j]))
                    }
                }.scaledToFill()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
