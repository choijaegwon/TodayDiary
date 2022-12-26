//
//  RealmMovie.swift
//  TodayDiary
//
//  Created by Jae kwon Choi on 2022/12/25.
//

import RealmSwift

class RealmMoive: Object {
    // 영화 이미지
    @Persisted var movieImage: String
    // 영화 제목
    @Persisted var movieTitle: String
    // 영화 점수
    @Persisted var movieCosmos: Double
    // 영화 개봉년도
    @Persisted var moviePubDate: String
    // 영화 감독
    @Persisted var movieDirector: String
    // 영화 배우들
    @Persisted var movieActor: String
    // 영화 본 날짜
    @Persisted var movieDate: String
    // 영화 본 소감
    @Persisted var movieContents: String
    
    override static func primaryKey() -> String? {
        return "movieTitle"
    }
}
