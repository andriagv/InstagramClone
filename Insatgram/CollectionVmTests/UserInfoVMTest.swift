import XCTest
@testable import Insatgram
import NetworkPackage

class CollectionViewModelTests: XCTestCase {
    
    var viewModel: CollectionViewModel!
    
    override func setUp() {
        super.setUp()
        let mockUserMedia1 = UserMedia(
            id: "media1",
            images: UserMedia.Images(
                lowResolution: UserMedia.Images.ImageResolution(
                    url: "https://example.com/image1_low.jpg",
                    width: 320,
                    height: 240
                )
            )
        )
        
        let mockUserMedia2 = UserMedia(
            id: "media2",
            images: UserMedia.Images(
                lowResolution: UserMedia.Images.ImageResolution(
                    url: "https://example.com/image2_low.jpg",
                    width: 320,
                    height: 240
                )
            )
        )
        viewModel = CollectionViewModel(networkService: MockNetworkService(userMedia: [mockUserMedia1, mockUserMedia2]))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testGetImageAtIndex() {
        viewModel.fetchUserMedia()
        let expectation = self.expectation(description: "Wait for data to load")
        DispatchQueue.global().async {
            sleep(1)
            let imageAtIndex0 = self.viewModel.getImage(at: 0)
            let imageAtIndex1 = self.viewModel.getImage(at: 1)
            XCTAssertEqual(imageAtIndex0, "https://example.com/image1_low.jpg")
            XCTAssertEqual(imageAtIndex1, "https://example.com/image2_low.jpg")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testImageArrayCount() {
        viewModel.fetchUserMedia()
        let expectation = self.expectation(description: "Wait for data to load")
        
        DispatchQueue.global().async {
            
            sleep(1)
            
            let count = self.viewModel.imageArrayCount()
            XCTAssertEqual(count, 2)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    
    var userMedia: [UserMedia]
    
    init(userMedia: [UserMedia]) {
        self.userMedia = userMedia
    }
    
    func fetchData<T>(urlString: String, httpMethod: String, headers: [String : String]?, decoder: JSONDecoder, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        
        let userMediaResponse = UserMediaResponse(data: userMedia)
        completion(.success(userMediaResponse as! T))
    }
}
