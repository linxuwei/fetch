//
//  fetchTests.swift
//  fetchTests
//
//  Created by Xuwei Lin on 1/10/25.
//

import Testing
import XCTest
@testable import fetch

struct fetchTests {

    // 1. 测试成功获取有效的菜谱数据
    @Test func testFetchRecipesSuccess() async throws {
        let service = RecipeService()
        let recipes = try await service.fetchRecipes()

        XCTAssertFalse(recipes.isEmpty, "Recipes list should not be empty")
        XCTAssertNotNil(recipes.first?.name, "First recipe should have a name")
        XCTAssertNotNil(recipes.first?.cuisine, "First recipe should have a cuisine")
    }

    // 2. 测试处理 JSON 格式错误的数据
    @Test func testFetchRecipesMalformedData() async throws {
        let service = RecipeService()
        service.url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!

        do {
            _ = try await service.fetchRecipes()
            XCTFail("Fetching malformed data should throw an error")
        } catch {
            XCTAssertTrue(error is DecodingError, "Error should be of type DecodingError")
        }
    }

    // 3. 测试处理空数据的情况
    @Test func testFetchRecipesEmptyData() async throws {
        let service = RecipeService()
        service.url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!

        let recipes = try await service.fetchRecipes()
        XCTAssertTrue(recipes.isEmpty, "Recipes list should be empty")
    }

    @Test func testRecipeInitialization() {
        let recipe = Recipe(
            id: UUID(),
            name: "Test Recipe",
            cuisine: "Test Cuisine",
            photoURLSmall: nil as URL?, // 明确指定 nil 的类型为 URL?
            photoURLLarge: nil as URL?, // 同样处理其他 URL? 参数
            sourceURL: nil as URL?,
            youtubeURL: nil as URL?
        )

        XCTAssertEqual(recipe.name, "Test Recipe", "Recipe name should match")
        XCTAssertEqual(recipe.cuisine, "Test Cuisine", "Cuisine type should match")
        XCTAssertNil(recipe.photoURLSmall, "Small photo URL should be nil")
        XCTAssertNil(recipe.photoURLLarge, "Large photo URL should be nil")
    }

    // 5. 测试图片缓存功能
    @Test func testImageCache() {
        let cache = ImageCache.shared
        let url = URL(string: "https://some.url/image.jpg")!
        let image = UIImage(systemName: "photo")!

        cache.save(image: image, for: url)
        let cachedImage = cache.image(for: url)

        XCTAssertNotNil(cachedImage, "Image should be cached")
        XCTAssertEqual(cachedImage, image, "Cached image should match the original image")
    }

    // 6. 测试详情视图数据加载
    @Test  func testDetailViewData() {
        let recipe = Recipe(
            id: UUID(),
            name: "Test Recipe",
            cuisine: "Test Cuisine",
            photoURLSmall: nil,
            photoURLLarge: URL(string: "https://some.url/large.jpg"),
            sourceURL: URL(string: "https://source.url"),
            youtubeURL: URL(string: "https://youtube.com")
        )

        XCTAssertEqual(recipe.name, "Test Recipe", "Recipe name should match")
        XCTAssertEqual(recipe.cuisine, "Test Cuisine", "Cuisine type should match")
        XCTAssertNotNil(recipe.photoURLLarge, "Large photo URL should not be nil")
        XCTAssertNotNil(recipe.sourceURL, "Source URL should not be nil")
        XCTAssertNotNil(recipe.youtubeURL, "YouTube URL should not be nil")
    }

    // 7. 测试错误处理机制
    @Test func testErrorHandling() {
        let errorMessage = ErrorMessage(message: "Test error")
        XCTAssertEqual(errorMessage.message, "Test error", "Error message should match")
    }

    // 8. 测试刷新功能是否调用 API
    @Test func testRefreshRecipes() async throws {
        let service = RecipeService()
        let initialRecipes = try await service.fetchRecipes()

        let refreshedRecipes = try await service.fetchRecipes()
        XCTAssertEqual(initialRecipes.count, refreshedRecipes.count, "Recipe count should match after refresh")
    }

    // 9. 测试导航到详情视图
    @Test func testNavigationToDetailView() {
        let recipe = Recipe(
            id: UUID(),
            name: "Test Recipe",
            cuisine: "Test Cuisine",
            photoURLSmall: nil,
            photoURLLarge: nil,
            sourceURL: nil,
            youtubeURL: nil
        )

        let detailView = DetailView(recipe: recipe)
        XCTAssertEqual(detailView.recipe.name, "Test Recipe", "DetailView should display the correct recipe name")
    }

    // 10. 测试 RecipeService 的 URL 初始化
    @Test func testRecipeServiceURL() {
        let service = RecipeService()
        XCTAssertEqual(service.url.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json", "Service URL should match the expected endpoint")
    }
    
    @Test func testFetchEmptyRecipes() async throws {
        // Arrange: 使用空数据的 URL 替换
        let service = RecipeService()
        service.url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        
        // Act: 尝试从空数据的 URL 获取数据
        let recipes = try await service.fetchRecipes()
        
        // Assert: 验证返回的列表为空
        XCTAssertTrue(recipes.isEmpty, "Recipes list should be empty when the API returns no data.")
    }

}
