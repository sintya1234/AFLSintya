//
//  sintyaAFL4App.swift
//  sintyaAFL4
//
//  Created by MacBook Pro on 03/06/22.
//

import SwiftUI

@main
struct sintyaAFL4App: App {
    
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articleBookmarkVM)
        }
    }
}
