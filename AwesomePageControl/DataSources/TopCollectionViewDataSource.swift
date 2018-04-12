import UIKit

class TopCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var imageNames: [String]?
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView
            .dequeueReusableCell(withReuseIdentifier: "cell",
                                 for: indexPath) as? TopCollectionViewCell,
            let imageNames = imageNames else {
            fatalError()
        }
        let imageName = imageNames[indexPath.item]
        item.imageView.image = UIImage(named: imageName)
        return item
    }
}
