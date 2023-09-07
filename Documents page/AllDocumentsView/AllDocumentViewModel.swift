//
//  AllDocumentViewModel.swift
//  Documents page
//
//  Created by Digival on 17/08/23.
//

import Foundation
class AllDocumentViewModel {
//    var reloadTableView: (() -> ())?
    var indicatorStart: (() -> ())?
    var allDocumentViewModel: AllDocumentModel?
    var allDocumentDatums: [DataInside] = []
    var currentPage = 0
    var totalpage = 0
    var apiReady = true
    var searchEnable = false
    var starredArray: [DataInside] = []
    var filterButtonIndex = 2
    var apiUrl:[URL] = []
//    var tableViewimages = ["add","minus","multi","plus"]
//    var labelText = ["CNS Module - 1","CNS Module - 1","CNS Module - 1","CNS Module - 1"]
//    var drText = ["L1,L2,L3 .By Dr Mohammed Abubakkar Salim","L1,L2,L3 .By Dr Mohammed Abubakkar Salim","L1,L2,L3 .By Dr Mohammed Abubakkar Salim","L1,L2,L3 .By Dr Mohammed Abubakkar Salim"]
//    var finalText = [ "update on 6th Nov 2020","update on 6th Nov 2020","update on 6th Nov 2020","update on 6th Nov 2020"]
//    var allDocumentViewModel: [AllDocumentModel] = []

//    func allDocument() {
//        for allDocumentData in 0..<tableViewimages.count {
//            let documentModel = AllDocumentModel(
//                tableViewimages: tableViewimages[allDocumentData],
//                labelText: labelText[allDocumentData],
//                drText: drText[allDocumentData],
//                finalText: finalText[allDocumentData]
//            )
//            allDocumentViewModel.append(documentModel)
//
//        }
//        print("\(allDocumentViewModel)")
//        }
    
    func indexOf(data: DataInside) -> Int? {
        return allDocumentDatums.lastIndex(where: {$0.id == data.id})
    }
    
//    func starredIndexOf(data: DataInside) -> Int? {
//        return starredArray.lastIndex(where: {$0.id == data.id})
//    }
    
    func filteredData(searchText: String = "") {
        
        var filterArray: [DataInside] = []
        switch filterButtonIndex {
        case 1:
            filterArray = allDocumentDatums.filter({$0.isStarSelected})
        case 2:
            filterArray = allDocumentDatums.compactMap({$0})
        default:
            break
        }
        if searchText.isEmpty {
            starredArray = filterArray.compactMap({$0})
        } else {
            starredArray = filterArray.filter({ element in
                element.name?.lowercased().contains(searchText.lowercased()) == true ||
                element.UploadedBy?.name?.first?.lowercased().contains(searchText.lowercased()) == true ||         element.UploadedBy?.name?.last?.lowercased().contains(searchText.lowercased()) == true ||             element.updatedAt?.lowercased().contains(searchText.lowercased()) == true ||
                element.type?.lowercased().contains(searchText.lowercased()) == true ||
                "\(element.sessions?.first?.deliveryNo ?? 0)"
                    .lowercased().contains(searchText.lowercased()) == true ||
                "\(element.sessions?.first?.deliverySymbol ?? "")"
                    .lowercased().contains(searchText.lowercased()) == true
            })
        }
    }
    

    func forApiIntegration(page: Int, limit: Int,completion: (() -> Void)? = nil ) {
       
        guard let url = URL(string:"https://ecs-dsapi-staging.digivalitsolutions.com/api/v1/digiclass/document/userDocuments/64afe93f2fa3d1f8c6f2b01b?type=student&pageNo=\(page)&limit=\(limit)") else {return}
        self.currentPage += 1
        self.indicatorStart?()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
             "Content-Type": "application/json; charset=utf-8",
             "_user_id": "64afe93f2fa3d1f8c6f2b01b",
             "_institution_calendar_id": "6390b1f6b6505c97e1be9337",
             "_institution_id": "5e5d0f1a15b4d600173d5692",
             "AUthorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4NTIxMjQ1NTY3IiwiaWF0IjoxNjk0MDYyOTY5LCJleHAiOjE2OTQwOTg5Njl9.6PpCggQYkWpf8EE4VMGo96y2VIDaOzadnvjNa6qdDyU"
         ]
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {(data,response,error) in
            if error == nil {
                do{
                    let decoder = JSONDecoder()
                    guard let getdata = data else {return}
                     let jasonvalue = try decoder.decode(AllDocumentModel.self, from: getdata)
                    print("responce===>", jasonvalue)
                    self.totalpage = jasonvalue.totalPages ?? 0
                        print("totalpage====>",jasonvalue.totalPages ?? 0)
                        print("currentPage===>",self.currentPage)
                        
                        if self.currentPage == 1 {
                            self.allDocumentDatums = jasonvalue.data ?? []
                        } else {
                            self.allDocumentDatums.append(contentsOf: jasonvalue.data ?? [])
                        }
                    for urls in 0..<(jasonvalue.data?.count ?? 0) {
                        if let url = URL(string: jasonvalue.data?[urls].url ?? "") {
                            self.apiUrl.append(url)
                        }
                       
                    }
                    print("apiUrlCount ====>", self.apiUrl.count)
                        print("totalDoc====>",jasonvalue.totalDoc ?? 0)
                        print("jasonvalue====>",jasonvalue)
                        print("allDocumentDatums==>",self.allDocumentDatums.count)
                    self.filteredData()
                        DispatchQueue.main.async {
                            completion?()
                        }
                    
                        self.apiReady = true
            } catch{
                print("error==>",error)
                print("very bad")
            }
            }
        }
        dataTask.resume()
    }
}
