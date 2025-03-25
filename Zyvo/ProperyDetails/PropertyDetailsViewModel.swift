//
//  PropertyDetailsViewModel.swift
//  Zyvo
//
//  Created by ravi on 3/02/25.
//

import Combine
import Foundation
import UIKit

class PropertyDetailsViewModel:NSObject {
    @Published var errorMessage: String?
   
    @Published var responseRate: Int = 0
    @Published var Communication: Int = 0
    @Published var onTime: Int = 0
    
    @Published var reviewMSG: String = ""
   
   
    @Published var isProfileValid: Bool = false
    
   
    
    @Published var getPropertyDetailsResult:Result<BaseResponse<PropertyDetailsModel>,Error>? = nil
    
    @Published var getFilterDataResult:Result<BaseResponse<[FilterModel]>,Error>? = nil
    
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
   
 
}

extension PropertyDetailsViewModel {
    
    func apiForGetPropertyDetails(propertyId:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyid] = propertyId
        
        APIServices<PropertyDetailsModel>().post(endpoint: .get_home_property_details, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getPropertyDetailsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getPropertyDetailsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    
    func apiForFilterData(propertyId:String,filter:String,page: Int?){
        var para = [String:Any]()
        
        para[APIKeys.filter] = filter
        para[APIKeys.propertyid] = propertyId
        para[APIKeys.page] = page
        
        
        
        APIServices<[FilterModel]>().post(endpoint: .filter_property_reviews, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getFilterDataResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getFilterDataResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
   
}

