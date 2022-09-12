import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var newsTitle             : UILabel!
    @IBOutlet weak var newsShortDescription  : UILabel!
    @IBOutlet weak var newsImage             : UIImageView!
    @IBOutlet weak var favButton             : UIButton!
    var flag = false
    var favPressed :  ( () -> () )?
    var favUnPressed : ( () -> () )?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.newsTitle.text = "Title"
        self.newsImage.image = UIImage(named: "upload-image")
        self.newsShortDescription.text = "ShortDeescription"
        let image = UIImage(named: "smallHeartBlack")
        favButton.setImage(image, for: .normal)
        
    }
    func bindTableData(data:AllNewsFeed) {
        flag = data.isFav
        newsTitle.text =       data.title
        newsShortDescription.text = data.shortDescription
        newsImage.image =      data.newsImage
        favButton.setImage(data.favImage, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func favButtonPressed(_ sender: UIButton) {
        
        flag.toggle()
        if flag {
            let image = UIImage(named: "smallHeartFill")
            favButton.setImage(image, for: .normal)
            self.favPressed!()
          
        }
        else{
            let image = UIImage(named: "smallHeartBlack")
            favButton.setImage(image, for: .normal)
            self.favUnPressed!()
        }
    }
    
    func displayNewsFeed(newsFeedData: AllNewsFeed){
        newsTitle.text = newsFeedData.title
        newsImage.image = newsFeedData.newsImage
        newsShortDescription.text = newsFeedData.shortDescription
        if newsFeedData.isFav {
            let image = UIImage(named: "smallHeartFill")
            favButton.setImage(image, for: .normal)
        } else{
            let image = UIImage(named: "smallHeartBlack")
            favButton.setImage(image, for: .normal)
        }
        
    }
}


