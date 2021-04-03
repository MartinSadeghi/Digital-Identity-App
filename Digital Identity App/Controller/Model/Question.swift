//
//  Question.swift
//  Digital Identity App
//
//  Created by Mohammadreza Sadeghi on 25/03/2021.
//

import Foundation
import UIKit

enum QuestionType {
    case speech
    case Image
}

struct Question {
    let id: Int
    let questionType : QuestionType
    let description: String
    var hasSeen: Bool
}
