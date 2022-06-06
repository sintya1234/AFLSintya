//
//  ArticleNewsViewModel.swift
//  sintyaAFL4
//
//  Created by MacBook Pro on 03/06/22.
//


import SwiftUI


enum DataFetchPhase<T> {
    
    case empty
    case success(T)
    case failure(Error)
}

struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

@MainActor
class ArticleNewsViewModel: ObservableObject {
    
    
    
    @Published var phase = DataFetchPhase<[Article]>.empty
   // @Published var selectedCategory: Category
   @Published var fetchTaskToken: FetchTaskToken
    private let newsAPI = NewsAPI.shared
    
    //new
    @Published var searchQuery = ""
    @Published var history = [String]()
    private let historyDataStore = PlistDataStore<[String]>(filename: "histories")
    private let historyMaxLimit = 10
    private var trimmedSearchQuery: String {
        searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
       // self.selectedCategory = selectedCategory
    }
    
    func loadArticles() async {
       if Task.isCancelled { return }
       // phase = .empty
        phase = .success(Article.previewData)
//        do {
//            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
//            //let articles = try await newsAPI.fetch(from: selectedCategory)
//            if Task.isCancelled { return }
//            phase = .success(articles)
//        } catch {
//            if Task.isCancelled { return }
//            print(error.localizedDescription)
//            phase = .failure(error)
//        }
    }
    //
    
    //new
    func searchArticle() async {
        if Task.isCancelled { return }
        
        let searchQuery = trimmedSearchQuery
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await newsAPI.search(for: searchQuery)
            if Task.isCancelled { return }
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            if searchQuery != trimmedSearchQuery {
                return
            }
            phase = .failure(error)
        }
    }
    
    func addHistory(_ text: String) {
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
            history.remove(at: index)
        } else if history.count == historyMaxLimit {
            history.remove(at: history.count - 1)
        }
        
        history.insert(text, at: 0)
      //  historiesUpdated()
    }
}
