import XCTest
@testable import Insatgram
import NetworkPackage
import DateFormatterService

class MainPageViewModelTests: XCTestCase {
    
    var viewModel: MainPageViewModel!
    
    override func setUp() {
        super.setUp()
        
        let post1 = Post(
            caption: Caption(
                createdTime: "2024-11-01T12:00:00Z",
                from: UserMain(fullName: "John Doe", id: "user1", profilePicture: "https://example.com/johndoe.jpg", username: "john_doe"),
                id: "caption_1",
                text: "First post"
            ),
            createdTime: "2024-11-01T12:00:00Z",
            id: "post_1",
            images: [Image(imageURL: "https://example.com/image1.jpg"), Image(imageURL: "https://example.com/image2.jpg")],
            likes: Likes(count: 50, data: [UserMain(fullName: "John Doe", id: "user1", profilePicture: "https://example.com/johndoe.jpg", username: "john_doe")]),
            link: "https://example.com/post1",
            location: Location(id: "loc1", latitude: 37.7749, longitude: -122.4194, name: "New York"),
            user: UserMain(fullName: "User One", id: "user1", profilePicture: "https://example.com/user1.jpg", username: "user1"),
            userHasLiked: true,
            usersInPhoto: []
        )
        
        let post2 = Post(
            caption: Caption(
                createdTime: "2024-11-02T12:00:00Z",
                from: UserMain(fullName: "Jane Doe", id: "user2", profilePicture: "https://example.com/janedoe.jpg", username: "jane_doe"),
                id: "caption_2",
                text: "Second post"
            ),
            createdTime: "2024-11-02T12:00:00Z",
            id: "post_2",
            images: [Image(imageURL: "https://example.com/image3.jpg")],
            likes: Likes(count: 100, data: [UserMain(fullName: "Jane Doe", id: "user2", profilePicture: "https://example.com/janedoe.jpg", username: "jane_doe")]),
            link: "https://example.com/post2",
            location: Location(id: "loc2", latitude: 34.0522, longitude: -118.2437, name: "Los Angeles"),
            user: UserMain(fullName: "User Two", id: "user2", profilePicture: "https://example.com/user2.jpg", username: "user2"),
            userHasLiked: false,
            usersInPhoto: []
        )
        
        viewModel = MainPageViewModel(networkService: MockNetworkService(posts: [post1, post2]), customDateFormatter: MockCustomDateFormatter())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testGetPostAtIndex() {
        let post = viewModel.getPost(at: 0)
        XCTAssertNotNil(post.caption)
        XCTAssertEqual(post.id, "post_1")
        XCTAssertEqual(post.caption?.text, "First post")
    }
    
    func testPostCount() {
        let count = viewModel.postCount()
        XCTAssertEqual(count, 2)
    }
    
    func testCollectionImagesCountAtIndex() {
        let count = viewModel.collectionImagesCount(at: 0)
        XCTAssertEqual(count, 2)
        let countForSecondPost = viewModel.collectionImagesCount(at: 1)
        XCTAssertEqual(countForSecondPost, 1)
    }
    
    func testDataFormat() {
          let dateString = "2024-11-01T12:00:00Z"
          let formattedDate = viewModel.dataFormat(with: dateString)
          XCTAssertEqual(formattedDate, "Mocked Date")
      }
  }


class MockNetworkService: NetworkServiceProtocol {
    
    var posts: [Post]
    
    init(posts: [Post]) {
        self.posts = posts
    }
    
    func fetchData<T>(urlString: String, httpMethod: String, headers: [String : String]?, decoder: JSONDecoder, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        let response = PostResponse(data: posts, meta: nil)
        completion(.success(response as! T))
    }
}

class MockCustomDateFormatter: CustomDateFormatterProtocol {
    func formattedDate(from data: String, inputFormat: String, outputFormat: String) -> String {
        return "Mocked Date"
    }
}
