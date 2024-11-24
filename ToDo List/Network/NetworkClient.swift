//
//  NetworkClient.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 23.11.2024.
//

import Foundation

private enum NetworkClientErrors: Error {
    case requestCreationFailure
    case requestFail(Error)
    case wrongServerResponce(String)
    case wrondData
    case JSONDecodeError(Error)
}

final class NetworkClient {
    
    // MARK: - Public Properties
    static let networkClient = NetworkClient()
    var task: URLSessionTask?
    
    // MARK: - Public methods
    func loadToDos(requestUrl: String, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            debugPrint("CONSOLE func loadNewPage: Отмена повторного сетевого запроса.")
            return
        }
        
        let task = objectTask(for: requestUrl) {[weak self] (result: Result<ToDos, Error>) in
            DispatchQueue.main.async {
                if let self {
                    self.task = nil
                    switch result {
                    case .success(let data):
                        var newItems: [ToDoItem] = []
                        for item in data.todos {
                            newItems.append(.init(id: UUID(),
                                                  status: item.completed,
                                                  title: "No title", //String(item.id),
                                                  description: item.todo,
                                                  date: Date())
                            )
                        }
                        completion(
                            .success(newItems)
                        )
                    case .failure(let error):
                        debugPrint("CONSOLE func loadNewPage:", error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
        }
        self.task = task
    }
    
    /// функция сетевого запроса
    func objectTask<T: Decodable>( for request: String, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: URL(string: request)!) { (data, response, error) -> Void in
            
            if let error = error {
                
                completion(.failure(NetworkClientErrors.requestFail(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkClientErrors.wrongServerResponce("Код ответа сервера: \(response.statusCode)")))
                return
            }
            
            guard let data = data
            else {
                completion(.failure(NetworkClientErrors.wrondData))
                return
            }
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkClientErrors.JSONDecodeError(error)))
                return
            }
        }
        
        task.resume()
        return task
    }
}
