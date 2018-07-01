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
        let authedRoutes = router.grouped(SessionAuthenticationMiddleware())
        authedRoutes.post("createPost", use: createPost)
        authedRoutes.get("createPost", use: showCreatePostPage)
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
        return try request.content.decode(CreatePostRequest.self).flatMap(to: Post.self) { createRequest in
            return try request.sessionUser().flatMap(to: Post.self) { user in
                let post = try Post(title: createRequest.title, userId: user.requireID())
                return post.save(on: request)
            }
        }
    }
    
    func showCreatePostPage(_ request: Request) throws -> Future<View> {
        return try request.view().render("createPost")
    }
}
