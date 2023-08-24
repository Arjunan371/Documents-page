//
//  AllDocumentViewModel.swift
//  Documents page
//
//  Created by Digival on 17/08/23.
//

import Foundation
class AllDocumentViewModel {
    var reloadTableView: (() -> ())?
    var reloadTableView2: (() -> ())?
    var indicatorStart: (() -> ())?
    var allDocumentViewModel: AllDocumentModel?
    var newModel: AllDocumentModel?
    var allDocumentViewModel2:AllDocumentModel?

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
    func forApiIntegration(page: Int ) {
       
        guard let url = URL(string:"https://ecs-dsapi-staging.digivalitsolutions.com/api/v1/digiclass/document/userDocuments/64afe93f2fa3d1f8c6f2b01b?type=student&pageNo=1&limit=10") else {return}
        
        self.indicatorStart?()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
             "Content-Type": "application/json; charset=utf-8",
             "_user_id": "64afe93f2fa3d1f8c6f2b01b",
             "_institution_calendar_id": "6390b1f6b6505c97e1be9337",
             "_institution_id": "5e5d0f1a15b4d600173d5692",
             "AUthorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJJTlQwMDIyIiwiaWF0IjoxNjkyODU1NzY3LCJleHAiOjE2OTI4OTE3Njd9.hwHmuebBTbUOTfBV70mafsmcgj2U1P2KnBz9TnOuSHo"
         ]
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            guard error == nil else {return}
            guard let getdata = data else {return}
            do{
                if let jasonvalue = try? JSONDecoder().decode(AllDocumentModel.self, from: getdata){
                    self.allDocumentViewModel = jasonvalue
                    print(jasonvalue)
                    self.fetchAllDocumentData(page: jasonvalue.totalPages ?? 0)
                    DispatchQueue.main.async {
                        self.reloadTableView?()
                    }
                  
                }

            }catch{
                print("very bad")
            }
            
        }.resume()
        
    }
    
    func fetchAllDocumentData(page:Int) {
        guard let url = URL(string:"https://ecs-dsapi-staging.digivalitsolutions.com/api/v1/digiclass/document/userDocuments/64afe93f2fa3d1f8c6f2b01b?type=student&pageNo=\(page)&limit=10") else {return}
        
        self.indicatorStart?()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
             "Content-Type": "application/json; charset=utf-8",
             "_user_id": "64afe93f2fa3d1f8c6f2b01b",
             "_institution_calendar_id": "6390b1f6b6505c97e1be9337",
             "_institution_id": "5e5d0f1a15b4d600173d5692",
             "AUthorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJJTlQwMDIyIiwiaWF0IjoxNjkyODU1NzY3LCJleHAiOjE2OTI4OTE3Njd9.hwHmuebBTbUOTfBV70mafsmcgj2U1P2KnBz9TnOuSHo"
         ]
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            guard error == nil else {return}
            guard let getdata = data else {return}
            do{
                if let jasonvalue = try? JSONDecoder().decode(AllDocumentModel.self, from: getdata){
                    self.allDocumentViewModel2 = jasonvalue
                    print(jasonvalue)

                    DispatchQueue.main.async {
                        self.reloadTableView2?()
                    }
                  
                }

            }catch{
                print("very bad")
            }
            
        }.resume()
    }
        
    }
    
    
    

