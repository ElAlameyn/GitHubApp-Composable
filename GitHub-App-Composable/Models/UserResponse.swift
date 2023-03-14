//
//  UserResponse.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 14.03.2023.
//

import Foundation

// MARK: - UserResponse
struct UserResponse: Codable {
  let login: String
  let id: Int
  let nodeId: String?
  let avatarUrl: String?
//  let gravatarID: String
  let url, htmlUrl: String
  let followersUrl, starredUrl: String?
//  let followingURL, gistsURL, starredURL: String
  let subscriptionsUrl, organizationsUrl, reposUrl: String?
//  let eventsURL: String
//  let receivedEventsURL: String
//  let type: String
//  let siteAdmin: Bool
//  let name, company: String?
//  let blog: String?
  let location, email: String?
//  let hireable: Bool
//  let bio, twitterUsername: String
//  let publicRepos, publicGists, followers, following: Int
//  let createdAt, updatedAt: Date
//  let privateGists, totalPrivateRepos, ownedPrivateRepos, diskUsage: Int
//  let collaborators: Int
//  let twoFactorAuthentication: Bool
//  let plan: Plan?
}

// MARK: - Plan
struct Plan: Codable {
  let name: String
  let space, privateRepos, collaborators: Int
}
