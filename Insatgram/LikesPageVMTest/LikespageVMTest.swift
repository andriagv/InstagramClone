import XCTest
@testable import Insatgram
import NetworkPackage

class LikesPageViewModelTests: XCTestCase {
    
    var viewModel: LikesPageViewModel!
    
    override func setUp() {
        super.setUp()
        let mockUserLikes = [
            UserLike(profileImageName: "https://example.com/profile1.jpg", message: "Liked your photo", postImageName: "https://example.com/post1.jpg"),
            UserLike(profileImageName: "https://example.com/profile2.jpg", message: "Liked your photo", postImageName: nil),
            UserLike(profileImageName: "https://example.com/profile3.jpg", message: "Nice pic", postImageName: "https://example.com/post2.jpg"),
            UserLike(profileImageName: "https://example.com/profile4.jpg", message: "Awesome shot", postImageName: "https://example.com/post3.jpg"),
            UserLike(profileImageName: "https://example.com/profile5.jpg", message: "Great post!", postImageName: "https://example.com/post4.jpg"),
            UserLike(profileImageName: "https://example.com/profile6.jpg", message: "Love this!", postImageName: "https://example.com/post5.jpg"),
            UserLike(profileImageName: "https://example.com/profile7.jpg", message: "So cool!", postImageName: "https://example.com/post6.jpg")
        ]
        viewModel = LikesPageViewModel(networkService: MockNetworkService(userLikes: mockUserLikes))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddLikesToSections() {
        viewModel.fetchData()
        let expectation = self.expectation(description: "Wait for data to load")
        DispatchQueue.global().async {
            sleep(1)
            XCTAssertEqual(self.viewModel.sections.count, 4)
            XCTAssertEqual(self.viewModel.sections[0].0, "New")
            XCTAssertEqual(self.viewModel.sections[0].1.count, 2)
            XCTAssertEqual(self.viewModel.sections[1].0, "Today")
            XCTAssertEqual(self.viewModel.sections[1].1.count, 2)
            XCTAssertEqual(self.viewModel.sections[2].0, "This Week")
            XCTAssertEqual(self.viewModel.sections[2].1.count, 3)
            XCTAssertEqual(self.viewModel.sections[3].0, "This Month")
            XCTAssertEqual(self.viewModel.sections[3].1.count, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    
    var userLikes: [UserLike]
    
    init(userLikes: [UserLike]) {
        self.userLikes = userLikes
    }
    
    func fetchData<T>(urlString: String, httpMethod: String, headers: [String : String]?, decoder: JSONDecoder, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        let mockData = UserLikesResponse(data: userLikes, meta: MetaData(code: 200))
        completion(.success(mockData as! T))
    }
}
