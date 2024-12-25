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
import SDWebImage

class LiveFeedsTVC: UITableViewCell {

    @IBOutlet weak var playerBGView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var topicView: UIView!
    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var popularView: UIView!
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var usersView: UIView!
    @IBOutlet weak var usersCountLabel: UILabel!
    @IBOutlet weak var exploreView: UIView!
    @IBOutlet weak var roseGiftView: UIView!
    @IBOutlet weak var currentGiftCountLabel: UILabel!
    @IBOutlet weak var totalGiftCountLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
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
        setupUI()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func dropDownTapped(_ sender: Any) {
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
    }
    
    func setupUI() {
        topLeftView.layer.opacity = 1
        topLeftView.layer.cornerRadius = 8
        followBtn.layer.cornerRadius = 8
        profileImageView.layer.cornerRadius = 6
        topicView.layer.cornerRadius = 8
        popularView.layer.cornerRadius = 8
        usersView.layer.cornerRadius = 8
        roseGiftView.layer.cornerRadius = 8
        timeView.layer.cornerRadius = timeView.frame.height / 2
        exploreView.layer.cornerRadius = exploreView.frame.height / 2
        profileNameLabel.font = .customFont(type: .medium, size: 10)
        likesCountLabel.font = .customFont(type: .medium, size: 10)
        profileNameLabel.textColor = .init(hex: "#DADADA")
        likesCountLabel.textColor = .init(hex: "#DADADA")
        followBtn.titleLabel?.font = .customFont(type: .medium, size: 12)
        followBtn.setTitleColor(.white, for: .normal)
        topicLabel.font = .customFont(type: .regular, size: 10)
        popularLabel.font = .customFont(type: .regular, size: 10)
        
    }
    
    func passData(data: Video?) {
        self.data = data
        self.profileNameLabel.text = data?.username ?? ""
        self.likesCountLabel.text = data?.likes?.description ?? ""
        self.profileImageView.sd_setImage(with: URL(string: data?.profilePicURL ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        self.topicLabel.text = data?.topic?.capitalized ?? ""
        self.usersCountLabel.text = "\(data?.viewers ?? 0)"
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
