//
//  UsersController.swift
//  App
//
//  Created by Stephen Bodnar on 6/28/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

extension UserController: RouteCollection {
    func boot(router: Router) throws {
        router.post("register", use: handleRegisterUser)
        router.get("register", use: showRegisterPage)
        
        router.post("login", use: handleUserLogin)
        router.get("login", use: showLoginPage)
        
        router.get("me", use: getMyProfile)
    }
}

final class UserController {
    
    func getMyProfile(_ request: Request) throws -> Future<View> {
        return try request.view().render("me")
    }
    
    func showRegisterPage(_ request: Request) throws -> Future<View> {
        return try request.view().render("register")
    }
    
    func showLoginPage(_ request: Request) throws -> Future<View> {
        return try request.view().render("login")
    }
    
    func handleRegisterUser(_ request: Request) throws -> Future<User> {
        return try User.signup(with: request)
    }
    
    func handleUserLogin(_ request: Request) throws -> Future<User> {
        return try User.login(with: request)
    }
}
