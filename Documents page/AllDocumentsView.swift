//
//  AllDocumentsView.swift
//  Documents page
//
//  Created by Digival on 17/08/23.
//

import UIKit
import QuartzCore
class AllDocumentsView: UIViewController {
    @IBOutlet weak var pagingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var AllDocuments: UILabel!
    @IBOutlet weak var Starred: UILabel!
    @IBOutlet weak var Recent: UILabel!
    @IBOutlet weak var DocumentTableView: UITableView!
  var isLoading = false
    let viewModel = AllDocumentViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.forApiIntegration(page: viewModel.allDocumentViewModel?.currentPage ?? 0)
        viewModel.indicatorStart = {
            DispatchQueue.main.async {
                self.pagingIndicator.startAnimating()
            }
           
        }

        viewModel.reloadTableView = {
            self.DocumentTableView.reloadData()
            self.pagingIndicator.isHidden = true
            self.pagingIndicator.stopAnimating()
        }
       print("good")
        DocumentTableView.delegate = self
        DocumentTableView.dataSource = self
        forCornerRadius()
//        DocumentTableView.showsVerticalScrollIndicator = false
       DocumentTableView.register(UINib(nibName: "DocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "DocumentTableViewCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    func forCornerRadius() {
        plusButton.layer.cornerRadius = 30
        searchButton.layer.cornerRadius = 16
        Recent.layer.cornerRadius = 15
        Starred.layer.cornerRadius = 15
        AllDocuments.layer.cornerRadius = 15
        Recent?.layer.masksToBounds = true
        Starred?.layer.masksToBounds = true
        AllDocuments?.layer.masksToBounds = true
    }
 

    
}

extension AllDocumentsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allDocumentViewModel?.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath) as! DocumentTableViewCell
        let documentData = viewModel.allDocumentViewModel
        //   cell.ImageData?.image = UIImage(named: documentData?.data[indexPath.row].url)
        cell.DataName?.text = "\(documentData?.data?[indexPath.row].name ?? "")"
        cell.DataUploadBy?.text = "\(documentData?.data?[indexPath.row].UploadedBy?.name?.first ?? "" )" + "  " + "\(documentData?.data?[indexPath.row].UploadedBy?.name?.last ?? "" )"
        cell.DataUpdateDate?.text = "\(documentData?.data?[indexPath.row].updatedAt ?? "")"
        cell.imageOptimization()
        if let urlString = documentData?.data?[indexPath.row].url, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.ImageData?.image = image
                    }
                }
            }
        }
        
        let cornerRadius: CGFloat = 20.0 // Adjust this value as needed
        let corners: UIRectCorner = [.topLeft, .topRight] // Specify the corners you want rounded
        
        let maskPath = UIBezierPath(roundedRect: cell.ImageData!.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        cell.ImageData?.layer.mask = maskLayer
        
        cell.reloadTableView = {
            tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
         var pageNo = viewModel.allDocumentViewModel?.currentPage ?? 0
        if indexPath.row == (viewModel.allDocumentViewModel?.data?.count ?? 0) - 10 {
            viewModel.fetchAllDocumentData(page: pageNo)
            pageNo = pageNo + 1
            viewModel.reloadTableView2 = {
                self.DocumentTableView.reloadData()
            }
        }
    }
       
    }
