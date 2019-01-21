//
//  InfoViewController.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-12.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit
import SafariServices
import GhostTypewriter

class InfoViewController: UIViewController {
    
    let resumeURL = "https://drive.google.com/file/d/1pJy2Hhv_AsLJx2rJJQ_OsKXhIdYVzqfa/view?usp=sharing"
    let linkedInURL = "https://www.linkedin.com/in/nafehshoaib"
    let gitHubURL = "https://www.github.com/nafehshoaib"
    
    @IBOutlet weak var nameLabel: TypewriterLabel!
    
    @IBAction func didPressReumeButton(_ sender: UIButton) {
        self.presentInSafari(urlString: resumeURL)
    }
    
    @IBAction func didPressLinkedInButton(_ sender: UIButton) {
        self.presentInSafari(urlString: linkedInURL)
    }
    
    @IBAction func didPressGitHubButton(_ sender: UIButton) {
        self.presentInSafari(urlString: gitHubURL)
    }
    
    @IBAction func didPressCloseButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.typingTimeInterval = 0.2
        nameLabel.startTypewritingAnimation()
    }
    
    private func presentInSafari(urlString: String) {
        let safariViewController = SFSafariViewController(urlString: urlString)
        present(safariViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SFSafariViewController {
    convenience init(urlString: String) {
        self.init(url: URL(string: urlString)!)
        self.preferredBarTintColor = UIColor(named: "ShopifyPurple")
    }
}
