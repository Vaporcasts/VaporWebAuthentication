import Foundation 
import Vapor 
import FluentPostgreSQL

final class Post: PostgreSQLModel {
    var id:Int?
    var title:String
    var userId: User.ID

    init(title: String, userId: User.ID)  {
        self.title = title
        self.userId = userId
    }
}

extension Post: Content, Migration { }
