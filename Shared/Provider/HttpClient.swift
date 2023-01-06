//
//  HttpClient.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 08/04/2022.
//

import Foundation

struct HttpClient {
    
    public static func sendRequest(request: URLRequest) -> Data? {
        let sem = DispatchSemaphore.init(value: 0)
        var returnData: Data? = nil
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            defer { sem.signal() }
            if error != nil {
                print(error!.localizedDescription)
            }

            if data != nil {
                returnData = data
            }
        })

        task.resume()
        sem.wait()
        
        return returnData
    }
}
