//
//  UserViewModel.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/12/23.
//
//
//import Foundation
//import Combine
//
//class UserViewModel: ObservableObject {
//    @Published var user: UserModel
//    @Published var isEditMode: Bool = false
//    
//    private var cancellables = Set<AnyCancellable>()
//    private let userAPI: UserAPIProtocol
//    
//    init(userAPI: UserAPIProtocol, user: UserModel){
//        self.userAPI = userAPI
//        self.user = user
//    }
//    
//    func toggleEditMode(){
//        isEditMode.toggle()
//    }
//    
//    func saveProfile() {
//        userAPI.updateUser(user) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success():
//                    self.isEditMode = false
//                    print("Profile Updated")
//                case .failure(let error):
//                    print("Profile Update Failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    // TODO: func createUser() { }
//    
//    
//    // TODO: func updateUser() { }
//}
//
// 
//
