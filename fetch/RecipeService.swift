//
//  fetchApp.swift
//  fetch
//
//  Created by Xuwei Lin on 1/10/25.
//

import SwiftUI
import Foundation

//Handling API Call from Fetch

struct APIResponse: Codable {
    let recipes: [Recipe]
}


class RecipeService {
    var url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    //Empty:https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
    //Malformed: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
    //Normal: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json

    func fetchRecipes() async throws -> [Recipe] {
        let (data, _) = try await URLSession.shared.data(from: url)
        //print(String(data: data, encoding: .utf8) ?? "No data") // 打印原始 JSON 数据
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(APIResponse.self, from: data)
        return response.recipes
    }
    
}
