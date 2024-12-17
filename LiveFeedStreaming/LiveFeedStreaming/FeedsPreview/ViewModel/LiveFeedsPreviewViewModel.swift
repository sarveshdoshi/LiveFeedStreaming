//
//  LiveFeedsPreviewViewModel.swift
//  LiveFeedStreaming
//
//  Created by Sarvesh Doshi on 18/12/24.
//

import Foundation

class LiveFeedsPreviewViewModel: NSObject {
    
    var feedData: LiveFeedsModel?
    
    override init() {
        super.init()
        fetchAndSaveJsonData()
    }
    
    private func fetchAndSaveJsonData() {
        // Ensure safe handling of nil
        feedData = JSONHelper.loadJSON(filename: "LiveFeeds", model: LiveFeedsModel.self)
        print("Feeds Loaded: \(feedData?.videos?.count ?? 0) items")
    }
}
