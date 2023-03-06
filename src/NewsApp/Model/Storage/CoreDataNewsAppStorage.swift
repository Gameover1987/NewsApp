
import Foundation
import CoreData

final class CoreDataNewsAppStorage : NewsAppStorageProtocol {
        
    static let shared = CoreDataNewsAppStorage()
    
    private var observers: [NewsAppStorageObserver] = []
    
    private init() {
        fetchArticles()
    }
    
    var articles: [ArticleEntity] = []
    
    func isArticleInFavorites(title: String) -> Bool {
        let articleEntity = getByTitle(title: title)
        
        return articleEntity != nil
    }
    
    func addToFavorites(title: String, contents: String, publishedAt: Date, urlToImage: String?) {
        let article = getOrCreateArticle(title: title,
                                          contents: contents,
                                          publishedAt: publishedAt,
                                          urlToImage: urlToImage,
                                          in: persistentContainer.viewContext)
        
        saveContext()
        fetchArticles()
        
        for observer in observers {
            observer.didAddToFavorites(article: article)
        }
    }
    
    func removeFromFavorites(title: String) {
        guard let articleEntity = getByTitle(title: title) else {return}
        let title = articleEntity.title
        
        persistentContainer.viewContext.delete(articleEntity)
        saveContext()
        fetchArticles()
        
        for observer in observers {
            observer.didRemoveFromFavorites(title: title!)
        }
    }
    
    func addObserver(_ observer: NewsAppStorageObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: NewsAppStorageObserver) {
        observers.removeAll { existingObserver in
            return existingObserver === observer
        }
    }
    
    private func getByTitle(title: String) -> ArticleEntity? {
        let request = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        let articleEntity = (try? persistentContainer.viewContext.fetch(request))?.first
        return articleEntity
    }
    
    private func fetchArticles() {
        let request = ArticleEntity.fetchRequest()
        do {
            request.sortDescriptors = [
            NSSortDescriptor(key: "publishedAt", ascending: false),
            NSSortDescriptor(key: "title", ascending: true)
            ]
            articles = try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func getOrCreateArticle(title: String, contents: String, publishedAt: Date, urlToImage: String?, in context: NSManagedObjectContext) -> ArticleEntity {
        let request = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        if let articleEntity = (try? context.fetch(request))?.first {
            return articleEntity
        }
        else {
            let articleEntity = ArticleEntity(context: context)
            articleEntity.title = title
            articleEntity.contents = contents
            articleEntity.publishedAt = publishedAt
            articleEntity.urlToImage = urlToImage
            
            return articleEntity
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
