import SwiftUI
import Foundation

// 定义错误消息结构体，用于显示错误警告框
struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

// The Main page of Entire APP.
// Displays a list of cuisines + Refresh Button + Error Handling
struct ContentView: View {
    // 使用 @State 存储 API 返回的菜谱数据
    @State private var recipes: [Recipe] = []
    // 用于存储错误信息
    @State private var errorMessage: ErrorMessage?

    var body: some View {
        NavigationStack {
            List(recipes) { recipe in
                // 为每个菜谱提供一个导航链接，跳转到详情视图
                NavigationLink(destination: DetailView(recipe: recipe)) {
                    HStack {
                        // 替换为 CachedAsyncImage
                        if let url = recipe.photoURLSmall {
                            CachedAsyncImage(url: url)
                                .frame(width: 50, height: 50)
                                .cornerRadius(5)
                        }

                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline)
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                // 添加刷新按钮
                Button("Refresh") {
                    Task {
                        await loadRecipes()
                    }
                }
            }
        }
        .task {
            await loadRecipes()
        }
        .alert(item: $errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    // 加载菜谱数据
    func loadRecipes() async {
        do {
            let service = RecipeService()
            recipes = try await service.fetchRecipes()
            print("Fetched recipes: \(recipes.count)")
        } catch {
            errorMessage = ErrorMessage(message: "Failed to load recipes: \(error.localizedDescription)")
        }
    }
}

// 详情视图
struct DetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 使用 CachedAsyncImage 替代 AsyncImage
                if let url = recipe.photoURLLarge {
                    CachedAsyncImage(url: url)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                }

                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Cuisine: \(recipe.cuisine)")
                    .font(.title2)
                    .foregroundColor(.secondary)

                if let sourceURL = recipe.sourceURL {
                    Link("View Source Recipe", destination: sourceURL)
                        .font(.body)
                        .foregroundColor(.blue)
                }

                if let youtubeURL = recipe.youtubeURL {
                    Link("Watch on YouTube", destination: youtubeURL)
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
