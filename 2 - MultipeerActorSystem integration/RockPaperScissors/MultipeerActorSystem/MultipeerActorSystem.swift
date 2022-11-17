import Foundation
import Distributed
import MultipeerKit

final class MultipeerActorSystem: DistributedActorSystem {
    
    typealias SerializationRequirement = Codable
    typealias ActorID = MultipeerActorID
    typealias InvocationDecoder = MultipeerInvocationDecoder
    typealias InvocationEncoder = MultipeerInvocationEncoder
    typealias ResultHandler = MultipeerResultHandler

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let registry = ActorRegistry()
    
    let service: MultipeerService
    let registeredTypes: [String: Any.Type]
    
    init(service: MultipeerService, acceptedTypes: [Any.Type]) {
        self.service = service
        self.registeredTypes = acceptedTypes.reduce(into: [:]) { partialResult, type in
            partialResult[String(reflecting: type)] = type
        }
        service.receiveCallback = handleReceivedMessage
    }
}

extension MultipeerActorSystem {
    enum RemoteCallError: Error {
        case missingResult
    }

    func remoteCall<Actor, Failure, Success>(
        on actor: Actor,
        target: RemoteCallTarget,
        invocation: inout InvocationEncoder, // inout not in SE proposal
        throwing: Failure.Type,
        returning: Success.Type
    ) async throws -> Success
        where Actor: DistributedActor,
              Actor.ID == ActorID,
              Failure: Error,
              Success: SerializationRequirement {
                  // Called by the proxy when the invocation encoder contains all information from the call
                  
                  // 1 - create a MessageContainer.Header using the actor ID and the remote call target identifier
                  
                  // 2 - create a MessageContainer using the header above and the invocation data
                  
                  // 3 - encode the message container to JSON
                  
                  // 4 - use the MultipeerService to send the encoded data to the remote peer and retrieve the response
                  // (throw RemoteCallError.missingResult if there is no response)
                  
                  // 5 - decode and return the results
                  
                  throw RemoteCallError.missingResult // 6 - remove this line (its only purpose is to keep the compiler happy when the method isn't implemented)
    }

    func remoteCallVoid<Actor, Failure>(
        on actor: Actor,
        target: RemoteCallTarget,
        invocation: inout InvocationEncoder, // inout not in SE proposal
        throwing: Failure.Type
    ) async throws
        where Actor: DistributedActor,
              Actor.ID == ActorID,
              Failure: Error {
                  // Called by the proxy when the invocation encoder contains all information from the call
                  
                  // same as steps 1-4 above, without expecting or returning a result
    }
}

extension MultipeerActorSystem {
    enum MessageHandlerError: Error {
        case recipientNotFound
        case missingResult
    }

    func handleReceivedMessage(_ data: Data) async throws -> Data? {
        // Called by the transport layer when a message is received.
        // data is the JSON-encoded message container sent through the Multipeer connection.
        
        // 1 - decode it into a MessageContainer instance
        
        // 2 - resolve the recipient (a distributed actor instance) from the recipientID contained in the message header
        // (throw MessageHandlerError.recipientNotFound if it doesn't exist)
        
        // 3 - create a RemoteCallTarget using the target identifier from the message header
        
        // 4 - instantiate an InvocationDecoder and a ResultHandler
        
        // 5 - call the target method on the recipient (use executeDistributedTarget)
        
        // 6 - retrieve and return the encoded results (see MultipeerResultHandler implementation)
        // (throw MessageHandlerError.missingResult if there is no data available)
        
        return nil // 7 - remove this line (its only purpose is to keep the compiler happy when the method isn't implemented)
    }
}
