//
//  MenuViewController.swift
//  RxSwifty
//
//  Created by Kevin Yu on 1/21/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

final class MenuViewController: UIViewController {
    
    fileprivate enum MenuOptions: String, CaseIterable {
        case arrayTableView = "SimpleTableViewArray"
        case networking = "Networking Example"
        case googleBooks = "Google Books Example"
    }

    fileprivate lazy var tableView: UITableView = {
        let tbl = UITableView.init(frame: .zero,
                                   style: .plain)
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(UITableViewCell.self,
                     forCellReuseIdentifier: reuseIdentifier)
        return tbl
    }()
    
    fileprivate let animator: UIViewControllerAnimatedTransitioning = MyTransitionAnimator(.shrink)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create tableView and constraints
        view.addSubview(tableView)
        let top = NSLayoutConstraint(item: tableView,
                                     attribute: .topMargin, relatedBy: .equal,
                                     toItem: view,
                                     attribute: .topMargin,
                                     multiplier: 1.0, constant: 8.0)
        let left = NSLayoutConstraint(item: tableView,
                                      attribute: .leading, relatedBy: .equal,
                                      toItem: view, attribute: .leading,
                                      multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: tableView,
                                       attribute: .trailing, relatedBy: .equal,
                                       toItem: view, attribute: .trailing,
                                       multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: tableView,
                                        attribute: .bottom, relatedBy: .equal,
                                        toItem: view, attribute: .bottom,
                                        multiplier: 1.0, constant: 0.0)
        view.addConstraints([top, left, right, bottom])
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)
        cell.textLabel?.text = "\(MenuOptions.allCases[indexPath.row])"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = MenuOptions.allCases[indexPath.row]
        var vc: UIViewController! = nil
        switch option {
        case .arrayTableView:
            vc = ArrayTableViewController.newVC()
        case .networking:
            vc = DDGViewController.newVC()
        case .googleBooks:
            vc = GBViewController.newVC()
        }
        
        if vc != nil {
            // vc.transitioningDelegate = self // this works for modal, not push-pop...
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
}

enum MyAnimationType {
    case fade, shrink
}

class MyTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationTime: TimeInterval
    let type: MyAnimationType
    
    init(_ animationType: MyAnimationType) {
        self.type = animationType
        animationTime = 1.5
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let currVC = transitionContext.view(forKey: .from),
            let nextVC = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(true)
                return
        }
        let animation: () -> Void
        let completion: (Bool) -> Void
        
        if type == .shrink {
            let middleX = currVC.center.x
            let fullSize = currVC.frame
            let shrinkToFrame = CGRect(x: middleX,
                                       y: 0,
                                       width: 0,
                                       height: currVC.frame.size.height)
            animation = {
                // currVC.frame = shrinkToFrame
                let scale: CGFloat = 0.00000000000001
                let rotate = CGAffineTransform(rotationAngle: 720.0)
                currVC.transform = CGAffineTransform(scaleX: scale,
                                                     y: scale).concatenating(rotate)
            }
            
            completion = { finished in
                if finished == false { return }
                container.addSubview(nextVC)
                nextVC.frame = shrinkToFrame
                
                UIView.animate(withDuration: self.animationTime, animations: {
                    nextVC.frame = fullSize
                }) { finished in
                    if finished {
                        transitionContext.completeTransition(true)
                        currVC.transform = .identity // reset the transformation matrix when completed
                    }
                }
            }
        } else {
            container.addSubview(nextVC)
            currVC.alpha = 1.0
            nextVC.alpha = 0.0
            animation = {
                currVC.alpha = 0.0
                nextVC.alpha = 1.0
            }
            completion = { finished in
                if finished {
                    transitionContext.completeTransition(true)
                }
            }
        }
        
        UIView.animate(withDuration: animationTime,
                       animations: animation,
                       completion: completion)
    }
}
