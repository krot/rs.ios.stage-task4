import Foundation

final class CallStation {
  var usersArray : [User] = []
  var callsArray : [Call] = []
  var currentCalls : [Call] = []
  
}

extension CallStation: Station {
  func users() -> [User] {
   
    return usersArray
  }
  
  func add(user: User) {
    if !usersArray.contains(user) {
      usersArray.append(user)
    }
  }
  
  func remove(user: User) {
    let index = usersArray.firstIndex(of: user)
    if index != nil {
      usersArray.remove(at: index!)
    }
  }
  
  func execute(action: CallAction) -> CallID? {
    switch action {
    //MARK: - Start
    case .start(let fromUser, let toUser):
      var reason : CallStatus = .calling
      //флаг чрбы прообустить добавление call в currentCalls
      var isAdd = true
      
      //    //проаерить есть ли такие пользователи в базе
      // если нето, то нил
      
      if !(usersArray.contains(fromUser) || usersArray.contains(toUser)) {
        //нет сразу 2-х юзеров
        return nil
        
      } else if !(usersArray.contains(fromUser) && usersArray.contains(toUser)) {
        //нет одного юзера
        reason = .ended(reason: .error)
        isAdd = false
      }
      
      //если юзер есть в списке currentCalls, то пишем что busy и не пишем currentcalls
      currentCalls.forEach { (call) in
        if call.incomingUser == fromUser || call.outgoingUser == fromUser || call.incomingUser == toUser || call.outgoingUser == toUser {
          reason = .ended(reason: .userBusy)
          isAdd = false
        }
      }
      
      //new call is ok
      let call = Call(id: UUID(), incomingUser: toUser, outgoingUser: fromUser, status: reason)
      callsArray.insert(call, at: 0)
      if isAdd {
        currentCalls.append(call)
      }
      return call.id
    //MARK: - Answer
    case .answer(let fromUser):
      
      var reason : CallStatus = .talk
      //флаг чрбы прообустить добавление call в currentCalls
      var isAdd = true
      
      //обрыв связи
      if !usersArray.contains(fromUser){
        reason = .ended(reason: .error)
        isAdd = false
        //нет одного юзера
        //заодно нужно удалить звонок из currentCalls
      }
      
      for index in 0..<callsArray.count {
        if callsArray[index].incomingUser == fromUser{
          let updateCall = Call(id: callsArray[index].id, incomingUser: callsArray[index].incomingUser, outgoingUser: callsArray[index].outgoingUser, status: reason)
 
//          if let i = currentCalls.firstIndex(of: callsArray[index]) {
//            currentCalls.remove(at: i)
//            if isAdd {
//              currentCalls.append(updateCall)
//            }
//          }
 
          for i in (0..<currentCalls.count).reversed(){
            if currentCalls[i].id == callsArray[index].id {
              currentCalls.remove(at: i)
              if isAdd {
                currentCalls.append(updateCall)
              }
            }
          }

          callsArray.remove(at: index)
          callsArray.insert(updateCall, at: index)
          
          if isAdd {
            return callsArray[index].id
          } else{
            return nil
          }
        }
      }
    //MARK: - End
    case .end(let fromUser):
      
      for index in 0..<callsArray.count {
        if callsArray[index].outgoingUser == fromUser || callsArray[index].incomingUser == fromUser{
          var reason : CallStatus = .calling
          
          switch callsArray[index].status{
          case .talk:
            reason = .ended(reason: .end)
          case .calling:
            reason = .ended(reason: .cancel)
          //case .ended(reason: )
          case .ended(reason: let reasonFromStation):
            reason =  .ended(reason: reasonFromStation)
            //print(".ended(reason: let reason")
          }
          
          let updateCall = Call(id: callsArray[index].id, incomingUser: callsArray[index].incomingUser, outgoingUser: callsArray[index].outgoingUser, status: reason)
          
//          if let i = currentCalls.firstIndex(of: callsArray[index]) {
//            currentCalls.remove(at: i)
//          }
          for i in (0..<currentCalls.count).reversed(){
            if currentCalls[i].id == callsArray[index].id {
              currentCalls.remove(at: i)
            }
          }
          
          callsArray.remove(at: index)
          callsArray.insert(updateCall, at: index)
          
          return callsArray[index].id
        }
      }
    }
    return nil
  }
  
  func calls() -> [Call] {
    //а здесь все звонки, даже завершенные
    return callsArray
  }
  
  func calls(user: User) -> [Call] {
    return callsArray.filter { (call) -> Bool in
      call.incomingUser == user || call.outgoingUser == user
    }
  }
  
  func call(id: CallID) -> Call? {
    var answer : Call?
    callsArray.forEach {
      if $0.id == id {
        answer = $0
      }
    }
    return answer
  }
  
  func currentCall(user: User) -> Call? {
    //здесь только активные звонки
    var answer : Call? = nil
    currentCalls.forEach { (call) in
      if call.incomingUser == user || call.outgoingUser == user {
        answer = call
      }
    }
    return answer
  }
}
