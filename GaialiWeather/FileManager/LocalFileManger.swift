//
//  FileManger.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import Foundation
import RxSwift

struct LocalFileManager {
    func load<T: Decodable>(fileName: String) -> Observable<T> {
        return Observable<T>.create { observer in
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(T.self, from: data)
                    observer.on(.next(jsonData))
                    observer.on(.completed)
                } catch {
                    print("error:\(error)")
                    observer.on(.error(error))
                }
            }

            return Disposables.create()
        }
    }
}
