//
//  APIResponse.swift
//  PhotoApplication
//
//  Created by Константин Малков on 24.09.2022.
//

import Foundation

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let regular: String
}
