
import UIKit

class RecentNewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newsImage        : UIImageView!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var shortDescription : UILabel!
    @IBOutlet weak var recenView        : UIView!
    
    @IBOutlet weak var favButton : UIButton!
    var favPressed : (() -> () )?
    var unfavPressed : ( () -> ())?
    var flag = false
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(data:AllNewsFeed) {
        flag = data.isFav
        titleLabel.text =       data.title
        shortDescription.text = data.shortDescription
        newsImage.image =      data.newsImage
        favButton.setImage(data.favLargeImage, for: .normal)
    }
     @IBAction func favButtonPressed(_ sender: UIButton) {
        flag.toggle()
        if flag {
            let image = UIImage(named: "heartFill")
            favButton.setImage(image, for: .normal)
            favPressed!()
            
        }
        else{
            let image = UIImage(named: "heart")
            favButton.setImage(image, for: .normal)
            unfavPressed!()
            }
    }
    
}
