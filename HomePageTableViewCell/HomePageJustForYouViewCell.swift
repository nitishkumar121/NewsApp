import UIKit

class HomePageJustForYouViewCell: UITableViewCell {

    @IBOutlet weak var JustForYouCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCollectionViewCell()
        self.JustForYouCollectionView.delegate   = self
        self.JustForYouCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    private func registerCollectionViewCell(){
        let nib = UINib(nibName: "JustForYouCollectionViewCell", bundle: nil)
        JustForYouCollectionView.register(nib, forCellWithReuseIdentifier: "JustForYouCollectionViewCell")
    }

}
extension HomePageJustForYouViewCell : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JustForYouCollectionViewCell", for: indexPath) as! JustForYouCollectionViewCell
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
extension JustForYouCollectionViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 264, height: 360)
  
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

