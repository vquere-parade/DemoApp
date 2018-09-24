//
//  DownloadContentTask.swift
//  Parade
//
//  Created by Simon Le Bras on 12/09/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import UIKit
import FirebaseStorage
import Zip

class UpdateContentTask {
    weak var delegate: UpdateContentTaskDelegate?
    
    private var downloadTask: StorageDownloadTask?
    
    private lazy var contentPath: URL = {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("content")
    }()
    
    private lazy var contentZipFile: URL = {
       contentPath.appendingPathComponent("content.zip")
    }()
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        queue.name = "Update content queue"
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    func execute() {
        let contentRemoteRef = Bundle.main.infoDictionary?["FIREBASE_CONTENT_LOCATION"] as! String
        
        let pathReference = Storage.storage().reference(withPath: contentRemoteRef)
        
        downloadTask = pathReference.write(toFile: contentZipFile) { [unowned self] url, error in
            if let error = error {
                self.delegate?.didFailUpdatingContent(error: error)
            } else {
                self.unzipContent()
            }
        }
    }
    
    private func unzipContent() {
        operationQueue.addOperation { [weak self] in
            do {
                guard let contentZipFile = self?.contentZipFile, let contentPath = self?.contentPath else {
                    return
                }
                
                try Zip.unzipFile(contentZipFile, destination: contentPath, overwrite: true, password: nil)
                
                
                DispatchQueue.main.async {
                    self?.delegate?.didSuccessUpdatingContent()
                }
            } catch {
                DispatchQueue.main.async {
                    self?.delegate?.didFailUpdatingContent(error: error)
                }
            }
        }
    }
    
    func cancel(){
        downloadTask?.cancel()
        
        operationQueue.cancelAllOperations()
    }
}

protocol UpdateContentTaskDelegate: AnyObject {
    func didSuccessUpdatingContent()
    
    func didFailUpdatingContent(error: Error)
}
