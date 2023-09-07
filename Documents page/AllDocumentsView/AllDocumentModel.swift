//
//  AllDocumentModel.swift
//  Documents page
//
//  Created by Digival on 17/08/23.
//

import Foundation

struct AllDocumentModel: Codable {
    let totalDoc: Int?
    let totalPages: Int?
    let currentPage: Int?
    let data: [DataInside]?
}

struct DataInside: Codable {
    let id: String?
    let name: String?
    let url: String?
    let type: String?
    let updatedAt: String?
    let UploadedBy: UploadedByName?
    let sessions: [SessionName]?
    var isStarSelected: Bool = false
    var isSelected = false
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case url
        case updatedAt
        case UploadedBy
        case sessions
        case type
    }
}

struct UploadedByName: Codable {
    let name: NameFirstLast?
    
}

struct NameFirstLast: Codable {
    let first: String?
    let last: String?
}

struct SessionName: Codable {
    let deliverySymbol:String?
    let deliveryNo: Int?    
    enum CodingKeys: String, CodingKey {
        case deliverySymbol = "delivery_symbol"
        case deliveryNo = "delivery_no"
    }
}
