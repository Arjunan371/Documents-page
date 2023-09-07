
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
    let viewModel = AllDocumentsView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view2.layer.cornerRadius = 10
        view2.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view2.clipsToBounds = true
        customView.layer.cornerRadius = 10
        downloadButton.isHidden = true
        downloadButton.layer.cornerRadius = 5
        contentView.layer.backgroundColor = CGColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        self.reloadTableView?()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        customView.layer.masksToBounds = false
        customView.layer.shadowOffset = CGSize(width: -1, height: 1)
        customView.layer.shadowRadius = 3
        customView.layer.shadowOpacity = 0.2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    }
}
