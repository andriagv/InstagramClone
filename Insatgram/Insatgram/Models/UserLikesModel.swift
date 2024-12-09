//
//  UserLikesModel.swift
//  Insatgram
//
//  Created by Levan Gorjeladze on 23.11.24.
//

import Foundation

struct UserLike: Decodable {
    let profileImageName: String
    let message: String
    let postImageName: String?
}

struct UserLikesResponse: Decodable {
    let data: [UserLike]
    let meta: MetaData
}

struct MetaData: Decodable {
    let code: Int
}

extension UserLikesResponse {
    public static var jsonMock: String {
        """
        {
          "data": [
            {
              "profileImageName": "https://example.com/profile1.jpg",
              "message": "Liked your photo",
              "postImageName": "https://example.com/post1.jpg"
            },
            {
              "profileImageName": "https://example.com/profile2.jpg",
              "message": "Liked your photo",
              "postImageName": null
            }
          ],
          "meta": {
            "code": 200
          }
        }
        """
    }
}
