//
//  APIClient.swift
//  RxSwifty
//
//  Created by Kevin Yu on 1/21/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import RxSwift

// Adapted from: https://www.netguru.com/codestories/networking-with-rxswift
// and http://swiftyjimmy.com/network-request-with-rxswift/

enum APIClientError: Error {
    case noData
}

extension APIClientError: CustomStringConvertible {
    var description: String {
        switch self {
            case .noData:
            return "No data found"
        }
    }
}

class APIClient<T: Decodable> {
    let session: URLSession
    let decoder = JSONDecoder()
    
    init(_ session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func makeRequest(_ url: URL) -> Observable<T> {
        return Observable<T>
            .create { observer in
                let session = self.session
                let task = session.dataTask(with: url)
                { (data, response, error) in
                    guard let data = data else {
                        observer.onError(APIClientError.noData)
                        observer.onCompleted()
                        return
                    }
                    do {
                        let model: T = try self.decoder.decode(T.self,
                                                               from: data)
                        observer.onNext(model)
                    } catch let error {
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
                task.resume()
                return Disposables.create {
                    task.cancel()
                }
        }
    }
}
