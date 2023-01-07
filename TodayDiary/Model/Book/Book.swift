//
//  Book.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import Foundation

// MARK: - Welcome
struct BookResult: Codable {
    let items: [Book]
}

// MARK: - Item
struct Book: Codable {
    // 책 제목
    let title: String
    // 나중에 삭제
    let link: String
    // 책 이미지
    let image: String
    // 저자, 출판사
    let author, publisher: String
}
