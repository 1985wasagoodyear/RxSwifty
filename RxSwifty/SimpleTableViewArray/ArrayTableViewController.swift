//
//  ArrayTableViewController.swift
//  RxSwifty
//
//  Created by Kevin Yu on 1/21/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "cell"

final class ArrayTableViewController: UIViewController {
    
    // MARK: - Storyboard IBOutlets
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: reuseIdentifier)
        }
    }
    @IBOutlet var addButton: UIButton!
    @IBOutlet var addStepper: UIStepper! {
        didSet {
            addStepper.value = 0.0
            addStepper.minimumValue = 0.0
            addStepper.maximumValue = 100.0
        }
    }
    @IBOutlet var addLabel: UILabel! {
        didSet {
            addLabel.text = "0"
            addLabel.tag = 0
        }
    }
    
    var disposeBag = DisposeBag() // kinda important.
    
    // MARK: - Properties
    
    var viewModel = ArrayViewModel<String>()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    // MARK: - Setup Methods
    
    func setupBindings() {
        // 1. create binding for cellForRowAtIndex
        viewModel
            .items
            .asObservable()
            .bind(to: tableView.rx.items) { (tableView, row, element) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        // 2. create binding for didSelectRowAt
        // removes an item tapped on
        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                self?.showRemoveAlert(for: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        // 3. have some UI influence the appearance of some other UI
        // the stepper here changes the label.
        addStepper
            .rx
            .value
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.addLabel.tag = Int(value)
                self.addLabel.text = String(value)
            })
            .disposed(by: disposeBag)
        
        // 4. have button add items
        addButton
            .rx.tap.subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let text = self.addLabel.text else { return }
                self.viewModel.append(text)
            }).disposed(by: disposeBag)
    }
}

extension ArrayTableViewController {
    func showRemoveAlert(for index: Int) {
        let alert = UIAlertController(title: "Remove the item at index \(index)?",
            message: "\(viewModel.items[index]) @ row \(index)",
            preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Remove",
                               style: .destructive) { _ in
                                self.viewModel.remove(at: index)
        }
        let no = UIAlertAction(title: "Cancel",
                               style: .cancel,
                               handler: nil)
        alert.addAction(ok)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ArrayTableViewController {
    static func newVC() -> ArrayTableViewController {
        return UIStoryboard.rxSwifty.instantiateViewController(withIdentifier: "NextViewController") as! ArrayTableViewController
    }
}

