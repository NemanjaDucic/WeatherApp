//
//  NetworkingService.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import Foundation
import RxSwift

struct Networking {
    func execute<T: Decodable>(url: URL) -> Observable<T> {        
        return Observable.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { data, urlResponse, error in
                guard let data = data, let decodedData = try? JSONDecoder().decode(T.self, from: data) else { return }

                observer.onNext(decodedData)
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
