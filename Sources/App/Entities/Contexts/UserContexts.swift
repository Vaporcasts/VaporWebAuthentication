//
//  UserContexts.swift
//  App
//
//  Created by Stephen Bodnar on 6/30/18.
//

import Foundation
import Vapor

struct UserProfilePage: Encodable {
    var user: Future<User>
}
