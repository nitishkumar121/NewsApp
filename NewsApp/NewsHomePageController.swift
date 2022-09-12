
import UIKit

class NewsHomePageController : UIViewController {
    
    @IBOutlet weak private var HomePageTableView  : UITableView!
    @IBOutlet weak private var headerView         : UIView!
    @IBOutlet weak private var bellIcon           : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homePageLoad()
        self.homePageTableViewCellXibLoad()
        self.HomePageTableView.frame.size.height = 50
    }
    
    private func homePageLoad(){
        self.navigationItem.title = greetingMessage()
    }
    
    private func greetingMessage() -> String{
        let today = Date()
        let hours   = (Calendar.current.component(.hour, from: today))
        let name = "Nitish."
        if hours < 12 {
            return "Good morning, " +  name
        }
        else if hours >= 12 && hours < 17 {
            return  "Good afterNoon, " +  name
        }
        else  {
            return  "Good evening, " + name
        }
    }
    //MARK: - Home Page TableView XIB Cell Register
    private func homePageTableViewCellXibLoad(){
        let nib = UINib(nibName: "RecentNewsCollectionViewTableCell", bundle: nil)
        HomePageTableView.register(nib, forCellReuseIdentifier: "RecentNewsCollectionViewTableCell")
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HomePageTableView.reloadData()
        
    }
    
}
extension NewsHomePageController : UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var counter = 0
        switch section{
        case    0  : return  1
        default    : let sectionName = allNewsDateArray[section - 1 ]
            let row  = NewFeed.shared.newsFeed.map { $0.newsUploadDate
            }
            
            for i in row{
                if sectionName == i{
                    counter += 1
                }
            }
            return  counter
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0 : let cell = tableView.dequeueReusableCell(withIdentifier: "RecentNewsCollectionViewTableCell", for: indexPath) as!  RecentNewsCollectionViewTableCell
            cell.bindData(data:  NewFeed.shared.getRecentData())
            cell.passCallTableView = {
                
                self.HomePageTableView.reloadData()
            }
            cell.tapOnSelect = { ( item ) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "NewsDetailPageController") as! NewsDetailPageController
                vc.tempTitle = recentNews[item].title
                vc.tempDesc  = recentNews[item].shortDescription
                vc.tempImg   = recentNews[item].newsImage
                vc.fullDesc  = recentNews[item].longDescription
                vc.id        = recentNews[item].uuid
                vc.flag     =  recentNews[item].isFav
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
            
        default :
            let sectionDateName =  allNewsDateArray[indexPath.section -  1]
            var  data = NewFeed.shared.newsFeed.filter{$0.newsUploadDate == sectionDateName}
            data = [AllNewsFeed](data.reversed())
            let nib = UINib(nibName: "NewsFeedTableViewCell", bundle: nil)
            HomePageTableView.register(nib, forCellReuseIdentifier: "NewsFeedTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell", for: indexPath) as!  NewsFeedTableViewCell
            cell.bindTableData(data:data[indexPath.row])
            
            cell.favPressed = {
                data[indexPath.row].isFav = true
                let uid = data[indexPath.row].uuid
                NewFeed.shared.updateFavData(id:uid , fav: true)
                self.HomePageTableView.reloadData()
                
            }
            cell.favUnPressed = {
                let uid = data[indexPath.row].uuid
                data[indexPath.row].isFav = false
                NewFeed.shared.updateFavData(id:uid , fav: false)
                self.HomePageTableView.reloadData()
                
            }
            cell.newsImage.layer.borderColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5).cgColor
            cell.newsImage.layer.borderWidth =  1
            cell.newsImage.layer.cornerRadius = 15
            cell.layer.borderColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5).cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 8
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionDateName =  allNewsDateArray[indexPath.section -  1]
        var data = NewFeed.shared.newsFeed.filter{$0.newsUploadDate == sectionDateName}
        data = [AllNewsFeed](data.reversed())
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewsDetailPageController") as! NewsDetailPageController
        vc.tempTitle = data[indexPath.row].title
        vc.tempImg = data[indexPath.row].newsImage
        vc.fullDesc = data[indexPath.row].longDescription
        vc.tempDesc = data[indexPath.row].shortDescription
        vc.flag     = data[indexPath.row].isFav
        vc.id       = data[indexPath.row].uuid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return allNewsDateArray.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0  : return 350
        default : return 100
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}
extension NewsHomePageController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0 :let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
            let label = UILabel(frame: CGRect(x: 15, y: 10, width: view.frame.width, height: 40))
            label.font = .boldSystemFont(ofSize: 18)
            label.textColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5)
            view.addSubview(label)
            label.text = "Recent News"
            return view
        default :let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
            let label = UILabel(frame: CGRect(x: 15, y: 10, width: view.frame.width, height: 40))
            label.font = .boldSystemFont(ofSize: 18)
            label.textColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5)
            view.addSubview(label)
            label.text = "News Feeds"
            return nil
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        else {
            return allNewsDateArray[section - 1]
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
            let label = UILabel(frame: CGRect(x: 15, y: 10, width: view.frame.width, height: 40))
            label.font = .boldSystemFont(ofSize: 18)
            label.textColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.5)
            view.addSubview(label)
            label.text = "News Feeds"
            return view
        }
        return nil
    }
}

