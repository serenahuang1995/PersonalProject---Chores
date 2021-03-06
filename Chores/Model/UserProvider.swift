//
//  UserProvider.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/5/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum UserFetchError: Error {
    
    case userNotExist
    
    case firebaseError(error: Error)
}

class UserProvider {
    
    static let shared = UserProvider()
    
    lazy var database = Firestore.firestore()
    
    var user: User = User(
        
        id: "",
        name: "",
        picture: "",
        points: -1,
        weekHours: -1,
        totalHours: -1,
        groupId: "",
        isSpent: false
    )
    
    var groupMembers: [User] = []
    
    // FirebaseUid
    var uid: String? =
//        UserDefaults.standard.string(forKey: "FirebaseUid")
        //        "ARNaS8WOtYviuzarS5nb" // Ainee被邀請
                "XC6b6Ys1VY1qLcBJ5M8z"  // Serena mock data
        //    "N8VeGRV8Ev9CHvGPp7Bd" // Max
//            "29cTFrYztvTPK8IHoA1m" // 沛沛
//            "DOy8GQ6CRh5qeHnodC2y"  // 派派
        //    "E7YYDXzzUAFus39YhKoR" // James
        //    "QlO66m51RGdoSMJv95FT" // Wayne
        //    "UedNXmGiiB2vhf2Njm8g" // Surbine
        //    "dacURDVFPNY4SIdW4w3S" // Hannah
        //    "dc7CXgn8G5kCX7h6rEPR" // Ben
//            "vTphjWhWRffOaEXgqOrQ" //Wen



