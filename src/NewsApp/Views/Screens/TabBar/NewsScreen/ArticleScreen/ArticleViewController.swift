
import UIKit
import SnapKit

final class ArticleViewController : UIViewController {
    
    private let article: Article
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var image: UIImageView = {
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
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        //button.addTarget(self, action: #selector(heartImageTouched), for: .touchUpInside)
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
    
    init(article: Article) {
        self.article = article
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
    }
    
    private func setupUI() {
        
        view.backgroundColor = Colors.News.background
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.left.top.equalTo(image.superview!).inset(8)
            make.width.equalTo(view.frame.width - 8*2)
            make.height.equalTo(260)
        }
    
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(dateLabel.superview!).inset(16)
            make.top.equalTo(image.snp.bottom).offset(16)
        }
        
        contentView.addSubview(articleHeaderLabel)
        articleHeaderLabel.snp.makeConstraints { make in
            make.left.equalTo(articleHeaderLabel.superview!).inset(16)
            make.width.equalTo(view.frame.width - 8*2)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
        }
        
        contentView.addSubview(articleContentLabel)
        articleContentLabel.snp.makeConstraints { make in
            make.left.equalTo(articleContentLabel.superview!).inset(16)
            make.width.equalTo(view.frame.width - 8*2)
            make.top.equalTo(articleHeaderLabel.snp.bottom).offset(16)
        }
    }
    
    private func displayModel() {
       
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
        
        title = "Статья"
    }
}
