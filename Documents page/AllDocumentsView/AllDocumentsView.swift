
import UIKit
import QuartzCore
import QuickLook
import AVFoundation
class AllDocumentsView: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var documentsHead: UILabel!
    @IBOutlet weak var AllDocuments: UIButton!
    @IBOutlet weak var Starred: UIButton!
    @IBOutlet weak var DocumentTableView: UITableView!
    public var activityIndicator = ActivityIndicator()
    let documentInteractionController = UIDocumentInteractionController()
    let viewModel = AllDocumentViewModel()
    
    lazy var searchBar1: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        searchBar.barTintColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        searchBar.isUserInteractionEnabled = true
        searchBar.showsCancelButton = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var topMostVC: UIViewController? {
            return UIApplication.topViewController()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar1.isTranslucent = true
        searchBar1.clipsToBounds = false
        constraintForSearchBar()
        searchBar1.isHidden = true
        

        if viewModel.allDocumentDatums.isEmpty {
            viewModel.indicatorStart = {
                DispatchQueue.main.async {
                    self.showLoading()
                }
            }

            if viewModel.apiReady {
                viewModel.apiReady = false
                viewModel.forApiIntegration(page: 1, limit: 10,completion: {
                    self.DocumentTableView.reloadData()
                    self.hideLoadingView()
                })
            }
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
    @IBAction func StarredDocuments(_ sender: UIButton) {
        viewModel.filterButtonIndex = 1
        viewModel.filteredData()
        Starred.tintColor = .systemBlue
        AllDocuments.tintColor = .black
        DocumentTableView.reloadData()
    }
    
    @IBAction func searchAction(_ sender: Any) {

        viewModel.searchEnable = true
        searchBar1.isHidden = false
        searchButton.isHidden = true
        documentsHead.isHidden = true
    }
    @IBAction func AllDocuments(_ sender: UIButton) {
        viewModel.filterButtonIndex = 2
        viewModel.filteredData()
        Starred.tintColor = .black
        AllDocuments.tintColor = .systemBlue
        DocumentTableView.reloadData()
    }
    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.showActivityIndicator(uiView: self.view )
        }
    }
    func hideLoadingView(){
           DispatchQueue.main.async {
               self.activityIndicator.hideActivityIndicator()
           }
       }

    func forCornerRadius() {

        searchButton.layer.cornerRadius = 16
        Starred.layer.cornerRadius = 15
        AllDocuments.layer.cornerRadius = 15
        Starred?.layer.masksToBounds = true
        AllDocuments?.layer.masksToBounds = true
    }
    func constraintForSearchBar() {
        view.addSubview(searchBar1)
        
        NSLayoutConstraint.activate([
            searchBar1.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: 20),
            searchBar1.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 25),
            searchBar1.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            searchBar1.bottomAnchor.constraint(equalTo: documentsHead.bottomAnchor),
        ])
    }
    
}

