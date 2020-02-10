//
//  ArrayViewModel.swift
//  RxSwifty
//
//  Created by Kevin Yu on 1/21/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import RxSwift
import RxCocoa

final class ArrayViewModel<T> {
    
    // MARK: - Properties
    
    fileprivate(set) var items: BehaviorRelay<[T]> // use in place of Variable
    fileprivate let disposeBag = DisposeBag()
    private var debugDisposeBag: DisposeBag!
    
    var itemCount: Int {
        return items.value.count
    }
    
    var enableDebugging: Bool = false {
        didSet {
            if enableDebugging == true {
                debugDisposeBag = DisposeBag()
                debugPrintEveryChange()
            } else {
                debugDisposeBag = nil
            }
        }
    }
    
    // MARK: - Initializers
    
    init() {
        items = BehaviorRelay(value: [])
    }
    
    init(_ array: [T]) {
        items = BehaviorRelay(value: array)
    }
    
    // MARK: - Basic Accessors
    
    func append(_ newVal: T) {
        items.accept(items.value + [newVal])
    }
    
    func appendVals(_ newVals: [T]) {
        items.accept(items.value + newVals)
    }
    
    func remove(at index: Int) {
        var copy = items.value
        copy.remove(at: index)
        items.accept(copy)
    }
    
    func item(at index: Int) -> T {
        return items.value[index]
    }
    
}

// MARK: - Debugging

extension ArrayViewModel {
    
    /// show all changes when they occur
    /// easy testing
    func debugPrintEveryChange() {
        items
            .asObservable()
            .subscribe(onNext: { updatedArray in
                print("Values changed! New: \(updatedArray)")
            })
            .disposed(by: debugDisposeBag)
    }
}

extension BehaviorRelay where Element == Array<String> {
    subscript(_ index: Int) -> String {
        return self.value[index]
    }
}
