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

enum QuestionError: Error {
    case invalidResource
    case conversionFailure
    case invalidSelection
    case noQuestionsLeft
}

struct Answer {
    var text : String
    var date : Int
    var url : String
    init(text: String, date: Int, url: String)
    {
        self.text = text
        self.date = date
        self.url = url
    }
}

class PlistConverter {
    static func array(fromFile name: String, ofType type: String) throws -> [AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw QuestionError.invalidResource
        }
        
        guard let array = NSArray(contentsOfFile: path) as [AnyObject]? else {
            throw QuestionError.conversionFailure
        }
        
        return array
    }
}

class InventoryUnarchiver {
    static func questionList(fromDictionary array: [AnyObject]) throws -> [Answer] {
        
        var list: [Answer] = []
        
        for answer in array {
            if let date = answer["date"] as? Int, let text = answer["text"] as? String, let url = answer["url"] as? String {
                let event = Answer(text: text, date: date, url: url)
//
//                guard let selection = VendingSelection(rawValue: key) else {
//                    throw InventoryError.invalidSelection
//                }
                
                list.append(event)
            }
        }
        
        
        return list
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
    var fullAnswers : [Answer]
    var score = 0
    var count = 0
    var isOver = false
    
    func beginQuiz() {
        isOver = false
        score = 0
        count = 0
        Answers = fullAnswers
        nextQuestion()
    }
    
    
    func shuffleArray(array: [Answer]) -> [Answer] {
        var tempArray = array
        var shuffled : [Answer] = []
        for _ in 0..<tempArray.count
        {
            let rand = Int(arc4random_uniform(UInt32(tempArray.count)))
            
            shuffled.append(tempArray[rand])
            
            tempArray.remove(at: rand)
        }
        
        return shuffled
    }
    
    func endQuiz() {
        isOver = true
    }
    
    func nextQuestion(){
        
        
        count += 1
        
        Answers = shuffleArray(array: Answers)
        Question = QuizQuestion(Answer1: Answers[0], Answer2: Answers[1], Answer3: Answers[2], Answer4: Answers[3])
            Answers.remove(at: 3)
            Answers.remove(at: 2)
            Answers.remove(at: 1)
            Answers.remove(at: 0)
            print(Answers)
        
        if count >= 6 {
            endQuiz()
        }
       
    }
    
    func checkAnswer() -> Bool {
        let result = Question.checkAnswer()
        if result {
            score += 1
        }
        return Question.checkAnswer()
    }
    
    init(Answers: [Answer]){
        self.Answers = Answers
        self.fullAnswers = Answers
        self.Question = QuizQuestion(Answer1: Answers[0], Answer2: Answers[1], Answer3: Answers[2], Answer4: Answers[3])
    }
}


