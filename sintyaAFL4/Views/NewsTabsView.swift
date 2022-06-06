//
//  NewsTabsView.swift
//  sintyaAFL4
//
//  Created by MacBook Pro on 03/06/22.
//

import SwiftUI


struct NewsTabsView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
   // @StateObject var searchVM = ArticleSearchViewModel.shared
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: arti)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
                .refreshable(action: refreshTask)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
            //new coba2
                .searchable(text: $articleNewsVM.searchQuery)
                .onChange(of: articleNewsVM.searchQuery) { newValue in
                    if newValue.isEmpty {
                        articleNewsVM.phase = .empty
                    }
                }
                .onSubmit(of: .search, search)
                .navigationBarItems(trailing: menu)
            
//            ArticleListView(articles: articles)
//                .overlay(overlayView)
//                .task(id: articleNewsVM.fetchTaskToken, loadTask)
//                .refreshable(action: refreshTask)
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()
        }
    }
    
    //new search
    private func search() {
        let searchQuery = articleNewsVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        Task {
            await articleNewsVM.searchArticle()
        }
    }
    
    //new untuk cari
//    private var arti: [Article] {
//        if case .success(let articles) = searchVM.phase {
//            return articles
//        } else {
//            return []
//        }
//    }
    
    //untuk kasih liat list dibawah search
    
    private var arti: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadArticles()
    }
    
    @Sendable
    private func refreshTask() {
        DispatchQueue.main.async {
            articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
        }
    }
    
    private var menu: some View {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
}

struct NewsTabsView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared

    
    static var previews: some View {
        NewsTabsView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}


