//
//  NewsAPIResponse.swift
//  sintyaAFL4
//
//  Created by MacBook Pro on 03/06/22.
//

import Foundation

struct NewsAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
    
}
//
