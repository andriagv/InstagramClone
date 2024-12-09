//
//  TagModel.swift
//  Insatgram
//
//  Created by Elene on 24.11.24.
//
import Foundation
 
struct TagModel: Codable {
    let mediaCount: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case mediaCount = "media_count"
        case name = "name"
    }
}
 
struct TagResponse: Codable {
    let data: [TagModel]
    let meta: Meta
}
 
struct Meta: Codable {
    let code: Int
}
