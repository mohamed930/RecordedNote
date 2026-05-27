//
//  BaseAPI.swift
//  testConnection
//
//  Created by Mohamed Ali on 19/01/2024.
//

import Foundation
import Alamofire
import Combine

struct fileUpload {
    var type: Bool
    var key: String
    var fileType: String?
    var mimeType: String?
    var file: Data
}

class BaseAPI<T:TargetType>: sharedProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    func requestPublisher<M:Codable>(Target:T, ClassName:M.Type) -> Future<M,NSError> {
        
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        let params = buildParams(task: Target.task)
        
        // Create a URLRequest with the desired URL and timeout interval
        var urlRequest = URLRequest(url: URL(string: Target.baseURL.rawValue + Target.path.rawValue)!)
        urlRequest.timeoutInterval = 30/60
        
        urlRequest.method = method
        urlRequest.headers = headers
        ShardCheckConnection.shared.checkNetwork()
        
        
        return Future { [unowned self] promise in
            ShardCheckConnection.shared.connectionStatusObservable.sink(receiveValue: { connection in
                switch connection {
                    
                case .unspecified: break
                    
                case .connected:
                    AF.request(urlRequest.url!, method: method, parameters: params.0,encoding: params.1,headers: headers).responseDecodable(of: M.self) { [weak self] response in
                        guard let self = self else { return }
                        
                        // Use the result of handleResponse here
                        self.handleResponse(Target: Target, ClassName: M.self, response: response).sink { completion in
                            switch completion {
                            case .finished:
                                break // Do nothing for successful completion
                            case .failure(let error):
                                promise(.failure(error))
                            }
                        } receiveValue: { model in
                            promise(.success(model))
                        }.store(in: &self.cancellables)
                    }
                    
                case .disconnected, .error:
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    promise(.failure(error))
                }
            }).store(in: &cancellables)
            
        }
    }
    
    
    func requestPublisherWithFile<M:Codable>(Target:T,file: fileUpload, params: [String: Any]?, ClassName:M.Type) -> Future<M,NSError> {
        let date = Date()
                
        //Set Your URL
        let api_url = Target.baseURL.rawValue + Target.path.rawValue
        let url = URL(string: api_url)!
        
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0 * 1000)
        
        urlRequest.headers = headers
        urlRequest.method = method
    
        urlRequest.httpMethod = Target.method.rawValue
        urlRequest.addValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "mimeType")
        

        //Set File For Upload Data
        let key = file.key
        let fileData = file.file
        
        
        return Future { [unowned self] promise in
            ShardCheckConnection.shared.connectionStatusObservable.sink(receiveValue: { connection in
                switch connection {
                    
                case .unspecified: break
                    
                case .connected:
                    // Now Execute
                AF.upload(multipartFormData: { multiPart in
                    if let params = params {
                        for (key, value) in params {
                            if let temp = value as? String {
                                multiPart.append(temp.data(using: .utf8)!, withName: key )
                            }
                            if let temp = value as? Int {
                                multiPart.append("\(temp)".data(using: .utf8)!, withName: key )
                            }
                            if let temp = value as? Double {
                                multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                            }
                            if let temp = value as? [[String:String]] {
                                
                                var arr = Array<String>()
                                
                                for i in temp {
                                    let dat = try? JSONSerialization.data(withJSONObject: i, options: .prettyPrinted)
                                    
                                    let str = String(data: dat!, encoding: String.Encoding.utf8)
                                    
                                    arr.append(str!)
                                }
                                
                                arr.forEach({element in
                                    let keyObj = key + "[]"
                                    
                                    multiPart.append(element.data(using: .utf8)!, withName: keyObj)
                                })
                                
                            }
                            if let temp = value as? NSArray {
                                temp.forEach({ element in
                                    let keyObj = key + "[]"
                                    if let string = element as? String {
                                        multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                    } else
                                        if let num = element as? Int {
                                            let value = "\(num)"
                                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                    }
                                })
                            }
                        }
                    }
                    
                    
                    if file.type {
                        multiPart.append(fileData, withName: key, fileName:  date.stringDate() + ".jpeg", mimeType: "image/jpeg")
                    }
                    else {
                        multiPart.append(fileData, withName: key, fileName:  date.stringDate() + ".\(file.fileType!)", mimeType: "\(file.mimeType!)")
                    }
                    
                    
                }, with: urlRequest)
                    .responseDecodable(of: M.self) { [weak self] response in
                        guard let self = self else { return }
                        
                        // Use the result of handleResponse here
                        self.handleResponse(Target: Target, ClassName: M.self, response: response).sink { completion in
                            switch completion {
                            case .finished:
                                break // Do nothing for successful completion
                            case .failure(let error):
                                promise(.failure(error))
                            }
                        } receiveValue: { model in
                            promise(.success(model))
                        }.store(in: &self.cancellables)
                }
                    
                case .disconnected, .error:
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    promise(.failure(error))
                }
            }).store(in: &cancellables)
            
        }
    }
    
    
    private func handleResponse<M:Codable>(Target:T,ClassName:M.Type,response: DataResponse<M, AFError>) -> Future<M,NSError> {
        return Future { promise in
            
            switch response.result {
                
            case .success(_):
                guard let theJSONData =  response.data else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    promise(.failure(error))
                    return
                }
                
                if let string = String(data: theJSONData, encoding: .utf8) {
                   print(string) // Prints the string representation of the data
                }
                
                guard let response = try? response.result.get() else {
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    promise(.failure(error))
                    
                    return
                }
                
                promise(.success(response))
                
            case .failure(let e):
                if e.isSessionTaskError,
                   let urlError = e.underlyingError as? URLError,
                   urlError.code == .timedOut {
                    // Handle timeout error
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message2])
                    promise(.failure(error))
                } else {
                    // Handle other errors
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: e.localizedDescription])
                    promise(.failure(error))
                }
            }
        }
        
    }
    
    
    
    private func buildParams(task: ParamsTask) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:] , URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
}
