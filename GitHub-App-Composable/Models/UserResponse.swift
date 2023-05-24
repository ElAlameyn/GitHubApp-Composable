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
  let url, htmlUrl: String
  let followersUrl, starredUrl: String?
  let subscriptionsUrl, organizationsUrl, reposUrl: String?
  let location, email: String?
}

// MARK: - Plan
struct Plan: Codable {
  let name: String
  let space, privateRepos, collaborators: Int
}
