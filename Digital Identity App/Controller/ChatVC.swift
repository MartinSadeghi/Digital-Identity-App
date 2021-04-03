//
//  ChatVC.swift
//  Digital Identity App
//
//  Created by Mohammadreza Sadeghi on 25/03/2021.
//

import UIKit
import Speech
import TakeASelfie



enum MessageType {
    case appMsg
    case userMsg
}

struct Message {
    let textMessage: String
    let messageType: MessageType
}

class ChatVC: UIViewController, SelfieViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
  
    
    func selfieViewControllerDismissed() {
        print("done selfie is ready")
    }
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var micBtn: UIButton!
    @IBOutlet var stopBtn: UIButton!
    @IBOutlet var camBtn: UIButton!
    @IBOutlet var selfieBtn: UIButton!
    
    
    
    var timer : Timer?
    
    let speechManager = SpeechRecognizerManager.shared
    var questions = [Question]()
    var messages = [Message]() {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Account"
        camBtn.isHidden = true
        selfieBtn.isHidden = true
        
        tableView.register(UINib(nibName: "MasterCell", bundle: nil), forCellReuseIdentifier: "MasterCell")
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        requestToAuthorize()
        tableView.dataSource = self
        tableView.delegate = self
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        questions.append(Question.init(id: 1, questionType: .speech, description: "What is your first name?", hasSeen: false))
        questions.append(Question.init(id: 2, questionType: .speech, description: "What is your last name?", hasSeen: false))
        questions.append(Question.init(id: 3, questionType: .Image, description: "Show front of your Identity Card", hasSeen: false))
        questions.append(Question.init(id: 4, questionType: .Image, description: "Show back of your Identity Card", hasSeen: false))
        questions.append(Question.init(id: 4, questionType: .Image, description: "Take a selfie of yourself, Please!", hasSeen: false))
        
        addFirstMessage()
       
        
    }
    private func addFirstMessage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // your code here
            self.messages.append(Message.init(textMessage: "Are you ready? Let's start verifying!",
                                              messageType: .appMsg))
            
           
        }
    }
    
    private func requestToAuthorize(){
        speechManager.requestSpeechAthorization { (res) in
            //  res ? (self.startBtn.isEnabled = true) : (self.startBtn.isEnabled = false)
        }
    }
    
    
    func textToSpeech (words : String) {
        let utterance = AVSpeechUtterance(string: words)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
       // utterance.rate = 0.1

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
     func showNextQuestion(){
        if let i = questions.firstIndex(where: { $0.hasSeen == false }){
            questions[i].hasSeen = true
            
          
            if i == 2 {
                micBtn.isHidden = true
                stopBtn.isHidden = true
                camBtn.isHidden = false
                
            } else if i == 3 {
                micBtn.isHidden = true
                stopBtn.isHidden = true
                camBtn.isHidden = false

               
                
            } else if i == 4 {
                micBtn.isHidden = true
                stopBtn.isHidden = true
                camBtn.isHidden = false
                selfieBtn.isHidden = false
                
            }
            else if i == 5 {
                micBtn.isHidden = true
                stopBtn.isHidden = true
                camBtn.isHidden = true
                selfieBtn.isHidden = false
                
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let indexPath = IndexPath(row : self.messages.count - 1 , section: 0 )
                self.messages.append(Message.init(textMessage: self.questions[i].description, messageType: .appMsg))
                
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        else{
            micBtn.isEnabled = false
        }
    }
    
    
    @IBAction func micBtn(_ sender: UIButton) {
        // micBtn.isEnabled = false
        speechManager.stopRecording()
        speechManager.recordAndRecognizeSpeech()
        
    }
    
    
    @IBAction func stopBtn(_ sender: UIButton) {
        speechManager.stopRecording()
        let textMessage = speechManager.textMessage
        messages.append(Message.init(textMessage: textMessage, messageType: .userMsg))
        showNextQuestion()
    }
    
//    @IBAction func camBtn(_ sender: UIButton) {
//        let picker = UIImagePickerController()
//            picker.delegate = self
//        picker.sourceType = .camera
//        present(picker, animated: true, completion:nil)
//            }
    
    
    
    
    @IBAction func selfieBtn(_ sender: UIButton) {
        
    selfieViewControllerDismissed()
        let selfieViewController = SelfieViewController(withDelegate: self)
        present(selfieViewController, animated: true, completion: nil)
    }
    
}








extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  messages[indexPath.row].messageType == .appMsg {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.msgLabel?.text = messages[indexPath.row].textMessage
            textToSpeech(words: messages[indexPath.row].textMessage)
            return cell
           
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.msgLabel2?.text = messages[indexPath.row].textMessage
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


