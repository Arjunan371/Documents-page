
import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var DataUpdateDate: UILabel?
    @IBOutlet weak var DataUploadBy: UILabel?
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var DataName: UILabel?
    @IBOutlet weak var imageFormat: UIImageView?
    @IBOutlet weak var threeDot: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var ImageData: UIImageView?
    var reloadTableView: (() -> ())?   
   
    let viewModel = AllDocumentViewModel()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        downloadButton.isHidden = true
        downloadButton.layer.cornerRadius = 5
        contentView.layer.backgroundColor = CGColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
       // layer.backgroundColor = UIColor.green.cgColor
        customView.layer.cornerRadius = 10
        self.reloadTableView?()
//        starButton.setImage(UIImage(systemName: "star"), for: .normal)
//        starButton.tintColor = .lightGray
            view2.roundCorners( [.topRight, .topLeft], radius: 10)
    }
  
//    @IBAction func starAction(_ sender: Any) {
//                if select == true {
//                    starButton.setImage(UIImage(systemName: "star"), for: .normal)
//                    starButton.tintColor = .lightGray
//                    select = false
//                } else {
//                    starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
//                    starButton.tintColor = .systemBlue
//                    select = true
//                }
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        customView.layer.masksToBounds = false
//        customView?.layer.shadowColor = UIColor.black.cgColor
//        customView?.layer.shadowOpacity = 0.2
//        customView?.layer.shadowRadius = 3
        customView.layer.masksToBounds = false
        customView.layer.shadowOffset = CGSize(width: -1, height: 1)
        customView.layer.shadowRadius = 3
        customView.layer.shadowOpacity = 0.3
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func imageConfigure(cellObj: DataInside) {
        switch cellObj.name?.lowercased() {
        case "mp4" :
            imageFormat?.image = UIImage(named: "mp4")
        case "mp3" :
            imageFormat?.image = UIImage(named: "mp3")
        case  "pdf" :
            imageFormat?.image = UIImage(named: "pdf")
        case "doc" :
            imageFormat?.image = UIImage(named: "doc")
        default :
            imageFormat?.image = UIImage(named: "doc")
        }
        
        if cellObj.isSelected {
            downloadButton.isHidden = false
        } else {
            downloadButton.isHidden = true
        
        }
        
    }
    
//    func imageOptimization() {
//        if DataName?.text == "mp4" .lowercased() {
//            imageFormat?.image = UIImage(named: "mp4")
//        } else if DataName?.text == "mp3".lowercased() {
//            imageFormat?.image = UIImage(named: "mp3")
//        } else if DataName?.text == "pdf".lowercased() {
//            imageFormat?.image = UIImage(named: "pdf")
//        } else {
//            imageFormat?.image = UIImage(named: "doc" )
//        }
//    }
//    func imageTopCorner() {
//        let cornerRadius: CGFloat = 10.0 // Adjust this value as needed
//        let corners: UIRectCorner = [.topLeft, .topRight] // Specify the corners you want rounded
//
//        let maskPath = UIBezierPath(roundedRect: ImageData!.bounds,
//                                    byRoundingCorners: corners,
//                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = maskPath.cgPath
//        ImageData?.layer.mask = maskLayer
//    }
    
    @IBAction func downloadAction(_ sender: UIButton) {
      
    }
    
}
//extension UIView {
//   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
//
//}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
