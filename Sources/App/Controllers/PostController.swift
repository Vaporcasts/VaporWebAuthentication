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
        router.post("createPost", use: createPost)
        router.get("createPost", use: showCreatePostPage)
        router.get("allPosts", use: viewAllPosts)
    }
}

final class PostController {
    
    func viewAllPosts(_ request: Request) throws -> Future<View> {
        print(try request.session().id)
        return Post.query(on: request).all().flatMap(to: View.self) { posts in
            let allPostsContext = AllPostsContext(posts: posts)
            return try request.view().render("allPosts", allPostsContext)
        }
    }
    
    func createPost(_ request: Request) throws -> Future<Post> {
        return try request.content.decode(CreatePostRequest.self).flatMap(to: Post.self) { createRequest in
            // We need to un-hardcode this userId
            // we will get the userId from the session cookie
            let post = Post(title: createRequest.title, userId: 1)
            return post.save(on: request)
        }
    }
    
    func showCreatePostPage(_ request: Request) throws -> Future<View> {
        return try request.view().render("createPost")
    }
}
