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
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var endQuizView: UIView!
    
    @IBOutlet weak var eventOneButton: UIButton!
    @IBOutlet weak var eventTwoButton: UIButton!
    @IBOutlet weak var eventThreeButton: UIButton!
    @IBOutlet weak var eventFourButton: UIButton!
    
    @IBOutlet weak var learnShakeLabel: UILabel!
    
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
  //  var quiz : Quiz
    
    var seconds = 60
    var timer = Timer()
    var quiz : Quiz
    var urlString = ""
    
    var isTimerRunning = false
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = timeString(time: TimeInterval(seconds))
        if seconds < 0 {
            checkAnswer()
        }
    }
    
    func timeString(time:TimeInterval) -> String {
       
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%01i:%02i", minutes, seconds)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue"{
            let vc = segue.destination as! WebViewController
            vc.urlString = urlString
        }
    }
    
    func resetTimer(){
        seconds = 60
        runTimer()
    }
    
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

    
    
    func checkAnswer(){
        if quiz.checkAnswer(){
            nextRoundButton.setImage(UIImage(named: "next_round_success.png"), for: .normal)
        } else {
            nextRoundButton.setImage(UIImage(named: "next_round_fail.png"), for: .normal)
            
        }
        lockButtons()
    }
    
    
    @IBAction func playAgainPressed() {
        showStartQuiz()
        quiz.beginQuiz()
        unlockButtons()
        refreshDisplay()
    }
    
    @IBAction func viewEvent(_ sender: UIButton) {
        //   prepare(for: , sender: <#T##Any?#>)
        
        switch sender.tag {
        case 1:
            urlString = quiz.Question.Answer1.url
        case 2:
            urlString = quiz.Question.Answer2.url
        case 3:
            urlString = quiz.Question.Answer3.url
        case 4:
            urlString = quiz.Question.Answer4.url
        default:
            //  withIdentifier: the used storyboard ID:
            print("No URL!")
        }
        performSegue(withIdentifier: "mySegue", sender: self)
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
    @IBAction func nextRound(_ sender: Any) {
        if quiz.isOver {
           showEndQuiz()
        }
        else {
        quiz.nextQuestion()
        unlockButtons()
        refreshDisplay()
        }
    }
    
    func showEndQuiz(){
        view1.isHidden = true;
        view2.isHidden = true;
        view3.isHidden = true;
        view4.isHidden = true;
        endQuizView.isHidden = false;
        nextRoundButton.isHidden = true;
        timerLabel.isHidden = true;
        learnShakeLabel.isHidden = true;
        scoreLabel.text = "\(quiz.score)/6"
    }
    
    func linksEnabled(enabled: Bool){
        eventOneButton.isEnabled = enabled
        eventTwoButton.isEnabled = enabled
        eventThreeButton.isEnabled = enabled
        eventFourButton.isEnabled = enabled
    }
    func showStartQuiz() {
        view1.isHidden = false;
        view2.isHidden = false;
        view3.isHidden = false;
        view4.isHidden = false;
        endQuizView.isHidden = true;
        nextRoundButton.isHidden = false;
        timerLabel.isHidden = false;
        learnShakeLabel.isHidden = false;
    }
    
    func lockButtons(){
        DArrow1.isEnabled = false
        UArrow2.isEnabled = false
        DArrow2.isEnabled = false
        UArrow3.isEnabled = false
        DArrow3.isEnabled = false
        UArrow4.isEnabled = false
        linksEnabled(enabled: true)
        nextRoundButton.isHidden = false
        timer.invalidate()
        timerLabel.isHidden = true
        learnShakeLabel.text = "Tap events to learn more"
    }
    
    func unlockButtons(){
        DArrow1.isEnabled = true
        UArrow2.isEnabled = true
        DArrow2.isEnabled = true
        UArrow3.isEnabled = true
        DArrow3.isEnabled = true
        UArrow4.isEnabled = true
        linksEnabled(enabled: false)
        nextRoundButton.isHidden = true
        resetTimer()
        timerLabel.isHidden = false
        timerLabel.text = "1:00"
        learnShakeLabel.text = "Shake to submit answer"
    }
    
    func refreshDisplay(){
        LabelOne.text = quiz.Question.Answer1.text
        LabelTwo.text = quiz.Question.Answer2.text
        LabelThree.text = quiz.Question.Answer3.text
        LabelFour.text = quiz.Question.Answer4.text
    }
}

