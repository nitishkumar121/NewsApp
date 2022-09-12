import UIKit

class FavoriteNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var favNewsImage : UIImageView!
    @IBOutlet weak var favNewsTitle : UILabel!
    @IBOutlet weak var favNewsShortDescription  : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func setFavNewsDetails(_ favNewsImage : UIImage , _ favNewsTitle : String , _ favNewsShortDescription : String ){
        self.favNewsImage.image = favNewsImage
        self.favNewsTitle.text = favNewsTitle
        self.favNewsShortDescription.text = favNewsShortDescription
        self.favNewsImage.layer.cornerRadius = 20
        
    }
    
}
