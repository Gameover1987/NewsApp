
import Foundation
import CoreData

final class CoreDataNewsAppStorage : NewsAppStorageProtocol {
    
    static let shared = CoreDataNewsAppStorage()
    
    private var observers: [NewsAppStorageObserver] = []
    
    private init() {
        fetchArticles()
        fetchUsers()
        
        #if DEBUG
        addUser(userName: "TestUser", email: "test@mail.com", password: "12345")
        #endif
    }
    
    var articles: [ArticleEntity] = []
    var users: [UserEntity] = []
    
    func isArticleInFavorites(title: String) -> Bool {
        let articleEntity = getByTitle(title: title)
        return articleEntity != nil
    }
    
    func isEmailRegistered(_ email: String) -> Bool {
        let userEntity = getByEmail(email: email)
        return userEntity != nil
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
    
    func addUser(userName: String, email: String, password: String) -> UserEntity {
        let user = getOrCreateUser(userName: userName,
                                   email: email,
                                   password: password,
                                   in: persistentContainer.viewContext)
        
        saveContext()
        fetchUsers()
        
        return user
    }
    
    func getUserByEmailAndPassword(email: String, password: String) -> UserEntity? {
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        guard let userEntity = (try? persistentContainer.viewContext.fetch(request))?.first else {return nil}
        
        if userEntity.password != password {
            return nil
        }
        
        return userEntity
    }
    
    private func getByTitle(title: String) -> ArticleEntity? {
        let request = ArticleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        let articleEntity = (try? persistentContainer.viewContext.fetch(request))?.first
        return articleEntity
    }
    
    private func getByEmail(email: String) -> UserEntity? {
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        
        let userEntity = (try? persistentContainer.viewContext.fetch(request))?.first
        return userEntity
    }
    
    private func fetchArticles() {
        let request = ArticleEntity.fetchRequest()
        do {
            request.sortDescriptors = [
            NSSortDescriptor(key: "addedAt", ascending: false)
            ]
            articles = try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func fetchUsers() {
        let request = UserEntity.fetchRequest()
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "email", ascending: true)]
            users = try persistentContainer.viewContext.fetch(request)
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
            articleEntity.addedAt = Date()
            
            return articleEntity
        }
    }
    
    private func getOrCreateUser(userName: String, email: String, password: String, in context: NSManagedObjectContext) -> UserEntity {
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        
        if let userEntity = (try? context.fetch(request))?.first {
            return userEntity
        }
        else {
            let userEntity = UserEntity(context: context)
            userEntity.userName = userName
            userEntity.email = email
            userEntity.password = password
            
            return userEntity
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
