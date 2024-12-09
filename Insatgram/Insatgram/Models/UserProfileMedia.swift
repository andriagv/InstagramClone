//
//  UserProfileMedia.swift
//  Insatgram
//
//  Created by Apple on 23.11.24.
//

import Foundation

struct UserMediaResponse: Decodable {
    let data: [UserMedia]
}

struct UserMedia: Decodable {
    let id: String
    let images: Images
    
    struct Images: Decodable {
        let lowResolution: ImageResolution
        
        enum CodingKeys: String, CodingKey {
            case lowResolution = "low_resolution"
        }
        
        struct ImageResolution: Decodable {
            let url: String
            let width: Int
            let height: Int
        }
    }
}


extension UserMediaResponse {
    public static var jsonMock: String {
        """
        {
          "data": [
            {
              "id": "media1",
              "images": {
                "low_resolution": {
                  "url": "https://example.com/image1_low.jpg",
                  "width": 320,
                  "height": 240
                }
              }
            },
            {
              "id": "media2",
              "images": {
                "low_resolution": {
                  "url": "https://example.com/image2_low.jpg",
                  "width": 320,
                  "height": 240
                }
              }
            }
          ]
        }
        """
    }
}

