
import UIKit

final class FavoritesViewController : UIViewController {
    
    private let favoritesViewModel: FavoritesViewModel
    
    private let defaultMargin = 18.0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.identifier)
        collectionView.backgroundColor = Colors.Favoites.background
        return collectionView
    }()
    
    init(favoritesViewModel: FavoritesViewModel) {
        self.favoritesViewModel = favoritesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Colors.Favoites.background
        
        self.title = Strings.Favorites.title
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewDidLoad() {
        collectionView.reloadData()
        
        favoritesViewModel.articleAddedToFavoritesAction = { [weak self] article in
            self?.collectionView.reloadData()
        }
        favoritesViewModel.articleRemovedFromFavoritesAction = {[weak self]  indexPath in
            self?.collectionView.deleteItems(at: [indexPath])
        }
    }
}

extension FavoritesViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.safeAreaLayoutGuide.layoutFrame.width / 2.0) - 1.5 *  18
        let height = (view.safeAreaLayoutGuide.layoutFrame.height / 3.0) - 1.0 *  18
        let cellSize = CGSize(width: width, height: height)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
    }
}

extension FavoritesViewController : UICollectionViewDelegate {
    
}

extension FavoritesViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesViewModel.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCollectionViewCell.identifier, for: indexPath) as! ArticleCollectionViewCell
        let article = favoritesViewModel.articles[indexPath.row]
        cell.update(by: article)
        return cell
    } 
}
