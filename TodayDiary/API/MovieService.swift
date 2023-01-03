//
//  MovieService.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/24.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire
import RxCocoa

private let clientIdKey = NaverServiceApiKey.clientIdKey
private let clientSecretKey = NaverServiceApiKey.clientSecretKey

class MovieService {
    private let clientId: String = clientIdKey
    private let clientSecret: String = clientSecretKey
    private let disposeBag = DisposeBag()
    
    static var shared = MovieService()
    
    var movieList = PublishSubject<[Movie]>()
    
    private let baseURL: String = "https://openapi.naver.com/v1/search/movie.json"
   
    private lazy var headers: HTTPHeaders = [
        "Content-Type":"application/json;charset=utf-8",
        "X-Naver-Client-Id": "\(self.clientId)",
        "X-Naver-Client-Secret": "\(self.clientSecret)"
    ]
    
    
    func fetchMovies(movieName: String) {
        let parameters: Parameters = ["query": "\(movieName)"]
        requestJSON(.get, baseURL, parameters: parameters, headers: headers)
            .map { $1 }
            .map { response -> [Movie] in
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let movieListData = try JSONDecoder().decode(MovieResult.self, from: data)
                return movieListData.items
            }.subscribe(onNext: {
                self.movieList.onNext($0)
            })
            .disposed(by: disposeBag)
    }
}
