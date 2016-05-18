//
//  User.swift
//  SportXast
//
//  Created by Pralea Danut on 27/01/16.
//  Copyright © 2016 SportXast. All rights reserved.
//

import Foundation
import ObjectMapper



// This is used to map the response from several requests, like signup, saving user info
struct ResponseRecoverPassword: Mappable {
    var message: String?
    var success: Bool?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        message    <- map["message"]
        success    <- map["success"]
    }
    
    static func parseJSON(json: AnyObject) throws -> ResponseRecoverPassword {
        
        guard let result = Mapper<ResponseRecoverPassword>().map(json) else {
            throw NetworkError.InvalidDataForParsing
        }
        
        if let success = result.success, let message = result.message where success == false {
            throw NetworkError.Custom(message: message)
        }
        
        return result
    }
}

// This is used to map the response from several requests, like signup, saving user info
struct ResponseUser: Mappable {
    var info: User?
    var user: User?
    var message: String?
    var success: Bool?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        info    <- map["info"]
        message    <- map["message"]
        success    <- map["success"]
        user    <- map["user"]
    }
    
    static func parseJSON(json: AnyObject) throws -> ResponseUser {
        
        guard let result = Mapper<ResponseUser>().map(json) else {
            throw NetworkError.InvalidDataForParsing
        }
        
        if let success = result.success, let message = result.message where success == false {
            throw NetworkError.Custom(message: message)
        }
        
        return result
    }
}

struct AuthResponse: Mappable {
    var message: String?
    var success: Bool?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        message    <- map["message"]
        success    <- map["success"]
    }
}

struct ResponseUserCheck: Mappable {
    var isAvailable: Bool?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        isAvailable    <- map["isAvailable"]
    }
}

struct FollowingResponseUser: Mappable {
    var currentPage: Int?
    var resultCount: Int?
    var pageCount: Int?
    var following: [User]?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        currentPage     <- map["info"]
        resultCount     <- map["list"]
        pageCount       <- map["resultCount"]
        following       <- map["following"]
    }
}

struct FollowersResponseUser: Mappable {
    var currentPage: Int?
    var resultCount: Int?
    var pageCount: Int?
    var followers: [User]?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        currentPage     <- map["info"]
        resultCount     <- map["list"]
        pageCount       <- map["resultCount"]
        followers       <- map["followers"]
    }
}

struct FollowResponse: Mappable {
    var success: Bool?
    var message: String?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        success     <- map["success"]
        message     <- map["message"]
    }
}

struct SocialLoginResponse: Mappable {
    var success: Bool?
    var message: String?
    var error: Bool?
    var user: User?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        success     <- map["success"]
        message     <- map["message"]
        user     <- map["user"]
        error     <- map["error"]
    }
    
    
    static func parseJSON(json: AnyObject) throws -> SocialLoginResponse {
        
        guard let result = Mapper<SocialLoginResponse>().map(json) else {
            throw NetworkError.InvalidDataForParsing
        }
        
        if let success = result.success, let message = result.message where success == false {
            throw NetworkError.Custom(message: message)
        }
        
        return result
    }
}

struct SocialSignupResponse: Mappable {
    var success: Bool?
    var avatar: String?
    var originalAvatar: String?
    var user: User?
    var message: String?
    var error: Bool?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        success     <- map["success"]
        avatar     <- map["avatar"]
        user     <- map["user"]
        originalAvatar     <- map["avatar_original"]
        message     <- map["message"]
        error     <- map["error"]
    }
    
    static func parseJSON(json: AnyObject) throws -> SocialSignupResponse {
        
        guard let result = Mapper<SocialSignupResponse>().map(json) else {
            throw NetworkError.InvalidDataForParsing
        }
        
        if let success = result.success, let message = result.message where success == false {
            throw NetworkError.Custom(message: message)
        }
        
        return result
    }
}

struct FollowUserCounts {
    var follower: String?
    var following: String?
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        follower    <- map["followerCount"]
        following    <- map["followingCount"]
    }
}


struct User: Mappable {
    var identifier: String?
    var avatarPath: String?
    var avatarUrl: String?
    var hasAvatar: Bool?
    var avatarCount: Int?
    var avatarName: String?
    var fullName: String?
    var firstName: String?
    var lastName: String?
    var displayName: String?
    var username: String?
    var email: String?
    var aboutMe: String?
    var address: String?
    var postCount: Int?
    var favoriteCount: Int?
    var viewCount: Int?
    var isFollowing: Bool?
    var followCounts: FollowUserCounts?
    var isPlayer: Bool?
    var country: String?
    var userRole: String?
    var city : String?
    var state : String?
    
    
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        identifier    <- map["userId"]
        avatarPath    <- map["avatarPath"]
        avatarUrl    <- map["avatarUrl"]
        hasAvatar    <- map["hasAvatar"]
        avatarCount    <- map["avatarCount"]
        avatarName    <- map["avatarName"]
        fullName    <- map["fullName"]
        firstName    <- map["firstName"]
        lastName    <- map["lastName"]
        displayName    <- map["displayName"]
        username    <- map["userName"]
        email    <- map["email"]
        aboutMe    <- map["aboutMe"]
        address    <- map["address"]
        postCount    <- map["postCount"]
        favoriteCount    <- map["favoriteCount"]
        viewCount    <- map["viewCount"]
        isFollowing    <- map["isFollowing"]
        followCounts    <- map["followCounts"]
        isPlayer    <- map["isPlayer"]
        country    <- map["country"]
        city    <- map["city"]
        state    <- map["state"]
        userRole    <- map["userRole"]
    }
    
}
