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

    }

}
