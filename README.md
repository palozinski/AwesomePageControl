# Advanced UICollectionView as an example of the page control for the mini Pokédex
iOS application.

![](https://cdn-images-1.medium.com/max/1600/1*Jqoaci5ZzacE1Rkqatw1oQ.png)

> Imagine your the best designer has an idea for an awesome page control component
> and you, as a iOS developer, want to avoid any shame just said ‘no problem’ ;)
In this article, I will present a prototype of awesome page control for your
application. You don’t have to be a Pikachu or another clever beastie :)

![](https://cdn-images-1.medium.com/max/1600/1*H8rbdfQc9Zd4XBDcbDZX_Q.gif)

*****

![](https://cdn-images-1.medium.com/max/1200/1*Zr1aSxTPMt8eOg7Im9xiRQ.png)

#### User Interface

Let’s start and create a new Single View App Xcode project. On the initial view
controller of the Main.storyboard, drag and drop three collection views that
fill the width of the screen. In my case, the page control collection view is in
the middle of the view between top and bottom collection views for first and
second part of the content. Scroll direction for each component is setup as
horizontal. In order to not complicate the example, only the bottom collection
view is scrollable. Feel free and make your own layout if you want :)

![](https://cdn-images-1.medium.com/max/1200/1*6Y5kF4qzM34-rqh68eTKMA.png)

The view hierarchy looks like that. The top collection view for first part of
the content contains a cell with image view. The page control collection view
cell has two image views for active and inactive state. Finally, the bottom
collection view cell contains labels for the second part of the content.

```swift
import UIKit

final class BottomCollectionView: UICollectionView {
    //1
    var itemSize: CGSize {
        return bounds.size
    }
}
```
```swift
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
```
```swift
import UIKit

final class TopCollectionView: UICollectionView {
    // 1
    var itemSize: CGSize {
        return bounds.size
    }
}
```

1.  `itemSize` for `UICollectionViewDelegateFlowLayoutflow` is the method that
defines item size (the height of the page control item should be less than page
control collection view height),
1.  `scale` is needed for the `UIScrollViewDelegate` method that will control
content offset of collection views during scrolling,
1.  `insets` are also used for the`UICollectionViewDelegateFlowLayoutflow` method,
because I want start and finish my page control layout at the center of the page
control.

```swift
import UIKit

final class BottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
}
```

```swift
import UIKit

final class PageControlCell: UICollectionViewCell {
    
    @IBOutlet weak var inactiveImageView: UIImageView!
    @IBOutlet weak var activeImageView: UIImageView!
}
```

```swift
import UIKit

final class TopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
}
```

Collection view cell definitions for each cell with their outlets.

*****

#### Data

`Pokemon` model defines the object for `PokemonViewModel` that prepares data for
the `PokemonViewController`.

```swift
import Foundation

struct Pokemon {
    let imageName: String
    let desc: String
}
```

```swift
import Foundation

final class PokemonsViewModel {
    
    lazy var pokemons: [Pokemon] = {
        var data: [Pokemon] = []
        for x in 0..<151 {
            data.append(
                Pokemon(
                    imageName: "\(x + 1)",
                    desc: "#\(x + 1)")
            )}
        return data
    }()
}
```

```swift
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
```

```swift
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
```

*****

![](https://cdn-images-1.medium.com/max/1200/1*L530hIDbpYBM93LN8vLvmQ.png)

#### Data Sources

Definitions of the data source object for each collection view. All classes
contains two mandatory methods for rendering views. Data sources were added in a
storyboard and connected by outlets with the collection view data source for
each component.

*****

#### View Controller

```swift
import UIKit

class PokemonViewController: UIViewController,
                             UICollectionViewDelegateFlowLayout,
                             UIScrollViewDelegate {
    
    private var viewModel: PokemonsViewModel? {
        didSet {
            // 2
            (topCollectionView.dataSource as? TopCollectionViewDataSource)?
                .imageNames = viewModel?.pokemons.map { $0.imageName }
            (pageControl.dataSource as? PageControlDataSource)?
                .count = viewModel?.pokemons.count
            (bottomCollectionView.dataSource as? BottomCollectionViewDataSource)?
                .descs = viewModel?.pokemons.map { $0.desc }
            // 3
            topCollectionView.reloadData()
            pageControl.reloadData()
            bottomCollectionView.reloadData()
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet private weak var bottomCollectionView: BottomCollectionView!
    @IBOutlet private weak var topCollectionView: TopCollectionView!
    @IBOutlet private weak var pageControl: PageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        viewModel = PokemonsViewModel()
        // 4
        bottomCollectionView.isPagingEnabled = true
    }
    
    // MARK: Collection View Delegate Flow Layout
    // 5
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case topCollectionView:
            return topCollectionView.itemSize
        case pageControl:
            return pageControl.itemSize
        case bottomCollectionView:
            return bottomCollectionView.itemSize
        default:
            return CGSize.zero
        }
    }
    // 6
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == pageControl {
            return pageControl.insets
        }
        return .zero
    }
    
    // MARK: Scroll View Delegate
    // 7
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bottomCollectionView {
            let scale = pageControl.scale
            topCollectionView.contentOffset.x = scrollView.contentOffset.x
            pageControl.contentOffset.x = scrollView.contentOffset.x / scale
        }
    }
}
```

1.  `PokemonViewModel` initialization after view was loaded,
1.  assign content for each data source,
1.  reload each collection view,
1.  enable pagination for scrollable collection view, allows scroll on one side,
1.  `UICollectionViewDelegateFlowLayout` method defines the item size for each
collection view,
1.  `UICollectionViewDelegateFlowLayout` method defined edge insets for page
control, allows for starting and finishing the layout at the center of the page
control,
1.  `UIScrollViewDelegate` method controls content offset of the top collection view
and page control while the bottom collection view is scrolling.

*****

#### GOAL

This paragraph describes the most important `PageControlFlowLayout` class
definition that makes the page control collection view an awesome custom
component.

```swift
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
```

1.  return `true` if you want to always change layout when items change position,
1.  get all attributes in the collection view content size,
1.  unwrapping optional collection view,
1.  variables required to calculations,
1.  get distance from the center for each attribute and `maxY` value (the height of
the item should be less than height of the collection view component),
1.  get page control cell for attribute’s index path for changing the content of the
page control,
1.  if the cell is far from the center, the active image is hidden by set `alpha =
0` and cell lays at the bottom of the collection view,
1.  if cell is close enough to the center, it has a position consistent with the
linear equation.

### Another app result

<span class="figcaption_hack">HiBaby!</span>

* [iOS](https://medium.com/tag/ios?source=post)
* [Uicollectionview](https://medium.com/tag/uicollectionview?source=post)
* [Swift](https://medium.com/tag/swift?source=post)
* [Xcode](https://medium.com/tag/xcode?source=post)
* [iPhone](https://medium.com/tag/iphone?source=post)

By clapping more or less, you can signal to us which stories really stand out.

### [Paweł Łoziński](https://medium.com/@paweoziski)

IOS Developer
