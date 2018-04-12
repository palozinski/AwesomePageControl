import UIKit

class PageControlDataSource: NSObject, UICollectionViewDataSource {
    
    var count: Int?
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView
            .dequeueReusableCell(withReuseIdentifier: "cell",
                                 for: indexPath) as? PageControlCell else {
            fatalError()
        }
        return item
    }
}
