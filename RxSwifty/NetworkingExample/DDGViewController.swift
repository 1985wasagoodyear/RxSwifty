//
//  DDGViewController.swift
//  RxSwifty
//
//  Created by Kevin Yu on 1/21/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import RxSwift
import RxCocoa

extension UIImage {
    static let empty: UIImage = UIImage(named: "pants")!
}

private let reuseIdentifier = "cell"

final class DDGViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: reuseIdentifier)
        }
    }
    
    // MARK: - Properties
    
    private var viewModel = ArrayViewModel<DDGEntry>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Downloading Providers
    
    let session = URLSession(configuration: .default)
    
    private lazy var apiClient: APIClient<DDGResponse> = {
        return APIClient<DDGResponse>(self.session)
    }()
    
    lazy var imProvider = {
        return ImageProvider(self.session)
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFromAPI()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        
        viewModel
            .items
            .asObservable()
            .bind(to: tableView.rx.items) { (tableView, row, element) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
                let text = element.text
                    .components(separatedBy: " - ")
                    .joined(separator: "\n\n")
                cell.textLabel?.text = text
                cell.textLabel?.numberOfLines = 0
                cell.setNeedsLayout()
            
                self.imProvider.getImage(element.icon.url,
                                         completion:
                    { (data) in
                        var image: UIImage? = .empty
                        if let data = data {
                            image = UIImage(data: data)
                        }
                        let size = CGSize(width: 100,
                                          height: 100)
                        image = image?.resized(for: size)
                        cell.imageView?.image = image
                        cell.setNeedsLayout()
                })
                
                return cell
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Load Data
    
    private func loadFromAPI() {
        let request = URL(string: "https://api.duckduckgo.com/?q=simpsons+characters&format=json")!
        apiClient
            .makeRequest(request)
            .subscribe(
                onNext: { [weak self] response in
                    self?.viewModel.appendVals(response.entries)
                })
            .disposed(by: disposeBag)
    }

}

extension DDGViewController {
    static func newVC() -> DDGViewController {
        return UIStoryboard.rxSwifty.instantiateViewController(withIdentifier: "DDGViewController") as! DDGViewController
    }
}
