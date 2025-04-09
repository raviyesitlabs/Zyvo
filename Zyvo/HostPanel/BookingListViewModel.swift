//
//  BookingListViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 17/02/25.
//

import Foundation
import Combine
import UIKit

class BookingListViewModel :NSObject{
    
  
    @Published var getBookingsListResult:Result<BaseResponse<[BookingListDataModel]>,Error>? = nil
    
    @Published var readBookingResult:Result<BaseResponse<EmptyModel>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension BookingListViewModel {
    
    func apiforGetBookingsList(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
     
        APIServices<[BookingListDataModel]>().post(endpoint: .get_host_booking_list, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getBookingsListResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getBookingsListResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
    
    func apiforReadBookingCount(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
     
        APIServices<EmptyModel>().post(endpoint: .hostReadBooking, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.readBookingResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.readBookingResult = .success(response)
                }else {
                    self.readBookingResult = .success(response)
                    //topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
    
   
   
}
