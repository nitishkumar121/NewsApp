
import UIKit

class FavoriteNewsViewController: UIViewController {
    @IBOutlet weak var favoriteNewsTableView : UITableView!
    @IBOutlet weak var favEmptyView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nibFavCellLoad()
        self.favoriteNewsTableView.delegate = self
        self.favoriteNewsTableView.dataSource = self
        self.navigationItem.backButtonTitle = "Back"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonAction))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.favoriteSectionEmptyCondition()
        self.favoriteNewsTableView.reloadData()
    }
    private func favoriteSectionEmptyCondition(){
        if NewFeed.shared.getFavData().count >= 1{
            favEmptyView.isHidden = true
            favoriteNewsTableView.isHidden = false
        }
        else{
            favEmptyView.isHidden = false
            favoriteNewsTableView.isHidden = true
        }
    }
    @objc func editButtonAction(){
        self.favoriteNewsTableView.isEditing.toggle()
        self.navigationItem.rightBarButtonItem = (self.favoriteNewsTableView.isEditing) ? UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton)) : UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonAction))
    }
    @objc func doneButton(){
        self.favoriteNewsTableView.isEditing.toggle()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonAction))
    }
    
    private func nibFavCellLoad(){
        let nib = UINib(nibName: "FavoriteNewsTableViewCell", bundle: nil)
        favoriteNewsTableView.register(nib, forCellReuseIdentifier: "FavoriteNewsTableViewCell")
    }
}
extension FavoriteNewsViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewFeed.shared.getFavData().count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = favoriteNewsTableView.dequeueReusableCell(withIdentifier: "FavoriteNewsTableViewCell", for: indexPath) as! FavoriteNewsTableViewCell
        
        let favData = NewFeed.shared.getFavData()
        cell.setFavNewsDetails(favData[indexPath.row].newsImage, favData[indexPath.row].title, favData[indexPath.row].shortDescription)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = NewFeed.shared.getFavData()
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favData = NewFeed.shared.getFavData()
            favoriteNewsTableView.beginUpdates()
            let uid = favData[indexPath.row].uuid
            NewFeed.shared.updateFavData(id:uid , fav: false)
            favoriteNewsTableView.deleteRows(at: [indexPath], with: .automatic)
            favoriteNewsTableView.endUpdates()
            self.favoriteSectionEmptyCondition()
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}
