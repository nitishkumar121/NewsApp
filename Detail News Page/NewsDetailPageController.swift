
//

import UIKit

class NewsDetailPageController: UIViewController {
    @IBOutlet weak var newsImage            : UIImageView!
    @IBOutlet weak var newsTitle            : UILabel!
    @IBOutlet weak var newsShortDescription : UILabel!
    @IBOutlet weak var fullDescription      : UILabel!
    @IBOutlet weak var favButton             : UIButton!
    var tempTitle : String?
    var tempDesc : String?
    var tempImg : UIImage?
    var fullDesc : String?
    var flag :Bool = false
    var id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDetailsPage()
        self.navigationItem.title =  "News Details"
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    @IBAction func favButtonPressed(_ sender: UIButton) {
        flag.toggle()
        if flag {
            let image = UIImage(named: "heartFill")
            favButton.setImage(image, for: .normal)
            NewFeed.shared.updateFavData(id:id! , fav: true)
            
        }
        else{
            let image = UIImage(named: "heart")
            favButton.setImage(image, for: .normal)
            NewFeed.shared.updateFavData(id:id! , fav: false)
            
            
        }
    }
    private func setUpDetailsPage(){
        if let title = tempTitle{
            newsTitle.text = title
        }
        if let desc = tempDesc{
            newsShortDescription.text = desc
        }
        if let image1 = tempImg{
            newsImage.layer.cornerRadius = 10
            newsImage.layer.borderWidth = 1
            newsImage.layer.cornerRadius = 15
            newsImage.layer.borderColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5).cgColor
            newsImage.image = image1
        }
        if let fullDescription = fullDesc{
            self.fullDescription.text = fullDescription
        }
        
        if flag {
            let image = UIImage(named: "heartFill")
            favButton.setImage(image, for: .normal)
            
            print("favPressed")
        }
        else{
            let image = UIImage(named: "heart")
            favButton.setImage(image, for: .normal)
            
            print("unfavPressed")
            
        }
        
    }
    
    
}
