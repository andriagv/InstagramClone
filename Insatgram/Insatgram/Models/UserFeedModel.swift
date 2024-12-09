//
//  UserFeedModel.swift
//  Insatgram
//
//  Created by irakli kharshiladze on 22.11.24.
//

import Foundation

struct PostResponse: Decodable {
    let data: [Post]
    let meta: FeedMeta?
}

struct Post: Decodable {
    let caption: Caption?
    let createdTime: String
    let id: String
    let images: [Image]
    let likes: Likes
    let link: String
    let location: Location?
    let user: UserMain
    var userHasLiked: Bool
    let usersInPhoto: [UserInPhoto]?

    enum CodingKeys: String, CodingKey {
        case caption
        case createdTime = "created_time"
        case id
        case images
        case likes
        case link
        case location
        case user
        case userHasLiked = "user_has_liked"
        case usersInPhoto = "users_in_photo"
    }
}

struct Caption: Decodable {
    let createdTime: String
    let from: UserMain
    let id: String
    let text: String

    enum CodingKeys: String, CodingKey {
        case createdTime = "created_time"
        case from
        case id
        case text
    }
}

struct Image: Decodable {
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}

struct Likes: Decodable {
    let count: Int
    let data: [UserMain]
}

struct Location: Decodable {
    let id: String
    let latitude: Double
    let longitude: Double
    let name: String
}

struct UserMain: Decodable {
    let fullName: String
    let id: String
    let profilePicture: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case id
        case profilePicture = "profile_picture"
        case username
    }
}

struct UserInPhoto: Decodable {
    let position: Position
    let user: UserMain
}

struct Position: Decodable {
    let x: Double
    let y: Double
}

struct FeedMeta: Decodable {
    let code: Int
}

extension PostResponse {
    public static var jsonMock: String {
        """
        {
          "data": [
            {
              "caption": {
                "created_time": "2024-11-22T12:34:56Z",
                "from": {
                  "full_name": "John Doe",
                  "id": "1",
                  "profile_picture": "https://example.com/profile.jpg",
                  "username": "johndoe"
                },
                "id": "10",
                "text": "Sample caption text"
              },
              "created_time": "2024-11-22T12:34:56Z",
              "id": "101",
              "images": [
                {
                  "image_url": "https://example.com/image1.jpg"
                },
                {
                  "image_url": "https://example.com/image2.jpg"
                }
              ],
              "likes": {
                "count": 42,
                "data": [
                  {
                    "full_name": "Jane Smith",
                    "id": "2",
                    "profile_picture": "https://example.com/profile2.jpg",
                    "username": "janesmith"
                  }
                ]
              },
              "link": "https://example.com/post",
              "location": {
                "id": "location123",
                "latitude": 37.7749,
                "longitude": -122.4194,
                "name": "San Francisco"
              },
              "user": {
                "full_name": "John Doe",
                "id": "1",
                "profile_picture": "https://example.com/profile.jpg",
                "username": "johndoe"
              },
              "user_has_liked": true,
              "users_in_photo": [
                {
                  "position": {
                    "x": 0.5,
                    "y": 0.5
                  },
                  "user": {
                    "full_name": "Alice Johnson",
                    "id": "3",
                    "profile_picture": "https://example.com/profile3.jpg",
                    "username": "alicejohnson"
                  }
                }
              ]
            }
          ],
          "meta": {
            "code": 200
          }
        }
        """
    }
}
