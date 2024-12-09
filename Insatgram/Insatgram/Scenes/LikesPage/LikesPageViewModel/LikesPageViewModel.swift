//
//  LikesPageViewModel.swift
//  Insatgram
//
//  Created by irakli kharshiladze on 22.11.24.
//
 
import Foundation
import NetworkPackage
 
final class LikesPageViewModel {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        fetchData()
    }
    
    private var userLikeArr: [UserLike] = []
    
    private(set) var sections: [(String, [UserLike])] = []
    
     func fetchData(){
        networkService.fetchData(urlString: "http://localhost:3000/users/self/requested-by", httpMethod: "GET", headers: nil, decoder: JSONDecoder())
        { [weak self] (result: Result<UserLikesResponse, NetworkError>) in
            switch result {
            case .success(let userLikeData):
                self?.userLikeArr.append(contentsOf: userLikeData.data)
                self?.addLikesToSections()
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
     func addLikesToSections() {
        let newItems = userLikeArr.prefix(2).map {
            UserLike(profileImageName: $0.profileImageName, message: $0.message, postImageName: $0.postImageName)
        }
        let todayItems = userLikeArr.dropFirst(2).prefix(2).map {
            UserLike(profileImageName: $0.profileImageName, message: $0.message, postImageName: $0.postImageName)
        }
        
        let thisWeekItems = userLikeArr.dropFirst(4).prefix(3).map {
            UserLike(profileImageName: $0.profileImageName, message: $0.message, postImageName: $0.postImageName)
        }
        
        let thisMonthItems = userLikeArr.dropFirst(7).prefix(1).map {
            UserLike(profileImageName: $0.profileImageName, message: $0.message, postImageName: $0.postImageName)
        }
        
        sections = [
            ("New", newItems),
            ("Today", todayItems),
            ("This Week", thisWeekItems),
            ("This Month", thisMonthItems)
        ]
    }
}
