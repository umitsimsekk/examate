//
//  ChatTableViewViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 27.07.2024.
//

import Foundation
protocol ChatTableViewViewModelInterface {
    var view : ChatTableViewCellInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func configView()
    func fetchInfoToChannel(channelName: String)
}

class ChatTableViewViewModel {
    weak var view : ChatTableViewCellInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
}
extension ChatTableViewViewModel: ChatTableViewViewModelInterface{
    func fetchInfoToChannel(channelName: String) {
        var message : Message?
        DatabaseManager().getAllMessagesByChannelName(channelName: channelName) { result in
            switch result {
            case .success(let messages):
                message = messages.last
                guard message != nil  else {return }
                DatabaseManager().getUsername(email: message!.sender.senderId) { username in
                    var messg = ""
                    
                    switch message!.kind {
                       
                    case .text(let messageText):
                        messg = messageText
                    case .attributedText(_):
                        break
                    case .photo(_):
                        messg = "(sended image)"
                        break
                    case .video(_):
                        break
                    case .location(_):
                        break
                    case .emoji(_):
                        break
                    case .audio(_):
                        break
                    case .contact(_):
                        break
                    case .linkPreview(_):
                        break
                    case .custom(_):
                        break
                    }
                    var contentLabel = "\(username): \(messg)"
                    print(contentLabel)
                    self.view?.fetchInfoToChannel(latestMessage: contentLabel)

                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func configView() {
        view?.configView()
    }
    
    func viewDidLoad() {
        configView()
    }
    
    func viewDidLayoutSubviews() {
        view?.setLayoutSubviews()
    }
    
}
