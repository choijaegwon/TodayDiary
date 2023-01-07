//
//  BookService.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire
import RxCocoa

private let clientIdKey = NaverServiceApiKey.clientIdKey
private let clientSecretKey = NaverServiceApiKey.clientSecretKey

class BookService {
    private let clientId: String = clientIdKey
    private let clientSecret: String = clientSecretKey
    private let disposeBag = DisposeBag()
    
    static var shared = BookService()
    
    var bookList = PublishSubject<[Book]>()
    
    private let baseURL: String = "https://openapi.naver.com/v1/search/book.json"
   
    private lazy var headers: HTTPHeaders = [
        "Content-Type":"application/json;charset=utf-8",
        "X-Naver-Client-Id": "\(self.clientId)",
        "X-Naver-Client-Secret": "\(self.clientSecret)"
    ]
    
    func fetchBooks(bookName: String) {
        let parameters: Parameters = ["query": "\(bookName)"]
        requestJSON(.get, baseURL, parameters: parameters, headers: headers)
            .map { $1 }
            .map { response -> [Book] in
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let bookListData = try JSONDecoder().decode(BookResult.self, from: data)
                return bookListData.items
            }.subscribe(onNext: {
                self.bookList.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}
