//
//  UserInfoViewModel.swift
//  Insatgram
//
//  Created by irakli kharshiladze on 22.11.24.
//

import UIKit
import NetworkPackage

final class UserInfoViewModel {
    
    private let networkService: NetworkServiceProtocol
    private var user: User?
    private let userId = 1
    private var urlString: String {
        "http://localhost:3000/users/\(userId)"
    }
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        fetchUserData()
    }
    
    func fetchUserData() {
        networkService.fetchData(
            urlString: urlString,
            httpMethod: "GET",
            headers: nil,
            decoder: JSONDecoder()
        ) { (result: Result<UserResponse, NetworkError>) in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let userResponse):
                    self?.user = userResponse.data
                case .failure(let error):
                    print("Error fetching user data: \(error)")
                }
            }
        }
    }
    
    func getUser() -> User? {
        user
    }
}
