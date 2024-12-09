//
//  SearchPageViewModel.swift
//  Insatgram
//
//  Created by irakli kharshiladze on 22.11.24.
//
 
import Foundation
import NetworkPackage
 
final class SearchPageViewModel {
    private let networkService: NetworkServiceProtocol
    var medias: [MediaModel] = []
    var tags: [TagModel] = []
    
    var onDataUpdated: (() -> Void)?
    
    let mediaUrl: String = "http://localhost:3000/media/popular"
    let tagUrl: String = "http://localhost:3000/tags/search"
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.fetchMediaData()
        self.fetchTags()
    }
    
    private func fetchMediaData() {
        networkService.fetchData(urlString: mediaUrl, httpMethod: "GET", headers: nil, decoder: JSONDecoder()) { [weak self] (result: Result<MediaResponse, NetworkError>) in
            switch result {
            case .success(let media):
                self?.medias.append(contentsOf: media.data)
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    private func fetchTags() {
        networkService.fetchData(urlString: tagUrl, httpMethod: "GET", headers: nil, decoder: JSONDecoder()) { [weak self] (result: Result<TagResponse, NetworkError>) in
            switch result {
            case .success(let tag):
                self?.tags.append(contentsOf: tag.data)
            case .failure(let error):
                print("Error fetching tag data: \(error)")
            }
        }
    }
    
    func getImage(at index: Int) -> MediaModel {
        medias[index]
    }
    
    func getMediaCount() -> Int {
        medias.count
    }
    
    func searchTag(with tagName: String) -> [TagModel] {
        let tagNameLowerCase = tagName.lowercased()
        let filteredTags = tags.filter { $0.name.lowercased() == tagNameLowerCase }
        return filteredTags
    }
}
