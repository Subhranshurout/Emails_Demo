import UIKit

class PostViewCell: UITableViewCell {

    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var captionLbl: UILabel!
    @IBOutlet var imageLbl: UIImageView!
    @IBOutlet var locationBtn: UIButton!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
