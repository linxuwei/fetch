//
//  fetchApp.swift
//  fetch
//
//  Created by Xuwei Lin on 1/10/25.
//

import SwiftUI
import Foundation

//Identifying && Swift Protocol transform object from JSON type data
struct Recipe: Identifiable, Codable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let sourceURL: URL?
    let youtubeURL: URL?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
        
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.cuisine = try container.decode(String.self, forKey: .cuisine)
        self.photoURLSmall = try? container.decode(URL.self, forKey: .photoURLSmall)
        self.photoURLLarge = try? container.decode(URL.self, forKey: .photoURLLarge)
        self.sourceURL = try? container.decode(URL.self, forKey: .sourceURL)
        self.youtubeURL = try? container.decode(URL.self, forKey: .youtubeURL)

        // 添加打印日志
        print(" ")
        print("Parsed Recipe: \(name)")
        print("UUID: \(id)")
        print("photoURLSmall: \(String(describing: photoURLSmall))")
        print("photoURLLarge: \(String(describing: photoURLLarge))")
        print("YoutubeURL: \(String(describing: youtubeURL))")
    }
    
}
extension Recipe {
    // 添加便捷初始化器
    init(
        id: UUID = UUID(),
        name: String = "",
        cuisine: String = "",
        photoURLSmall: URL? = nil,
        photoURLLarge: URL? = nil,
        sourceURL: URL? = nil,
        youtubeURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.cuisine = cuisine
        self.photoURLSmall = photoURLSmall
        self.photoURLLarge = photoURLLarge
        self.sourceURL = sourceURL
        self.youtubeURL = youtubeURL
    }
}


