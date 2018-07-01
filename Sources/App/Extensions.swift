//
//  Extensions.swift
//  App
//
//  Created by Stephen Bodnar on 7/1/18.
//

import Foundation
import Vapor

extension Request {
    func sessionUser() throws -> Future<User> {
        if let userId = try self.session()["userId"], let idAsInt = Int(userId)   {
            return User.find(idAsInt, on: self).unwrap(or: Abort.init(HTTPResponseStatus.notFound))
        }
        throw Abort.init(HTTPResponseStatus.unauthorized)
    }
}
