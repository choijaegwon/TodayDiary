//
//  Movie.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/24.
//

import Foundation

// MARK: - Welcome
struct MovieResult: Codable {
    let items: [Movie]
}

// MARK: - Item
struct Movie: Codable {
    // 영화. 제목 일치하는부분은 <b>태그로 감싸져있다.
    let title: String
    // 이미지 URL
    let image: String
    // 영어제목, 제작연도, 감독, 출연 배우
    let pubDate, director, actor: String
    // 평점
    let userRating: String
}
