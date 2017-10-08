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
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var DArrow1: UIButton!
    @IBOutlet weak var UArrow2: UIButton!
    @IBOutlet weak var DArrow2: UIButton!
    @IBOutlet weak var UArrow3: UIButton!
    @IBOutlet weak var DArrow3: UIButton!
    @IBOutlet weak var UArrow4: UIButton!
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    @IBOutlet weak var CheckButton: UIButton!
    var quiz : Quiz
    
    var seconds = 60
    var timer = Timer()
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)"
        if seconds < 0 {
            checkAnswer()
        }
    }

    func resetTimer(){
        seconds = 10
        runTimer()
    }
    
    var isTimerRunning = false
    
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
        self.becomeFirstResponder() // To get shake gesture
        // Do any additional setup after loading the view, typically from a nib.
        LabelOne.text = "Boo!"
        quiz.nextQuestion()
        refreshDisplay()
        roundCorners()
        unlockButtons()
    }
    
    func roundCorners() {
        view1.layer.cornerRadius = 5
        view2.layer.cornerRadius = 5
        view3.layer.cornerRadius = 5
        view4.layer.cornerRadius = 5
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            checkAnswer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func switchAnswer(_ sender: UIButton) {
        var tempAnswer : Answer
        switch sender.tag {
        case 1:
            tempAnswer = quiz.Question.Answer2
            quiz.Question.Answer2 = quiz.Question.Answer1
            quiz.Question.Answer1 = tempAnswer
        case 2:
            tempAnswer = quiz.Question.Answer3
            quiz.Question.Answer3 = quiz.Question.Answer2
            quiz.Question.Answer2 = tempAnswer
        case 3:
            tempAnswer = quiz.Question.Answer4
            quiz.Question.Answer4 = quiz.Question.Answer3
            quiz.Question.Answer3 = tempAnswer
        default:
            break
        }
        refreshDisplay()
    }
    
    func checkAnswer(){
        if quiz.checkAnswer(){
            nextRoundButton.setImage(UIImage(named: "next_round_success.png"), for: .normal)
        } else {
            nextRoundButton.setImage(UIImage(named: "next_round_fail.png"), for: .normal)
            
        }
        lockButtons()
    }
    
    @IBAction func nextRound(_ sender: Any) {
        if quiz.isOver {
            
        }
        else {
        quiz.nextQuestion()
        unlockButtons()
        refreshDisplay()
        }
    }
    
    func lockButtons(){
        DArrow1.isEnabled = false
        UArrow2.isEnabled = false
        DArrow2.isEnabled = false
        UArrow3.isEnabled = false
        DArrow3.isEnabled = false
        UArrow4.isEnabled = false
        nextRoundButton.isHidden = false
        timer.invalidate()
        timerLabel.isHidden = true
    }
    
    func unlockButtons(){
        DArrow1.isEnabled = true
        UArrow2.isEnabled = true
        DArrow2.isEnabled = true
        UArrow3.isEnabled = true
        DArrow3.isEnabled = true
        UArrow4.isEnabled = true
        nextRoundButton.isHidden = true
        resetTimer()
        timerLabel.isHidden = false
        timerLabel.text = "1:00"
    }
    
    func refreshDisplay(){
        LabelOne.text = quiz.Question.Answer1.text
        LabelTwo.text = quiz.Question.Answer2.text
        LabelThree.text = quiz.Question.Answer3.text
        LabelFour.text = quiz.Question.Answer4.text
    }
}

