//
//  ContentView.swift
//  sintyaAFL4
//
//  Created by MacBook Pro on 03/06/22.
//

import SwiftUI

//https://newsapi.org/v2/everything?q=tesla&from=2022-05-03&sortBy=publishedAt&apiKey=6517a5b0391541659fc117934eadb591

struct ContentView: View {
    var body: some View {
       TabView {
            NewsTabsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
//
//            SearchTabView()
//                .tabItem {
//                    Label("Search", systemImage: "magnifyingglass")
//                }
////
            BookmarkTabView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
//        }
        
       // ArticleListView(articles: Article.previewData)
    }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//
