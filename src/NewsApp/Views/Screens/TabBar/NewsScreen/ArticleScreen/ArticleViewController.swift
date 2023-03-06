
import UIKit
import SnapKit

final class ArticleViewController : UIViewController {
    
    private let article: ArticleViewModel
    private let storage: NewsAppStorageProtocol
    
    private lazy var articleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.forCaptions
        return label
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person"), for: .normal)
        button.tintColor = Colors.News.notLikeColor
        button.addTarget(self, action: #selector(heartButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var articleHeaderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.forArticleTitles
        return label
    }()
    
    private lazy var articleContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.forCaptions
        return label
    }()
    
    init(article: ArticleViewModel, storage: NewsAppStorageProtocol ) {
        self.article = article
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        
        setupUI()
        
        displayModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        displayLikeStatus(articleViewModel: article)
    }
    
    private func setupUI() {
        
        view.backgroundColor = Colors.News.background
        
        view.addSubview(articleImage)
        articleImage.snp.makeConstraints { make in
            make.left.top.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(260)
        }
    
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(articleImage.snp.bottom).offset(16)
        }
        
        view.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.right.equalTo(articleImage).inset(16)
            make.top.equalTo(articleImage.snp.bottom).offset(10)
        }
        
        view.addSubview(articleHeaderLabel)
        articleHeaderLabel.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
        }

        view.addSubview(articleContentLabel)
        articleContentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(articleHeaderLabel.snp.bottom).offset(16)
        }
    }
    
    private func displayModel() {

        articleImage.image = article.image
        dateLabel.text = article.publishedAt
        articleHeaderLabel.text = article.title
        articleContentLabel.text = article.contents
        
        title = "Статья"
        
        displayLikeStatus(articleViewModel: article)
    }
    
    @objc private func heartButtonTouched() {
        article.addOrRemoveFromFavorites()
        displayLikeStatus(articleViewModel: article)
    }
    
    private func displayLikeStatus(articleViewModel: ArticleViewModel) {
        if articleViewModel.isFavorite {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartButton.tintColor = Colors.News.likeColor
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            heartButton.tintColor = Colors.News.notLikeColor
        }
    }
}
