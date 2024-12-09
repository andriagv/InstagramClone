//
//  MediaModel.swift
//  Insatgram
//
//  Created by Elene on 24.11.24.
//
import Foundation
 
struct MediaModel: Codable {
    let id: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "image_url"
    }
}
 
struct MediaResponse: Codable {
    let data: [MediaModel]
    let meta: MetaModel
}
 
struct MetaModel: Codable {
    let code: Int
}
