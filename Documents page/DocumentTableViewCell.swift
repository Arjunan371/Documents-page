
import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var DataUpdateDate: UILabel?
    @IBOutlet weak var DataUploadBy: UILabel?
    @IBOutlet weak var DataName: UILabel?
    @IBOutlet weak var imageFormat: UIImageView?
    @IBOutlet weak var threeDot: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var ImageData: UIImageView?
    var reloadTableView: (() -> ())?
    var select = false
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.backgroundColor = UIColor.lightGray.cgColor
       // layer.backgroundColor = UIColor.green.cgColor
        customView.layer.cornerRadius = 20
        self.reloadTableView?()
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .lightGray
    }
  
    @IBAction func starAction(_ sender: Any) {
                if select == true {
                    starButton.setImage(UIImage(systemName: "star"), for: .normal)
                    starButton.tintColor = .lightGray
                    select = false
                } else {
                    starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    starButton.tintColor = .systemBlue
                    select = true
                }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        customView.layer.shadowColor = UIColor.lightGray.cgColor
        customView.layer.shadowOffset = CGSize(width: 0, height: 3);
        customView.layer.shadowOpacity = 0.5
        customView.layer.borderWidth = 1.0
        
      
 
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageOptimization() {
        if DataName?.text == "mp4" {
            imageFormat?.image = UIImage(named: "mp4")
        } else if DataName?.text == "mp3" {
            imageFormat?.image = UIImage(named: "mp3")
        } else if DataName?.text == "pdf" {
            imageFormat?.image = UIImage(named: "pdf")
        } else {
            imageFormat?.image = UIImage(named: "doc" )
        }
    }

}
