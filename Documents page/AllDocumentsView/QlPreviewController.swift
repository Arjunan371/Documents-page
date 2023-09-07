import UIKit
import QuickLook

class PreviewItem: NSObject, QLPreviewItem {
    
    var previewItemURL: URL?
}

class DGPreviewController: QLPreviewController, QLPreviewControllerDataSource {
    
    //var fileName: String = ""
    var fileUrl: String = ""
    
    //private var previewItem : PreviewItem!
    var previewItem: NSURL?
    var isShowError = false
    var downloadTask: URLSessionDownloadTask?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = .black
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fileUrl = ""
        self.dataSource = self;
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //self.title = fileName;
        //self.downloadfile(fileName: fileName, itemUrl: url)
        //        self.hideErrorLabel();
        self.downloadfile(fileUrl: fileUrl,completion: {(success, fileLocationURL) in
            if success {
                // Set the preview item to display======
                self.previewItem = fileLocationURL! as NSURL
                // Display file
                self.loadFile()
            }else{
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    //                    self.showErrorLbl()
                }
                debugPrint("File can't be downloaded")
            }
        })
        
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            downloadTask?.cancel()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // InprogressView.shared.hide()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.rightBarButtonItem = nil
        
    }
    //    @objc func hideErrorLabel() {
    //        guard !isShowError else {
    //            return
    //        }
    //        var found = false
    //        for v in self.view.allViews.filter({ $0 is UILabel }) {
    //            v.isHidden = true
    //            found = true
    //        }
    //
    //        if !found {
    //            self.perform(#selector(hideErrorLabel), with: nil, afterDelay: 0.1);
    //        }
    //
    //    }
    //    @objc func showErrorLbl() {
    //        var found = false
    //        for v in self.view.allViews.filter({ $0 is UILabel }) {
    //            v.isHidden = false
    //            found = true
    //            isShowError = true
    //        }
    //        if !found {
    //            self.perform(#selector(showErrorLbl), with: nil, afterDelay: 0.1);
    //        }
    //    }
    
    func downloadfile(fileUrl:String,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        
        let filename = (fileUrl.components(separatedBy: "/").last ?? "").components(separatedBy: "?").first ?? ""
        let fileExtension = filename.components(separatedBy: ".")
        if fileExtension.count <= 1 {
            completion(false, nil)
            return
        }
        //   log("downloadfile filename = \(String(describing: filename)) ----  fileExtension  = \(fileExtension)")
        //addingPercentEncoding
        guard let urlfile = URL(string: fileUrl) else{
            completion(false, nil)
            return
        }
        guard let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
            completion(false, nil)
            return
        }
        
        createNewFolder(folderName: "DocumentFile")
        // then lets create your document folder url
        //let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("DocumentFile").appendingPathComponent(filename)
        //  log("destinationUrl = \(destinationUrl)")
        //try? FileManager.default.removeItem(at: destinationUrl)
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
            // if the file doesn't exist
        } else {
            // you can use NSURLSession.sharedSession to download the data asynchronously
            downloadTask = URLSession.shared.downloadTask(with: urlfile, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    completion(true, destinationUrl)
                } catch let error as NSError {
                    //             log(error.localizedDescription)
                    completion(false, nil)
                    
                }
            })
            downloadTask?.resume()
        }
    }
    
    func createNewFolder(folderName:String){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent(folderName)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                //        log(error.localizedDescription);
            }
        }
    }
        func loadFile() {
            
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.reloadData()
            }
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return previewItem == nil ? 0 : 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return previewItem! as QLPreviewItem
        }
    }

extension UIView {
    var allViews: [UIView] {
        var views = [self]
        subviews.forEach {
            views.append(contentsOf: $0.allViews)
        }
        return views
    }
}

