//
//  PostController.swift
//  App
//
//  Created by Stephen Bodnar on 6/30/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

extension PostController: RouteCollection {
    func boot(router: Router) throws {
        // let protectedRoutes = router.grouped(User.authSessionsMiddleware())
        router.post("createPost", use: createPost)
        router.get("createPost", use: showCreatePostPage)
        router.get("allPosts", use: viewAllPosts)
    }
}

final class PostController {
    
    func viewAllPosts(_ request: Request) throws -> Future<View> {
        return Post.query(on: request).all().flatMap(to: View.self) { posts in
            let allPostsContext = AllPostsContext(posts: posts)
            return try request.view().render("allPosts", allPostsContext)
        }
    }
    
    func createPost(_ request: Request) throws -> Future<Post> {
        return try request.content.decode(Post.self).flatMap(to: Post.self) { post in
           return post.save(on: request)
        }
    }
    
    func showCreatePostPage(_ request: Request) throws -> Future<View> {
        return try request.view().render("createPost")
    }
}
