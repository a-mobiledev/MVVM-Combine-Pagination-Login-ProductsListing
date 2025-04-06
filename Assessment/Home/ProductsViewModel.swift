//
//  ProductsViewModel.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation

import Foundation
import Alamofire
import Combine

final class ProductsViewModel {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var products: ProductListModel?
    
    let productsResult = PassthroughSubject<ProductListModel?, Error>()
    private var subscriptions = Set<AnyCancellable>()
    let allowedCategories = ["groceries", "furniture", "fragrances", "beauty"]  // I took these from dummyJson, because it gives data products wise, not divided into categories, do for getting data in usable format, I collected those categories here.
    var categories: [ProductCategory] = []
    
    func fetchProducts() {
        isLoading = true
        let url = "https://dummyjson.com/products"
        
        APIClient.shared
            .request(url, method: .get)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = "\(error)"
                    self?.productsResult.send(completion: .failure(error))
                }
            }, receiveValue: {[weak self] response in
                self?.products = response
                self?.groupProductsCategoryWise(products: self?.products)
                self?.productsResult.send((response))
            })
            .store(in: &subscriptions)
    }
    
    private func groupProductsCategoryWise(products: ProductListModel?) {
        guard let products = products else {
            return
        }
        let filtered = products.products.filter { allowedCategories.contains($0.category ?? AppConstant.defaultCategory) }
        let grouped = Dictionary(grouping: filtered, by: { $0.category })
        let categoryArray = grouped.map { ProductCategory(name: $0.key ?? AppConstant.defaultCategory, products: $0.value) }
        self.categories = categoryArray
    }
}
