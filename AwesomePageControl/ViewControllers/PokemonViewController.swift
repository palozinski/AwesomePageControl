import UIKit

class PokemonViewController: UIViewController,
                             UICollectionViewDelegateFlowLayout,
                             UIScrollViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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

