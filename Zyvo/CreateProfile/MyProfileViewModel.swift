//
//  MyProfileViewModel.swift
//  Zyvo
//
//  Created by ravi on 23/01/25.
//

import Combine
import Foundation
import UIKit

class MyProfileViewModel:NSObject {
    
    @Published var imageEncoded:Data? = nil
    @Published var getProfileUpdate:Result<BaseResponse<CreateProfileModel>,Error>? = nil
    @Published var emailOrPhon: String = ""
    var first_name: String   = ""
    var last_name: String   = ""
    var about_me: String   = ""
    var identity_verify: Int = 0
    var where_live: [String]  = []
    var works: [String]  = []
    var languages: [String]  = []
    var hobbies: [String]  = []
    var pets: [String]  = []
    
    private var cancellables = Set<AnyCancellable>()
    override init() {
        super.init()
    }
    func encodeImageToString(image: UIImage) {
//        image.resizeByByte(maxMB: 1.0) { imageData in
//            self.imageEncoded = imageData
//            self.uploadProfile()
//        }
        image.resizeByByte(maxMB: 1) { (data) in
            DispatchQueue.main.async {
                guard let imageData = data else {
                    topViewController?.showAlert(for: "Image could not be processed. Please select a smaller image.")
                    return
                }
                self.imageEncoded = imageData
                self.uploadProfile()
            }
        }
    }
}

extension MyProfileViewModel {
    
    func uploadProfile(){
        
        var para                      =      [String:Any]()
        var imagePara                 =      [String:Data]()
        
        para[APIKeys.userID]          =      UserDetail.shared.getUserId()
        para[APIKeys.firstname]            =      self.first_name
        para[APIKeys.lastname]           =      self.last_name
        para[APIKeys.where_live]             =      self.where_live
        para[APIKeys.works]             =      self.works
        para[APIKeys.languages]             =      self.languages
        para[APIKeys.hobbies]             =      self.hobbies
        para[APIKeys.pets]             =      self.pets
        
        para[APIKeys.aboutme]             =      self.about_me
        
        para[APIKeys.identityverify]             =      self.identity_verify
        
        
        imagePara[APIKeys.profileImg] = imageEncoded
        
        APIServices<CreateProfileModel>().SendAnyThing(endpoint: .completeprofile, parameters: para, images: imagePara)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getProfileUpdate = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getProfileUpdate = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
}
