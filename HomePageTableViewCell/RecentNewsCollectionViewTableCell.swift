
import UIKit

class RecentNewsCollectionViewTableCell: UITableViewCell {
    
    @IBOutlet weak var recentNewsCollectionView : UICollectionView!
    var tapOnSelect : ( (_ item : Int) -> Void)?
    var showJustForYouNavigator : (() -> Void)?
    var recentNewsCounter : Int = 0
    var passCallTableView : (() -> ())?
    var recentData: [AllNewsFeed] = NewFeed.shared.getRecentData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nibForCollectionView()
        recentNewsCollectionView.delegate =   self
        recentNewsCollectionView.dataSource = self
    }
    
    private func nibForCollectionView(){
        let nib = UINib(nibName: "RecentNewsCollectionViewCell", bundle: nil)
        recentNewsCollectionView.register(nib, forCellWithReuseIdentifier: "RecentNewsCollectionViewCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func bindData(data:[AllNewsFeed]) {
        recentData = data
        recentNewsCollectionView.reloadData()
    }
}
extension RecentNewsCollectionViewTableCell : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (recentData.count >= 3) ? 3 : recentData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentNewsCollectionViewCell", for: indexPath) as! RecentNewsCollectionViewCell
        cell.bindData(data: recentData[indexPath.row])
        cell.favPressed = {
            self.recentData[indexPath.row].isFav = true
            let uid = self.recentData[indexPath.row].uuid
            NewFeed.shared.updateFavData(id:uid , fav: true)
            self.passCallTableView!()
        }
        cell.unfavPressed = {
            let uid = self.recentData[indexPath.row].uuid
            self.recentData[indexPath.row].isFav = false
            NewFeed.shared.updateFavData(id:uid , fav: false)
            self.passCallTableView!()
        }
        
        cell.newsImage.layer.borderColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5).cgColor
        cell.newsImage.layer.borderWidth = 1
        cell.newsImage.layer.cornerRadius = 10
        cell.recenView.layer.borderColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5).cgColor
        cell.recenView.layer.borderWidth = 1
        cell.recenView.layer.cornerRadius = 10
        cell.favButton.setImage(recentData[indexPath.row].favLargeImage, for: .normal)
        cell.layer.cornerRadius = 5
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapOnSelect!(indexPath.item)
    }
}
extension RecentNewsCollectionViewTableCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}
