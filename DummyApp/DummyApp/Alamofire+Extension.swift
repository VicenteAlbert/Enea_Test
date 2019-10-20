//
//  Alamofire+Extension.swift
//  DummyApp
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import Alamofire
import FutureKit

extension Alamofire.DataRequest {
    
    // This is a nice adition to Alamofire's DataRequest, as it allows us to actually work with Decodable types and also
    // we return a Future which we'll be able to observe and trigger UI updates once it gets filled
    @discardableResult
    func getFutureValue<C: Decodable>(type: C.Type) -> Future<C> {
        
        // just create an empty promise which will be filled later on
        let promise = Promise<C>()
        
        // we're using the same behavior as a normal DataRequest, aka we're adding an operation to Alamofire's
        // TaskDelegate queue, this was inspired by the `response` function from the ResponseSerialization.swift
        delegate.queue.addOperation {
            guard let data = self.delegate.data else {
                let nsErr = NSError(domain: "DataRequest", code: -69, userInfo: nil)
                promise.completeWithFail(nsErr)
                return
            }
            do {
                promise.completeWithSuccess(try JSONDecoder().decode(C.self, from: data))
            } catch {
                promise.completeWithFail(error)
            }
        }
        
        // return the future for the locally created promise
        return promise.future
    }
}
