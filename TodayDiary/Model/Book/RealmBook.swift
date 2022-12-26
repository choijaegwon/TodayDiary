//
//  RealmBook.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/26.
//

import RealmSwift

class RealmBook: Object {
    // 영화 이미지
    @Persisted var bookImage: String
    // 영화 제목
    @Persisted var bookTitle: String
    // 영화 점수
    @Persisted var bookCosmos: Double
    // 저자들
    @Persisted var bookAuthor: String
    // 출판사 이름
    @Persisted var bookPublisher: String
    // 책 본 날짜
    @Persisted var bookDate: String
    // 책 본 소감
    @Persisted var bookContents: String
    
    override static func primaryKey() -> String? {
        return "bookTitle"
    }
}
