import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    let userController = UserController()
    let postController = PostController()
    
    try router.register(collection: userController)
    try router.register(collection: postController)

}
