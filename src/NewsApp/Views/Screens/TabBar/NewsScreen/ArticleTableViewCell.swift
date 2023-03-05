
import UIKit

final class ArticleTableViewCell : UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    
    private lazy var panel: UIView = {
        let panel = UIView()
        panel.layer.cornerRadius = 22
        panel.backgroundColor = .white
        panel.clipsToBounds = true
        return panel
    }()
    
    private lazy var image: UIImageView = {
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
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(heartImageTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var articleHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.forArticleTitles
        return label
    }()
    
    private lazy var articleContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = Fonts.forCaptions
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = Colors.News.background
        
        contentView.addSubview(panel)
        panel.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(16)
            make.top.bottom.equalTo(contentView).inset(8)
            
            panel.addSubview(image)
            image.snp.makeConstraints { make in
                make.left.top.right.equalTo(image.superview!)
                make.height.equalTo(132)
            }
            
            panel.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { make in
                make.left.equalTo(dateLabel.superview!).inset(16)
                make.top.equalTo(image.snp.bottom).offset(16)
            }
            
            panel.addSubview(heartButton)
            heartButton.snp.makeConstraints { make in
                make.right.equalTo(heartButton.superview!).inset(16)
                make.top.equalTo(image.snp.bottom).offset(10)
            }
            
            panel.addSubview(articleHeaderLabel)
            articleHeaderLabel.snp.makeConstraints { make in
                make.left.right.equalTo(articleHeaderLabel.superview!).inset(16)
                make.top.equalTo(dateLabel.snp.bottom).offset(11)
            }
            
            panel.addSubview(articleContentLabel)
            articleContentLabel.snp.makeConstraints { make in
                make.left.right.equalTo(articleContentLabel.superview!).inset(16)
                make.top.equalTo(articleHeaderLabel.snp.bottom).offset(2)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(by article: Article) {
        image.image = nil
        if let urlToArticleImage = article.urlToImage {
            DispatchQueue.global().async { [weak self] in
                guard let dataFromUrl = try? Data(contentsOf: urlToArticleImage) else {return}
                guard let imageFromWeb = UIImage(data: dataFromUrl) else {return}
                DispatchQueue.main.async { [weak self] in
                    self?.image.image = imageFromWeb
                }
            }
        }
        
        dateLabel.text = article.publishedAt.toString(format: "d MMMM")
        articleHeaderLabel.text = article.title
        articleContentLabel.text = article.description
        
        // TODO: Check likes from CoreData
    }
    
    @objc func heartImageTouched() {
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        heartButton.tintColor = Colors.News.likeColor
    }
}
