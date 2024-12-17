//
//  LiveFeedsModel.swift
//  LiveFeedStreaming
//
//  Created by Sarvesh Doshi on 18/12/24.
//

import Foundation

struct LiveFeedsModel: Codable {
    var videos: [Video]?
}

// MARK: - Video
struct Video: Codable {
    var id, userID: Int?
    var username: String?
    var profilePicURL: String?
    var description, topic: String?
    var viewers, likes: Int?
    var video: String?
    var thumbnail: String?
}
