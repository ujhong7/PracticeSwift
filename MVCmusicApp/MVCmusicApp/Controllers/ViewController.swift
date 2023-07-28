//
//  ViewController.swift
//  MVCmusicApp
//
//  Created by yujaehong on 2023/07/28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    let apiManager = APIService()
    
    var music: Music? {
        didSet {
            DispatchQueue.main.async {
                self.configureUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configureUI() {
        self.albumNameLabel.text = self.music?.albumName
        self.songNameLabel.text = self.music?.songName
        self.artistNameLabel.text = self.music?.artistName
    }
    
    
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        apiManager.fetchMusic { [weak self] result in
            switch result {
            case .success(let music):
                self?.music = music
            case .failure(let error):
                switch error {
                case .dataError:
                    print("데이터 에러")
                case .networkingError:
                    print("네트워킹 에러")
                case .parseError:
                    print("파싱 에러")
                }
            }
        }
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        guard let music = self.music else { return }
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        detailVC.modalPresentationStyle = .fullScreen
        
        detailVC.apiManager = self.apiManager
        
        detailVC.songName = music.songName
        detailVC.imageURL = music.imageUrl
        
        self.present(detailVC, animated: true)
    }
    
}

