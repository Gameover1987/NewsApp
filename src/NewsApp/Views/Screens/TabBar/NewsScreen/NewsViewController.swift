
import UIKit
import SnapKit

final class NewsViewController : UIViewController {
    
    private let newsViewModel: NewsViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.News.background
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    init(newsViewModel: NewsViewModel) {
        self.newsViewModel = newsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Colors.News.background
        
        self.title = Strings.News.title
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        updateVisibleCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        newsViewModel.articleRemovedFromFavoritesAction = { [weak self] indexPath in
            guard let self = self else {return}
            guard let cell = self.tableView.cellForRow(at: indexPath) as? ArticleTableViewCell else {return}
            let article = self.newsViewModel.articles[indexPath.row]
            cell.update(by: article)
        }
        newsViewModel.load { [weak self] result in
            guard let self = self else {return}
            
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .failure(let error):
                self.showErrorMessage(title: "Ошибка", message: error.localizedDescription, actionHandler: nil)
            case .success(_):
                self.tableView.reloadData()
            }
        }

        tableView.reloadData()
    }
    
    private func updateVisibleCells() {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {return}
        
        let article = newsViewModel.articles[selectedIndexPath.row]
        let cell = tableView.cellForRow(at: selectedIndexPath) as? ArticleTableViewCell
        cell?.update(by: article)
    }
}

extension NewsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = newsViewModel.articles[indexPath.row]
        self.navigationController?.pushViewController(ArticleViewController(article: selectedArticle, storage: CoreDataNewsAppStorage.shared), animated: true)
    }
}

extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        cell.selectionStyle = .none
        
        let article = newsViewModel.articles[indexPath.row]
        cell.update(by: article)
        
        return cell
    }
}
