import Foundation 
import Vapor 
import FluentPostgreSQL
import Authentication

final class User: PostgreSQLModel {
    var id:Int?
    var name:String 
    var password:String 

    init(name: String,  password: String)  { 
        self.name = name 
        self.password = password 
    }
    
    static func signup(with request: Request) throws -> Future<User> {
        return try request.content.decode(User.self).flatMap(to: User.self) { user in
            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
            let newUser = User(name: user.name, password: passwordHashed)
            return newUser.save(on: request)
        }
    }
    
    static func login(with request: Request) throws -> Future<Response> {
        return try request.content.decode(User.self).flatMap(to: Response.self) { user in
            let verifier = try request.make(BCryptDigest.self)
            return User.authenticate(username: user.name, password: user.password, using: verifier, on: request).unwrap(or: Abort(HTTPResponseStatus.unauthorized)).map(to: Response.self, { authedUser  in
                try request.session()["userId"] =  "\(try authedUser.requireID())"
                return request.redirect(to: "/me")
            })
        }
    }
}

extension User: PasswordAuthenticatable {
    static var passwordKey: WritableKeyPath<User, String> {
        return \User.password
    }
    static var usernameKey: WritableKeyPath<User, String> {
        return \User.name
    }
}

extension User: SessionAuthenticatable { }
extension User: Content, Migration { }

