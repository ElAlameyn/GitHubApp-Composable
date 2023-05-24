//
//  RepositoriesResponse.swift
//  GitHub-App-Composable
//
//  Created by Артем Калинкин on 16.02.2023.
//

import Foundation

// MARK: - RepositoriesResponse

struct RepositoriesResponse: Codable, Equatable {
  let totalCount: Int?
  let incompleteResults: Bool?
  let items: [GithubRepository]
}

// MARK: - Repository

struct GithubRepository: Codable, Equatable {
  let id: Int
  let name: String
  let size, stargazersCount, watchersCount: Int?
}

// MARK: - License

struct License: Codable {
  let htmlUrl: String?
  let key, name, nodeId: String
  let spdxId, url: String?
}

// MARK: - Owner

struct Owner: Codable {
  let avatarUrl, eventsUrl, followersUrl, followingUrl: String?
  let gistsUrl, gravatarId, htmlUrl: String?
  let id: Int?
  let login, nodeId, organizationsUrl, receivedEventsUrl: String?
  let reposUrl: String?
  let siteAdmin: Bool?
  let starredUrl, subscriptionsUrl, type, url: String?
}
