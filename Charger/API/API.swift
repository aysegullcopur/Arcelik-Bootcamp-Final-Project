//
//  API.swift
//  Charger
//
//  Created by Aysegul COPUR on 3.07.2022.
//

import Foundation

class API {
    
    //Changed info.plist "Allow Arbitrary Loads" as YES
    private static let domain = "http://ec2-18-197-100-203.eu-central-1.compute.amazonaws.com:8080"
    
    private static let urlSession = URLSession(configuration: .default)
    
    static func login(email: String, deviceUDID: String, completion: @escaping (Result<APILoginResponseModel, Error>) -> Void) {
        guard let url = makeUrl(endpoint: .login) else {
            return
        }
        //
        let requestModel = APILoginRequestModel(email: email, deviceUDID: deviceUDID)
        let httpBody = try? JSONEncoder().encode(requestModel)
        let urlRequest = makeUrlRequest(url: url, httpMethod: "POST", httpBody: httpBody)
        
        // Sends the HTTP request
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data, let responseModel = try? JSONDecoder().decode(APILoginResponseModel.self, from: data) {
                completion(.success(responseModel))
            }
            else {
                completion(.failure(error ?? NSError()))
            }
        }.resume()
    }
    
    private static func makeUrl(endpoint: APIEndpoint) -> URL? {
        return URL(string: domain + endpoint.path)
    }
    
    private static func makeUrlRequest(url: URL, httpMethod: String?, httpBody: Data?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = httpBody
        return urlRequest
    }
    
}
