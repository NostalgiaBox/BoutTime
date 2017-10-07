//
//  QuizModel.swift
//  BoutTime
//
//  Created by Murray Fenstermaker on 9/26/17.
//  Copyright © 2017 Nostalgiabox. All rights reserved.
//

import Foundation



enum Position: Int {
    case One = 1
    case Two = 2
    case Three = 3
    case Four = 4
}


struct Answer {
    var text : String
    var date : Int
    
    init(text: String, date: Int)
    {
        self.text = text
        self.date = date
    }
}


class QuizQuestion {
    var Answer1 : Answer
    var Answer2 : Answer
    var Answer3 : Answer
    var Answer4 : Answer
    
    func checkAnswer() -> Bool{
        if (Answer1.date < Answer2.date && Answer2.date < Answer3.date && Answer3.date < Answer4.date) {
            return true
        }
        return false
    }
    
    init (Answer1: Answer, Answer2: Answer, Answer3: Answer, Answer4: Answer) {
        self.Answer1 = Answer1
        self.Answer2 = Answer2
        self.Answer3 = Answer3
        self.Answer4 = Answer4
    }
}

class Quiz {
    var Answers : [Answer]
    var Question : QuizQuestion
    func beginQuiz() {
        
        self.Answers.removeFirst()
        self.Answers.removeFirst()
        self.Answers.removeFirst()
        self.Answers.removeFirst()
        
    }
    
    func endQuiz() {
        
    }
    
    func nextQuestion() {
    //TODO Check question count
        self.Question = QuizQuestion(Answer1: Answers[0], Answer2: Answers[1], Answer3: Answers[2], Answer4: Answers[3])
        self.Answers.removeFirst()
        self.Answers.removeFirst()
        self.Answers.removeFirst()
        self.Answers.removeFirst()
    }
    
    init(Answers: [Answer]){
        self.Answers = Answers
        self.Question = QuizQuestion(Answer1: Answers[0], Answer2: Answers[1], Answer3: Answers[2], Answer4: Answers[3])
    }
}

var a1 = Answer(text: "This is an early Question", date: 1)
var a2 = Answer(text: "This is a mid-early Question", date: 2)
var a3 = Answer(text: "This is a mid-late Question", date: 3)
var a4 = Answer(text: "This is a late Question", date: 4)
let quiz  = Quiz(Answers: [a1, a2, a3, a4, a2, a3, a4, a1])
