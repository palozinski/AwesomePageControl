import UIKit

class PageControlFlowLayout: UICollectionViewFlowLayout {
    
    // 1
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 2
        let attributes = super.layoutAttributesForElements(in: rect)
        // 3
        guard let collectionView = collectionView else {
            return nil
        }
        // 4
        let size = collectionView.bounds.size
        let collectionViewHeight = collectionView.bounds.height
        let contentOffset = collectionView.contentOffset
        let visibleRect = CGRect(origin: contentOffset,
                                 size: size)
        let absoluteValueRange: CGFloat = 25
        
        attributes?.forEach {
            if $0.frame.intersects(rect) {
                // 5
                let distanceFromCenter = visibleRect.midX - $0.center.x
                let maxY = collectionViewHeight - $0.bounds.height
                // 6
                let cell = currentCellFor(attributes: $0)
                // 7
                if absoluteValueRange < abs(distanceFromCenter) {
                    cell?.activeImageView.alpha = 0
                    $0.frame.origin.y =  maxY
                    return
                }
                // 8
                cell?.activeImageView.alpha = abs((absoluteValueRange - distanceFromCenter)/absoluteValueRange)
                $0.frame.origin.y = abs(distanceFromCenter*maxY/absoluteValueRange)
            }
        }
        return attributes
    }
    
    private func currentCellFor(attributes: UICollectionViewLayoutAttributes) -> PageControlCell? {
        let indexPath = attributes.indexPath
        return collectionView?.cellForItem(at: indexPath) as? PageControlCell
    }
}
