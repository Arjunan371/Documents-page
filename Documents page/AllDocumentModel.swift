//
//  AllDocumentModel.swift
//  Documents page
//
//  Created by Digival on 17/08/23.
//

import Foundation

//struct AllDocumentModel {
//    var tableViewimages: String = ""
//    var labelText: String = ""
//    var drText: String = ""
//    var finalText: String = ""
//}
struct AllDocumentModel: Codable {
    let totalDoc: Int?
    let totalPages: Int?
    let currentPage: Int?
    let data: [DataInside]?
}
struct DataInside: Codable {
    let name: String?
    let url: String?
    let updatedAt: String?
    let UploadedBy: UploadedByName?
}
struct UploadedByName: Codable {
    let name: NameFirstLast?
    
}
struct NameFirstLast: Codable {
    let first: String?
    let last: String?
}
