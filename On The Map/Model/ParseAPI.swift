//
//  ParseAPI.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import Foundation

class ParseAPI {

    class func getAllStudentLocations(completion: @escaping ([StudentLocationData]?, Error?) -> Void) {
        ParseAPI.getRequestTask(url: UdacityAPI.Endpoints.getStudentLocation.url, responseType: AllLocations.self) { (completionResponse, error) in
            if let response = completionResponse {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }

    class func addNewLocation(locationData: StudentLocationData, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(locationData.uniqueKey ?? "")\", \"firstName\": \"\(locationData.firstName)\", \"lastName\": \"\(locationData.lastName)\",\"mapString\": \"\(locationData.mapString)\", \"mediaURL\": \"\(locationData.mediaURL)\",\"latitude\": \(locationData.latitude), \"longitude\": \(locationData.longitude)}"
        ParseAPI.postRequestTask(url: UdacityAPI.Endpoints.addNewLocation.url, responseType: PostNewStudentLocation.self, body: body, completion: {(completionResponse, error) in
            if let response = completionResponse {
                if response.createdAt != nil {
                    UdacityAPI.Auth.objectId = response.objectId ?? ""
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        })
    }

    class func updateLocation(locationData: StudentLocationData, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(locationData.uniqueKey ?? "")\", \"firstName\": \"\(locationData.firstName)\", \"lastName\": \"\(locationData.lastName)\",\"mapString\": \"\(locationData.mapString)\", \"mediaURL\": \"\(locationData.mediaURL)\",\"latitude\": \(locationData.latitude), \"longitude\": \(locationData.longitude)}"
        ParseAPI.postRequestTask(url: UdacityAPI.Endpoints.updateLocation.url, responseType: UpdateStudentLocation.self, body: body, completion: {(completionResponse, error) in
            if let response = completionResponse {
                if response.updateAt != nil {
                    completion(true, nil)
                } else {
                    completion(false, nil)
                }
            }
        })
    }

    class func getRequestTask<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }

            }
        }
        task.resume()
    }

    class func postRequestTask<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.httpBody = body.data(using: String.Encoding.utf8)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
