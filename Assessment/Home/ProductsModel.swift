//
//  ProductsModel.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation


struct ProductListModel: Decodable {
    let products: [ProductModel]
}

struct ProductModel: Decodable {
    let id: Int
    let title: String?
    let description: String?
    let price: Double?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let brand: String?
    let category: String?
    let thumbnail: String?
    let images: [String]?
}

struct ProductCategory {
    let name: String
    let products: [ProductModel]
}
