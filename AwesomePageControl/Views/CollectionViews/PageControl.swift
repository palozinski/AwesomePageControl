import UIKit

final class PageControl: UICollectionView {
    // 1
    var itemSize: CGSize {
        return CGSize(width: 60, height: 60)
    }
    // 2
    var scale: CGFloat {
        return bounds.width/itemSize.width
    }
    // 3
    var insets: UIEdgeInsets {
        let inset = (self.bounds.width - itemSize.width)/2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}
