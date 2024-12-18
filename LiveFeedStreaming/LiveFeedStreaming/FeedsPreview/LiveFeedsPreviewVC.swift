//
//  LiveFeedsPreviewVC.swift
//  LiveFeedStreaming
//
//  Created by Sarvesh Doshi on 17/12/24.
//

import UIKit

class LiveFeedsPreviewVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let viewModel = LiveFeedsPreviewViewModel()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LiveFeedsTVC", bundle: .main), forCellReuseIdentifier: "LiveFeedsTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isPagingEnabled = true
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsContentViewsToSafeArea = false
    }

}

extension LiveFeedsPreviewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.feedData?.videos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.feedData?.videos?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveFeedsTVC") as! LiveFeedsTVC
        cell.passData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? LiveFeedsTVC {
            let data = viewModel.feedData?.videos?[indexPath.row]
            if let urlStr = data?.video {
                cell.playVideoWithURL(urlStr: urlStr, index: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? LiveFeedsTVC {
            cell.pauseCurrentContent()
            cell.releasePlayer()
        }
    }
    
    
}
