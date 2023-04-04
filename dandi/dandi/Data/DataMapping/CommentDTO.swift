//
//  CommentDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/04.
//

import Foundation

struct CommentWithPageDTO: Codable {
    let comments: [CommentDTO]
    let lastPage: Bool
}

extension CommentWithPageDTO {
    func toDomain() -> ListWithPage<Comment> {
        return ListWithPage(
            list: comments.map { $0.toDomain() },
            lastPage: lastPage
        )
    }
}

struct CommentDTO: Codable {
    let id: Int
    let writer: WriterDTO
    let postWriter: Bool
    let createdAt, content: String
    let mine: Bool
}

extension CommentDTO {
    func toDomain() -> Comment {
        return Comment(
            id: id,
            profileImageURL: writer.profileImageURL,
            nickname: writer.nickname,
            date: createdAt,
            content: content,
            isMine: mine,
            isPostWriter: postWriter
        )
    }
}
