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
    @State private var query = "pikachu"
    @ObservedObject private var model = PageViewModel()
    
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
                            self.model.urls.removeAll()
                            api.getAllImagesForId(id: id) { (sizes) in
                                print(sizes.count)
                                let size = sizes.last
                                let url = size?.source ?? ""
                                self.model.urls.append(URL(string: url)!)
                            }
                            
                        }
                    }, page: 1)
                    
                    })
            }.padding(.horizontal, 20)
            GridView(model: model)
        }
        
    }
}
struct ImageURL : Identifiable {
    var id: ObjectIdentifier
    var images : UIImage
    var url : URL
}
struct GridView: View {
    var images : [UIImage] = []
    var urls : [URL] {
        return model.urls
    }
    var rows : Int  {
        return urls.count/2
    }
    @ObservedObject private var model : PageViewModel
    
    init(model: PageViewModel){
        self.model = model
    }
    func urlFor(i: Int, j: Int) -> URL {
        return self.urls[i*2+j]
    }
    var body: some View {
        List {
            ForEach(0..<rows, id: \.self) {
                i in
                HStack(alignment: .center) {
                    ForEach(0..<2) {
                       j in
//                        Image(uiImage: self.images[i*2+j])
//                        .resizable().scaledToFit()
                        WebImage(url: self.urlFor(i: i, j: j))
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .onSuccess { image, cacheType in
                            // Success
                        }
                        .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                        .placeholder(Image(systemName: "star"))
                    }.scaledToFit()
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
