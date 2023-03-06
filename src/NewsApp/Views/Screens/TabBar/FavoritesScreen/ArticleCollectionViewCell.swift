
import UIKit
import SnapKit

final class ArticleCollectionViewCell : UICollectionViewCell {
    static let identifier = "ArticleCollectionViewCell"
    
    private var article: ArticleViewModel?
    
    private lazy var articleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.forCaptions
        return label
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = Colors.News.likeColor
        button.addTarget(self, action: #selector(heartImageTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var articleHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.forArticleTitles
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.cornerRadius = 22
        clipsToBounds = true
        
        contentView.addSubview(articleImage)
        articleImage.snp.makeConstraints { make in
            make.left.top.right.equalTo(contentView)
            make.height.equalTo(contentView.frame.height / 2.0)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(6)
            make.top.equalTo(articleImage.snp.bottom).offset(8)
        }
        
        contentView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.right.equalTo(contentView).inset(10)
            make.top.equalTo(articleImage.snp.bottom).offset(6)
        }
        
        contentView.addSubview(articleHeaderLabel)
        articleHeaderLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(6)
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(by article: ArticleViewModel) {
        self.article = article
        
        articleImage.image = nil
        article.loadImage { [weak self] image in
            self?.articleImage.image = image
        }
        
        dateLabel.text = article.publishedAt
        articleHeaderLabel.text = article.title
    }
    
    @objc private func heartImageTouched() {
        guard let article = self.article else {return}
        
        article.addOrRemoveFromFavorites()
    }
}
