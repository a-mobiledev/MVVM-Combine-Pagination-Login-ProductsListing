//
//  PhotosModel.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation

struct Photo: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
