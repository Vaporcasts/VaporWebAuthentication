//
//  SessionAuthenticationMiddleware.swift
//  App
//
//  Created by Stephen Bodnar on 7/1/18.
//

import Foundation
import Vapor

final class SessionAuthenticationMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        let session = try request.session()
        if let _ = session["userId"] { return try next.respond(to: request) }
        else { throw Abort(HTTPResponseStatus.unauthorized) }
    }
}
