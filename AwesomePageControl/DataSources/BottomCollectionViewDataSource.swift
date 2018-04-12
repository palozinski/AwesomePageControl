import UIKit

class BottomCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var descs: [String]?
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return descs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView
            .dequeueReusableCell(withReuseIdentifier: "cell",
                                 for: indexPath) as? BottomCollectionViewCell,
            let descs = descs else {
            fatalError()
        }
        let desc = descs[indexPath.item]
        item.descriptionLabel.text = desc
        return item
    }
}
