//
//  GBViewController.swift
//  RxSwifty
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GBViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: "Cell")
        }
    }
    
    // MARK: - Networking Components
    
    let session = URLSession(configuration: .default)
    
    lazy var apiClient: APIClient<GBResponse> = {
        return APIClient<GBResponse>(self.session)
    }()
    
    // MARK: - Other Properties
    
    let disposeBag = DisposeBag()
    var searchResults: Observable<GBResponse>!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    func setup() {
        // 1. create an observer on the searchBar
        // it will get search query
        // build an observable for networking (comes from apiClient's makeRequest)
        searchResults = searchBar
            .rx
            .text
            .orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<GBResponse> in
                guard !query.isEmpty,
                    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)") else {
                        return .empty()
                }
                return self.apiClient.makeRequest(url)
        }
        .observeOn(MainScheduler.instance)
        
        // 2. as the results from the networking observer are fed back
        // A. flatMap only the array of internal items
        //          transforms the type of Observable
        // B. put those on the tableView
        // C. dispose of this later.
        searchResults
            .flatMap({ (response) -> Observable<[GBEntry]> in
                return BehaviorRelay(value: response.items).asObservable()
            })
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) {
                (index, entry: GBEntry, cell) in
                cell.textLabel?.text = entry.volumeInfo.title
        }
        .disposed(by: disposeBag)
    }

}

extension GBViewController {
    static func newVC() -> GBViewController {
        return GBViewController(nibName: "GBViewController", bundle: nil)
    }
}
