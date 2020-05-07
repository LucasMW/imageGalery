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
}
