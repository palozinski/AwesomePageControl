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

1.  `itemSize` for `UICollectionViewDelegateFlowLayoutflow` is the method that
defines item size (the height of the page control item should be less than page
control collection view height),
1.  `scale` is needed for the `UIScrollViewDelegate` method that will control
content offset of collection views during scrolling,
1.  `insets` are also used for the`UICollectionViewDelegateFlowLayoutflow` method,
because I want start and finish my page control layout at the center of the page
control.

Collection view cell definitions for each cell with their outlets.

*****

#### Data

`Pokemon` model defines the object for `PokemonViewModel` that prepares data for
the `PokemonViewController`.

*****

![](https://cdn-images-1.medium.com/max/1200/1*L530hIDbpYBM93LN8vLvmQ.png)

#### Data Sources

Definitions of the data source object for each collection view. All classes
contains two mandatory methods for rendering views. Data sources were added in a
storyboard and connected by outlets with the collection view data source for
each component.

*****

#### View Controller

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
