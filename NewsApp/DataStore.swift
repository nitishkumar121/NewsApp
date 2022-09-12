import Foundation
import UIKit

struct AllNewsFeed {
    let  title : String
    let shortDescription : String
    let longDescription  : String
    let newsImage        : UIImage
    let newsUploadDate   : String
    var isFav            : Bool = false
    let uuid: String = UUID().uuidString
    
    var favImage :UIImage {
        return isFav ? UIImage(named: "smallHeartFill")! : UIImage(named: "smallHeartBlack")!
    }
    var favLargeImage : UIImage {
        return isFav ? UIImage(named: "heartFill")! : UIImage(named: "heart")!
    }
    
}

var allNewsDateSet = Set<String>()
var allNewsDateArray = [String]()
func sectionDate(){
    allNewsDateArray = [String](allNewsDateSet)
    let df = DateFormatter()
    df.dateFormat = DateFormate.dateFormate.rawValue
    allNewsDateArray = allNewsDateArray.sorted {df.date(from: $0)! > df.date(from: $1)!}
}
var recentNews : [AllNewsFeed]{
    [AllNewsFeed](NewFeed.shared.newsFeed.reversed()).sorted(by: {$0.newsUploadDate.compare($1.newsUploadDate) == .orderedDescending})
}


class NewFeed{
    static var shared = NewFeed()
    var newsFeed =  [AllNewsFeed]()
    var recentFeed =  [AllNewsFeed]()
    var favSection : [String] = []
    var favSectionSet : Set<String> = []
    
    
    func addNewData(data:AllNewsFeed) {
        newsFeed.append(data)
        
    }
    
    func updateFavData(id:String , fav:Bool) {
        if let index = newsFeed.firstIndex(where: {$0.uuid == id}) {
            
            newsFeed[index].isFav = fav
        }
    }
    
    func getFavData() -> [AllNewsFeed] {
        return newsFeed.filter{$0.isFav == true}
    }
    
    func getRecentData() -> [AllNewsFeed] {
        recentFeed = (newsFeed.reversed()).sorted(by: {$0.newsUploadDate.compare($1.newsUploadDate) == .orderedDescending})
        favSection = recentFeed.map{$0.newsUploadDate}
        favSectionSet = Set(favSection)
        return recentFeed
    }
    func favSectionTitleName(){
        favSection = [String](favSectionSet)
        let df = DateFormatter()
        df.dateFormat = DateFormate.dateFormate.rawValue
        favSection = favSection.sorted {df.date(from: $0)! > df.date(from: $1)!}
    }
    
    
}



