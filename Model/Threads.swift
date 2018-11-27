//
//  Threads.swift
//  Camera
//
//  Created by Seann Moser on 11/27/18.
//  Copyright © 2018 SOU. All rights reserved.
//

import Foundation
import UIKit
struct Threads{
    static let PictureThread = DispatchQueue(label: "Picture Thread", qos: .utility, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem)
    
    static let FilterVideoFeedTread = DispatchQueue(label: "Filter Video Feed Thread", qos: .userInitiated, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem)
}
