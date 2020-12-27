//
//  ResourceRequest.swift
//  Homepwner
//
//  Created by Theon.PAN on 2020/12/15.
//  Copyright © 2020 Pan Qingrong. All rights reserved.
//

import Foundation

struct ResourceRequest<ResourceType> where ResourceType :Codable {
    let baseURL = "http://localhost:8080/api/"
    let resourceURL:URL
    
    init(resourcePath:String){
        guard let resourceURL = URL(string: baseURL) else {
            fatalError("Failed to convert baseURL to a URL")
        }
        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
    }
    
    func save<CreateType>(
        _ saveData:CreateType,
        completion:@escaping (Result<ResourceType, ResourceRequestError>) -> Void
    ) where CreateType : Codable {
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            urlRequest.httpBody = try encoder.encode(saveData)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest){
                data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let jsonData = data
                else{
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                    completion(.success(resource))
                }catch{
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingError))
        }
    }
    
    func update<CreateType>(
        _ updateDate:CreateType,
        completion:@escaping (Result<ResourceType, ResourceRequestError>)->Void
    ) where CreateType : Codable {
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "PUT"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970
            urlRequest.httpBody = try encoder.encode(updateDate)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest){
                data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let jsonData = data
                else{
                    completion(.failure(.noData))
                    return
                }
                do {
                    let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                    completion(.success(resource))
                }catch{
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        }catch {
            completion(.failure(.encodingError))
        }
    }
    
    func getAll(completion:@escaping (Result<[ResourceType], ResourceRequestError>)->Void ){
        let dataTask = URLSession.shared.dataTask(with: resourceURL){
            data, _, _ in
            guard let jsonData = data else{
                completion(.failure(.noData))
                return
            }
            do {
                print(String(decoding:jsonData, as: UTF8.self))
                let decoder = JSONDecoder()
                let resources = try decoder.decode([ResourceType].self, from: jsonData)
                completion(.success(resources))
            } catch {
                completion(.failure(.decodingError))

                return
            }
            
        }
        dataTask.resume()
    }
    
    
}

