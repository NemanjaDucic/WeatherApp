//
//  FileManagerService.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import Foundation
import RxSwift

class FileManagerService {
    let fileManager = LocalFileManager()

    func getCityList(name: String) -> Observable<[String]> {
        return fileManager.load(fileName: name)
    }

   
}
