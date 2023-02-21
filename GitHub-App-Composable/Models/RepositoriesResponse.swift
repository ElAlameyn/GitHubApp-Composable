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
//  let nodeId: String?
  let name: String
//  let fullName: String?
////  let owner: Owner?
//  let itemPrivate: Bool?
//  let htmlUrl: String?
//  let description: String?
//  let fork: Bool?
//  let url: String?
//  let createdAt, updatedAt, pushedAt: Date?
//  let homepage: String
    let size, stargazersCount, watchersCount: Int
//  let language: String
//  let forksCount, openIssuesCount: Int
//  let masterBranch, defaultBranch: String
//  let score: Int
//  let archiveUrl, assigneesUrl, blobsUrl, branchesUrl: String
//  let collaboratorsUrl, commentsUrl, commitsUrl, compareUrl: String
//  let contentsUrl: String
//  let contributorsUrl, deploymentsUrl, downloadsUrl, eventsUrl: String
//  let forksUrl: String
//  let gitCommitsUrl, gitRefsUrl, gitTagsUrl, gitUrl: String
//  let issueCommentUrl, issueEventsUrl, issuesUrl, keysUrl: String
//  let labelsUrl: String
//  let languagesUrl, mergesUrl: String
//  let milestonesUrl, notificationsUrl, pullsUrl, releasesUrl: String
//  let sshUrl: String
//  let stargazersUrl: String
//  let statusesUrl: String
//  let subscribersUrl, subscriptionUrl, tagsUrl, teamsUrl: String
//  let treesUrl: String
//  let cloneUrl: String
//  let mirrorUrl: String
//  let hooksUrl, svnUrl: String
//  let forks, openIssues, watchers: Int
//  let hasIssues, hasProjects, hasPages, hasWiki: Bool
//  let hasDownloads, archived, disabled: Bool
//  let visibility: String
//  let license: License
}

// MARK: - License
struct License: Codable, Equatable {
  let key, name: String
  let url: String
  let spdxId, nodeId: String
  let htmlUrl: String
}

// MARK: - Owner
struct Owner: Codable, Equatable {
  let login: String
  let id: Int
  let nodeId: String
  let avatarUrl: String
  let gravatarId: String
  let url, receivedEventsUrl: String
  let type: String
  let htmlUrl, followersUrl: String
  let followingUrl, gistsUrl, starredUrl: String
  let subscriptionsUrl, organizationsUrl, reposUrl: String
  let eventsUrl: String
  let siteAdmin: Bool
}
