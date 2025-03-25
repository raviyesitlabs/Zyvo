//
//  ChatDataViewModel.swift
//  Zyvo
//
//  Created by ravi on 21/03/25.
//


import Combine
import Foundation
import UIKit

class ChatDataViewModel :NSObject{
    
  
    @Published var getChatDataResult:Result<BaseResponse<[ChatDataModel]>,Error>? = nil
    
    
    @Published var blockResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    
    
   var latitude = ""
    var longitude = ""
   var  datss = ""
    var hourss = 2
    var start_time = ""
    var end_time = ""
    var activity = ""
    var locationss = ""
    
    var bookingDate = ""
    var bookingStart = ""
    
    private var cancellables = Set<AnyCancellable>()
    
}
extension ChatDataViewModel {
    
    func apiForGetChatData(userType : String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.user_type] = userType
        
        APIServices<[ChatDataModel]>().post(endpoint: .get_user_channels, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getChatDataResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getChatDataResult = .success(response)
                }else {
                    self.getChatDataResult = .success(response)
                    //topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    
    func apiForBlockUser(senderId : String,group_channel : String,blockUnblock : String){
        var para = [String:Any]()
        para[APIKeys.senderId] = senderId
        para[APIKeys.group_channel] = group_channel
        para[APIKeys.blockUnblock] = blockUnblock
        
        APIServices<EmptyModel>().post(endpoint: .block_user, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.blockResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.blockResult = .success(response)
                }else {
                    self.blockResult = .success(response)
                    //topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }

  
}
