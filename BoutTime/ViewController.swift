//
//  ViewController.swift
//  BoutTime
//
//  Created by Murray Fenstermaker on 9/26/17.
//  Copyright © 2017 Nostalgiabox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var LabelOne: UILabel!
    @IBOutlet weak var LabelTwo: UILabel!
    @IBOutlet weak var LabelThree: UILabel!
    @IBOutlet weak var LabelFour: UILabel!
    @IBOutlet weak var DArrow1: UIButton!
    
    @IBOutlet weak var CheckButton: UIButton!
    var quiz : Quiz
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.array(fromFile: "QuestionList", ofType: "plist")
            let answerList = try InventoryUnarchiver.questionList(fromDictionary: array)
            quiz  = Quiz(Answers: answerList)
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LabelOne.text = "Boo!"
        quiz.nextQuestion()
        refreshDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var DownPressedOne: UIButton!
 
    @IBAction func DownPressedOne(_ sender: Any) {
        let tempAns = quiz.Question.Answer2
        quiz.Question.Answer2 = quiz.Question.Answer1
        quiz.Question.Answer1 = tempAns
        refreshDisplay()
    }
    
    @IBAction func checkAnswer(_ sender: Any) {
        if (quiz.Question.checkAnswer())
        {
            CheckButton.setTitle("Correct", for: .normal)
        } else {
            CheckButton.setTitle("incorrect", for: .normal)
        }
    }
    
    func refreshDisplay(){
        LabelOne.text = quiz.Question.Answer1.text
        LabelTwo.text = quiz.Question.Answer2.text
        LabelThree.text = quiz.Question.Answer3.text
        LabelFour.text = quiz.Question.Answer4.text
    }
}

