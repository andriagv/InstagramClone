//
//  CollectionViewModel.swift
//  Insatgram
//
//  Created by Apple on 23.11.24.
//

import Foundation
import NetworkPackage
import UIKit

final class CollectionViewModel {
    private let networkService: NetworkServiceProtocol
    private let urlString = "http://localhost:3000/users/1/media/recent"
    private var imageArray: [String] = []
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        fetchUserMedia()
    }
    
    func fetchUserMedia() {
        networkService.fetchData(
            urlString: urlString,
            httpMethod: "GET",
            headers: nil,
            decoder: JSONDecoder()
        ) { (result: Result<UserMediaResponse, NetworkError>) in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let userResponse):
                    self?.imageArray = userResponse.data.compactMap { $0.images.lowResolution.url }
                case .failure(let error):
                    print("Error fetching user media: \(error)")
                    self?.imageArray = []
                }
            }
        }
    }
    
    func getImage(at index: Int) ->String {
        imageArray[index]
    }
    
    func imageArrayCount() -> Int {
        imageArray.count
    }
}
