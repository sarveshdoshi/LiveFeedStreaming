//
//  LiveFeedsTVC.swift
//  LiveFeedStreaming
//
//  Created by Sarvesh Doshi on 17/12/24.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class LiveFeedsTVC: UITableViewCell {

    @IBOutlet weak var playerBGView: UIView!
    @IBOutlet weak var overlayView: UIView!
    
    
    let avPlayerController = AVPlayerViewController()
    var data: Video?
    var currentPlayedContentIndex = 0
    
    
    deinit {
        print("Deinit called.")
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playAudioBackground()
        addObservers()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func passData(data: Video?) {
        self.data = data
    }
    
    func playVideoWithURL(urlStr: String, index: Int) {
        self.currentPlayedContentIndex = index
        
        if let url = URL(string: urlStr) {
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            avPlayerController.player?.actionAtItemEnd = .none
            avPlayerController.player = AVPlayer(playerItem: playerItem)
            avPlayerController.showsPlaybackControls = false
            
            self.overlayView.addSubview(avPlayerController.view)
            self.setVideoPlayerlayout()
            
            avPlayerController.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            overlayView.sendSubviewToBack(avPlayerController.view)
            avPlayerController.player?.play()
            avPlayerController.player?.volume = 1.0
            if #available(iOS 16.0, *) {
                avPlayerController.allowsVideoFrameAnalysis = false
            }
            
        } else {
            print("video url nil...")
        }
        
    }
    
    func setVideoPlayerlayout() {
        avPlayerController.view.translatesAutoresizingMaskIntoConstraints = false
        avPlayerController.view.topAnchor.constraint(equalTo: playerBGView.topAnchor, constant: 0).isActive = true
        avPlayerController.view.leadingAnchor.constraint(equalTo: playerBGView.leadingAnchor, constant: 0).isActive = true
        avPlayerController.view.trailingAnchor.constraint(equalTo: playerBGView.trailingAnchor, constant: 0).isActive = true
        avPlayerController.view.bottomAnchor.constraint(equalTo: playerBGView.bottomAnchor, constant: 0).isActive = true
    }
}

extension LiveFeedsTVC {
    private func playAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting the AVAudioSession:", error.localizedDescription)
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.avPlayerController.player?.currentItem)
    }
    
    @objc func didEnterBackground() {
       
        avPlayerController.player?.pause()
    }
    
    @objc func willEnterForeground() {
       
        avPlayerController.player?.play()
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.currentStoryPlay()
    }
    
    private func currentStoryPlay() {
        if let player = avPlayerController.player, let currentItem = player.currentItem {
            avPlayerController.player?.pause()
            avPlayerController.player?.seek(to: .zero)
            avPlayerController.player?.replaceCurrentItem(with: currentItem)
            avPlayerController.player?.play()
        }
    }
    
    func pauseCurrentContent() {
        pausePlayer()
    }
    
    private func pausePlayer() {
        self.avPlayerController.player?.pause()
    }
    
    func releasePlayer() {
        self.avPlayerController.player?.pause()
        avPlayerController.player = nil
        avPlayerController.removeFromParent()
    }
}
