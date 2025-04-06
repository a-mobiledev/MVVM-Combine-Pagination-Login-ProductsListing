//
//  PhotoosViewModel.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation
import Combine
import Alamofire

class PhotosViewModel {
    @Published var photos: [Photo] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var start = 0
    private let limit = 30
    private var isLastPage = false

    func fetchPhotos() {
        guard !isLoading && !isLastPage else { return }
        isLoading = true

        let url = "https://jsonplaceholder.typicode.com/photos"
        let params: [String: Any] = [
            "_start": start,
            "_limit": limit
        ]

        APIClient.shared.request(url, parameters: params, encoding: URLEncoding.default)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("\(error)")
                }
            }, receiveValue: { [weak self] (newPhotos: [Photo]) in
                guard let self = self else { return }
                self.photos.append(contentsOf: newPhotos)
                self.start += self.limit
                self.isLastPage = newPhotos.count < self.limit
            })
            .store(in: &cancellables)
    }
}
