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
            DispatchQueue.main.async {
                if let data = data, let responseModel = try? JSONDecoder().decode(APILoginResponseModel.self, from: data) {
                    completion(.success(responseModel))
                }
                else {
                    completion(.failure(error ?? NSError()))
                }
            }
        }.resume()
    }
    
    static func logout(userId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = makeUrl(endpoint: .logout(userId: userId)) else {
            return
        }
        
        let urlRequest = makeUrlRequest(url: url, httpMethod: "POST", httpBody: nil)
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let _ = data {
                    completion(.success(()))
                }
                else {
                    completion(.failure(error ?? NSError()))
                }
            }
        }.resume()
    }
    
    static func appointments(userId: Int, latitude: Double?, longitude: Double?, completion: @escaping (Result<[APIAppointmentModel], Error>) -> Void) {
        var queryItems: [URLQueryItem] = []
        if let latitude = latitude, let longitude = longitude {
            queryItems = [
                URLQueryItem(name: "userLatitude", value: String(latitude)),
                URLQueryItem(name: "userLongitude", value: String(longitude)),
            ]
        }
        
        guard let url = makeUrl(endpoint: .appointments(userId: userId), queryItems: queryItems) else {
            return
        }
        
        let urlRequest = makeUrlRequest(url: url, httpMethod: "GET", httpBody: nil)
        
        // Sends the HTTP request
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let responseModel = try? JSONDecoder().decode([APIAppointmentModel].self, from: data) {
                    completion(.success(responseModel))
                }
                else {
                    completion(.failure(error ?? NSError()))
                }
            }
        }.resume()
    }
    
    private static func makeUrl(endpoint: APIEndpoint, queryItems: [URLQueryItem] = []) -> URL? {
        guard var urlComponents = URLComponents(string: domain + endpoint.path) else {
            return nil
        }
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    private static func makeUrlRequest(url: URL, httpMethod: String?, httpBody: Data?) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // sets token as http header
        if let token = UserDefaultsLogin.token {
            urlRequest.setValue(token, forHTTPHeaderField: "token")
        }
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = httpBody
        return urlRequest
    }
}