extension AllDocumentsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return viewModel.filterButtonIndex == 2 ? viewModel.allDocumentDatums.count : viewModel.starredArray.count
        return searchBar1.text?.isEmpty ?? false ? viewModel.starredArray.count : viewModel.searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath) as! DocumentTableViewCell
        // cell.downloadButton.isHidden = true
        let documentData = searchBar1.text?.isEmpty ?? false ? viewModel.starredArray : viewModel.searchArray
        //  let documentData = viewModel.filterButtonIndex == 2 ? viewModel.allDocumentDatums : viewModel.starredArray
        cell.DataName?.text = "\(documentData[indexPath.row].name ?? "")"
        
        cell.DataUploadBy?.text = "\(documentData[indexPath.row].sessions?.first?.deliverySymbol ?? "")\(documentData[indexPath.row].sessions?.first?.deliveryNo ?? 0) .By Dr.\(documentData[indexPath.row].UploadedBy?.name?.first ?? "" )" + "  " + "\(documentData[indexPath.row].UploadedBy?.name?.last ?? "" )"
        print("seesionCount ===>", documentData[indexPath.row].sessions?.count ?? 0)
        let date = DateFromWebtoApp("\(documentData[indexPath.row].updatedAt ?? "")")
        cell.DataUpdateDate?.text = "Update on \(date)"
        
        cell.starButton.setImage(UIImage(systemName: documentData[indexPath.row].isStarSelected ? "star.fill" : "star"), for: .normal)
        cell.starButton.tintColor = documentData[indexPath.row].isStarSelected ? .systemBlue : .lightGray
        //    cell.imageOptimization()
        cell.playImage.isHidden = true
        
        let fileType = viewModel.apiUrl[indexPath.row].pathExtension.lowercased()
        switch fileType {
            
        case "jpg","jpeg","png" :
            let url = viewModel.apiUrl[indexPath.row]
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.ImageData?.image = image
                        
                    }
                }
            }
        case "mp4","mov" :
            cell.playImage.isHidden = false
        default:
            print("well")
        }
        
        // cell.imageTopCorner()
        cell.reloadTableView = {
            tableView.reloadData()
        }
        cell.imageConfigure(cellObj: documentData[indexPath.row])
        cell.starButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.threeDot.addTarget(self, action: #selector(threeDotbuttonAction), for: .touchUpInside)
        cell.downloadButton.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
        return cell
    }
    @objc func buttonAction(sender: UIButton!) {
        
        let btnPos = sender.convert(CGPoint.zero, to: DocumentTableView)
        guard let indexPath = DocumentTableView.indexPathForRow(at: btnPos) else {
            return
        }
        //        if viewModel.filterButtonIndex == 2 {
        //            if viewModel.allDocumentDatums[indexPath.row].isStarSelected {
        //                viewModel.allDocumentDatums[indexPath.row].isStarSelected = false
        //                viewModel.starredArray.removeAll(where: { $0.id == viewModel.allDocumentDatums[indexPath.row].id })
        //            } else {
        //                viewModel.allDocumentDatums[indexPath.row].isStarSelected = true
        //                viewModel.starredArray.append(viewModel.allDocumentDatums[indexPath.row])
        //            }
        //        } else {
        //
        //            if let index = viewModel.indexOf(data: viewModel.starredArray[indexPath.row]) {
        //                viewModel.allDocumentDatums[index].isStarSelected = false
        //            }
        //            viewModel.starredArray.remove(at: indexPath.row)
        //        }
        /*
         if viewModel.filterButtonIndex == 2 {
         if viewModel.starredArray[indexPath.row].isStarSelected {
         //viewModel.starredArray[indexPath.row].isStarSelected = false
         
         if let index = viewModel.indexOf(data: viewModel.starredArray[indexPath.row]) {
         viewModel.allDocumentDatums[index].isStarSelected = false
         }
         } else {
         //viewModel.starredArray[indexPath.row].isStarSelected = true
         
         if let index = viewModel.indexOf(data: viewModel.starredArray[indexPath.row]) {
         viewModel.allDocumentDatums[index].isStarSelected = true
         }
         }
         } else {
         viewModel.starredArray[indexPath.row].isStarSelected = false
         
         } */
        if viewModel.starredArray[indexPath.row].isStarSelected {
            if let index = viewModel.indexOf(data: viewModel.starredArray[indexPath.row]) {
                viewModel.allDocumentDatums[index].isStarSelected = false
            }
        } else {
            if let index = viewModel.indexOf(data: viewModel.starredArray[indexPath.row]) {
                viewModel.allDocumentDatums[index].isStarSelected = true
            }
        }
        viewModel.filteredData()
        DocumentTableView.reloadData()
        return
    }
    @objc func downloadButtonAction(sender: UIButton) {
        let btnPos = sender.convert(CGPoint.zero, to: DocumentTableView)
        guard let indexPath = DocumentTableView.indexPathForRow(at: btnPos) else {
            return
        }
        downloadfile(fileUrl: viewModel.starredArray[indexPath.row].url ?? "") { success, fileLocation in
            DispatchQueue.main.async {
                if success,let url = fileLocation {
                    self.shareFile(url: url)
                }
            }
        }
    }
    
    
    func shareFile(url: URL) {
        //        guard let view = topMostVC?.view else {
        //            return
        //        }
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        //documentInteractionController.presentOptionsMenu(from: view.frame, in: self.view, animated: true)
        documentInteractionController.presentOpenInMenu(from: view.frame, in: view, animated: true)
        //documentInteractionController.delegate = self
    }
    
    
    func downloadfile(fileUrl:String,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void) {
        
        
        let filename = (fileUrl.components(separatedBy: "/").last ?? "").components(separatedBy: "?").first ?? ""
        let fileExtension = filename.components(separatedBy: ".")
        if fileExtension.count <= 1 {
            completion(false, nil)
            return
        }
        //addingPercentEncoding
        guard let urlfile = URL(string: fileUrl) else{
            completion(false, nil)
            return
        }
        guard let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(false, nil)
            return
        }
        let dataPath = documentsDirectoryURL.appendingPathComponent("DocumentFile")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: dataPath, withIntermediateDirectories: true, attributes: nil)//(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                error.localizedDescription
            }
        }
        
        // lets create your destination file url
        let destinationUrl = dataPath.appendingPathComponent(filename)
        //try? FileManager.default.removeItem(at: destinationUrl)
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
            // if the file doesn't exist
        } else {
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: urlfile, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    completion(true, destinationUrl)
                } catch let error as NSError {
                    error.localizedDescription
                    completion(false, nil)
                    
                }
            }).resume()
        }
    }
    @objc func threeDotbuttonAction(sender: UIButton) {
        
        let btnPos = sender.convert(CGPoint.zero, to: DocumentTableView)
        guard let indexPath = DocumentTableView.indexPathForRow(at: btnPos) else {
            return
        }
        if viewModel.searchEnable {
            if viewModel.searchArray[indexPath.row].isSelected {
                viewModel.searchArray[indexPath.row].isSelected = false
            } else {
                viewModel.searchArray[indexPath.row].isSelected = true
            }
        } else {
            if viewModel.starredArray[indexPath.row].isSelected {
                viewModel.starredArray[indexPath.row].isSelected = false
            } else {
                viewModel.starredArray[indexPath.row].isSelected = true
            }
        }
        DocumentTableView.reloadData()
    }
    
    func DateFromWebtoApp(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM, yyyy."
        return  dateFormatter.string(from: date!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let documentData = searchBar1.text?.isEmpty ?? false ? viewModel.starredArray : viewModel.searchArray
        
        let fileType = documentData[indexPath.row].url
        if let fileExtension = URL(string: fileType ?? "")?.pathExtension.lowercased(){
            switch fileExtension {
            case "mp3", "mp4","mov", "com","" :
                let vc = PreviewViewController(nibName: "PreviewViewController", bundle: nil)
                vc.fileUrl = fileType ?? ""
                self.navigationController!.pushViewController(vc, animated: true)
            case "doc", "pdf", "jpeg","jpg","png","txt","xlsx" :
                let vc = DGPreviewController(nibName: "QlPreviewController", bundle: nil)
                vc.fileUrl = fileType ?? ""
                self.navigationController!.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }
}

extension AllDocumentsView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !viewModel.searchEnable {
            let currentPageNo = viewModel.currentPage
            let totalPageNo = viewModel.totalpage
            if viewModel.filterButtonIndex == 2 {
                if currentPageNo < totalPageNo  {
                    //   self.pagingIndicator.startAnimating()
                    self.showLoading()
                    // more items to fetch
                    if viewModel.apiReady {
                        viewModel.apiReady = false
                        self.loadMoreItems()
                    }
                }
            }
        }
        
        }
       
    func loadMoreItems(){
        viewModel.forApiIntegration(page: viewModel.currentPage + 1, limit: 10) {
//            self.pagingIndicator.stopAnimating()
            self.DocumentTableView.reloadData()
            self.hideLoadingView()
//            self.pagingIndicator.isHidden = true
        }
    }

}
extension AllDocumentsView: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar1.showsCancelButton = true
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar1.text = ""
        viewModel.searchEnable = false
        searchBar1.isHidden = true
        searchButton.isHidden = false
        DocumentTableView.reloadData()
        documentsHead.isHidden = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchArray = viewModel.starredArray.filter({ element in
            element.name?.lowercased().contains(searchText.lowercased()) == true ||
            element.UploadedBy?.name?.first?.lowercased().contains(searchText.lowercased()) == true ||         element.UploadedBy?.name?.last?.lowercased().contains(searchText.lowercased()) == true ||             element.updatedAt?.lowercased().contains(searchText.lowercased()) == true ||
            element.type?.lowercased().contains(searchText.lowercased()) == true ||
            "\(element.sessions?.first?.deliveryNo ?? 0)"
                .lowercased().contains(searchText.lowercased()) == true ||
            "\(element.sessions?.first?.deliverySymbol ?? "")"
                .lowercased().contains(searchText.lowercased()) == true
        })
        self.DocumentTableView.reloadData()
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