    func addNewUser(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(user.id)
        
        do {
            
            try docReference.setData(from: user) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                    
                } else {
                    
                    completion(.success("add new user success"))
                }
            }

        } catch {
            
            completion(.failure(error))
        }
    }
    
    // 一次性的fetch user
    func fetchOwner(userId: String,
                    completion: @escaping (Result<User, UserFetchError>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(userId)
        
        docReference.getDocument { querySnapshot, error in
            
            if let error = error {
                
                completion(.failure(UserFetchError.firebaseError(error: error)))
                
            } else {
                
                do {
                    
                    let user = try querySnapshot?.data(as: User.self, decoder: Firestore.Decoder())
                    
                    if let user = user {
                        
                        if user.id == self.uid {
                            
                            self.user = user
                        }
                        
                        completion(.success(user))
                        
                    } else {
                        
                        completion(.failure(UserFetchError.userNotExist))
                    }
                    
                } catch {
                    
                    completion(.failure(UserFetchError.firebaseError(error: error)))
                }
            }
        }
    }
    
    // Signin會用到 去判斷他是不是新使用者
    func fetchUser(completion: @escaping (Result<User?, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(uid ?? "")
        
        docReference.getDocument { querySnapshot, error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                do {
                    
                    let user = try querySnapshot?.data(as: User.self, decoder: Firestore.Decoder())
                    
                    if let user = user {
                        
                        self.user = user
                    }
                    
                    completion(.success(user))
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Profile監聽user任何變化
    func fetchUserListener(completion: @escaping (Result<User, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(uid ?? "")
        
        docReference.addSnapshotListener {  querySnapshot, error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                let user = try? querySnapshot?.data(as: User.self)
                
                if let user = user {
                    
                    self.user = user
                    
                    completion(.success(user))
                }
            }
        }
    }
    
    // 更新用戶的點數與時數，因為有可能會是別人幫你按完成，但點數要更新在自己身上，所以parameter會帶一個 user
    func updateUserPoints(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(user.id)
        
        docReference.updateData([UserField.points: user.points,
                                 UserField.totalHours: user.totalHours,
                                 UserField.weekHours: user.weekHours]) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Update points success"))
            }
        }
    }
    
    // 目前是自己登入以後會更新自己的每週時數
    func updateWeekHours(completion: @escaping (Result<String, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(UserProvider.shared.uid ?? "")
        
        docReference.updateData([UserField.weekHours: 0])
        
        completion(.success("update weekHours success"))
    }
    
    // 成功建立群組會把user的group id更新成自己創建的群組id
    func updateGroupId(groupId: String,
                       completion: @escaping (Result<String, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(uid ?? "")
        
        docReference.updateData([UserField.groupId: groupId]) { [weak self] error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                self?.user.groupId = groupId
                
                completion(.success("update group id success"))
            }
        }
    }
    
    // 被邀請的用戶進入群組後會assign該群組的id給使用者
    func updateGroupId(invitation: Invitation,
                       completion: @escaping (Result<String, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(uid ?? "")
        
        docReference.updateData([UserField.groupId: invitation.group]) { [weak self] error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                self?.user.groupId = invitation.group
                
                completion(.success("update success"))
            }
        }
    }
    
    // 離開群組之後會移除用戶的group id
    func leaveGroup(completion: @escaping (Result<String, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(user.id)
        
        docReference.updateData([UserField.groupId: nil ?? "",
                                 UserField.points: 0,
                                 UserField.weekHours: 0,
                                 UserField.totalHours: 0]) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("Success"))
            }
        }        
    }
    
    func sendInviation(invitation: Invitation,
                       userId: String,
                       completion: @escaping (Result<String, Error>) -> Void) {
        
        let docReference = database
            .collection(Collection.users).document(userId)
            .collection(Collection.invitations).document()
        
        // 用documentId當作invitation id
        let documentId = docReference.documentID
        
        var newInvitation = invitation
        
        newInvitation.id = documentId
        
        do {
            
            try docReference.setData(from: newInvitation) { error in
                
                if let error = error {
                    
                    completion(.failure(error))
                    
                } else {
                    
                    completion(.success("send invitation success"))
                }
            }

        } catch {
            
            completion(.failure(error))
        }
    }
    
    // 監聽有沒有收到邀請
    func getInvitationListener(completion: @escaping (Result<[Invitation], Error>) -> Void) {
        
        let docReference = database
            .collection(Collection.users).document(uid ?? "")
            .collection(Collection.invitations)
        
        docReference.addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                guard let documents = querySnapshot?.documents else { return }
                
                let invitations = documents.compactMap({ queryDocument -> Invitation? in
                    
                    return try? queryDocument.data(as: Invitation.self)
                })
                
                completion(.success(invitations))
            }
        }
    }
    
    // 接受邀請或拒絕邀請之後要把邀請列表清空
    func deleteInvitation(invitation: Invitation,
                          completion: @escaping (Result<String, Error>) -> Void) {
        
        let docRerence = database
            .collection(Collection.users).document(uid ?? "")
            .collection(Collection.invitations).document(invitation.id)
        
        docRerence.delete() { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("delete invitation success"))
            }
        }
    }

    func fetchGroupMember(completion: @escaping (Result<[User], Error>) -> Void) {
        
        let docRerence = database
            .collection(Collection.users)
            .whereField(UserField.groupId, isEqualTo: user.groupId ?? "")
        
        docRerence.addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                guard let documents = querySnapshot?.documents else { return }

                let users = documents.compactMap({ queryDocument -> User? in
                                        
                    do {
                        
                        let user = try queryDocument.data(as: User.self)
                        
                        return user
                        
                    } catch {
                        
                        print(error)
                    }
                    
                    return nil
                })
                
                self.groupMembers = users
                
                completion(.success(users))
            }
        }
    }
    
    // 判斷我帶進來的任一id有沒有符合group members內的user id，找到那個user並回傳他user的name
    func getUserNameById(id: String) -> String? {
        
        // 利用 firstIndex 去找 groupMembers 這個 array 中第幾個 index 是符合條件的
        let index = groupMembers.firstIndex { $0.id == id }

        if let index = index {
            
            return groupMembers[index].name

        } else {

            return nil
        }
//        var foundUser: User?
//        for user in groupMembers {
//            if id == user.id {
//                foundUser = user
//                break
//            }
//        }
//        return foundUser?.name
    }
    
    func changeUserName(name: String,
                        completion: @escaping (Result<String, Error>) -> Void) {
        
        let docReference = database.collection(Collection.users).document(uid ?? "")
        
        docReference.updateData([UserField.name: name]) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("rename success"))
            }
        }
    }
    
    func changeUserImage(imageName: String,
                         completion: @escaping (Result<String, Error>) -> Void) {

        let docReference = database.collection(Collection.users).document(uid ?? "")
        
        docReference.updateData([UserField.picture: imageName]) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("change image success"))
            }
        }
    }
    
    func getMedal(completion: @escaping (Result<String, Error>) -> Void) {

        let docReference = database.collection(Collection.users).document(uid ?? "")
        
        docReference.updateData([UserField.isSpent: true]) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("get medal success"))
            }
        }
    }
    
    func resetMedal(completion: @escaping (Result<String, Error>) -> Void) {

        let docReference = database.collection(Collection.users).document(uid ?? "")
        
        docReference.updateData([UserField.isSpent: false]) { error in
            
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                completion(.success("reset success"))
            }
        }
    }
}
