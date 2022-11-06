//
//  Extension.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import Foundation
import UIKit
import CoreImage

extension UIImageView {
    func loadImage(urlString : String){
        loadImage(urlString: urlString) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    func loadImage(urlString : String, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue(label: "com.boon.queue",qos: .background).async {
            //Form url from the string
            guard let urlPath = URL(string: urlString)?.lastPathComponent else{
                return completion(nil)
            }
            
            //Get document directory
//            let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            
            //Diretory append with file path, return completion nil if invalid file path
            guard let cacheFileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                                            .first?.appendingPathComponent(urlPath) else{
                return completion(nil)
            }
            
            //Get image file from cache folder
            if let image = UIImage(contentsOfFile: cacheFileURL.path) {
                completion(image)
                return
            }
            
            //If image not exist in cache folder, download image
            UIImageView.downloadImage(url: URL(string: urlString)!, fileURL: cacheFileURL) { error in
                if error == nil {
                    let image = UIImage(contentsOfFile: cacheFileURL.path)
                    completion(image)
                }
                else{
                    completion(nil)
                }
            }
            
            
            //Check if file exist, if exist then return the image
//            if FileManager.default.fileExists(atPath: fullURL.path) {
//                let image = UIImage(contentsOfFile: fullURL.path)
//                completion(image)
//            }
//            else{
//                //Download Image from url
//                do{
//                    URLSession.shared.dataTask(with: url) { data, response, error in
//                        if error == nil {
//                            if let data = data {
//                                //Save image data to file
//                                try data.write(to: fullURL)
//
//                                //Response to completion in main thread
//                                let image = UIImage(data: data)
//                                completion(image)
//                            }
//                        }
//                    }
//
//                    guard let data = try? Data(contentsOf: url) else{
//                        return completion(nil)
//                    }
//
//                    //Save image data to file
//                    try data.write(to: fullURL)
//
//                    //Response to completion in main thread
//                    let image = UIImage(data: data)
//                    completion(image)
//                }catch{
//                    print("Error Download Image")
//                    completion(nil)
//                }
//            }
        }
    }
    
    static func downloadImage(url: URL, fileURL: URL, completion: @escaping (_ error: Error?) -> ()){
        let task = URLSession.shared.downloadTask(with: URLRequest(url: url)) { tmpUrl, response, error in
            guard let tmpUrl = tmpUrl else{
                completion(error)
                return
            }
            
            do{
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    try FileManager.default.removeItem(at: fileURL)
                }
                
                try FileManager.default.copyItem(at: tmpUrl, to: fileURL)
                completion(nil)
            }
            catch (let _error){
                completion(_error)
            }
        }
        task.resume()
    }
}

extension UIImage {
    func invertColor() -> UIImage? {
        //create CIImage
        guard let ciImage = CIImage(image: self) else {
            return nil
        }
        
        //create CIFilter
        guard let filter = CIFilter(name: "CIColorInvert") else{
            return nil
        }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        //Convert to CIImage from result of CIFilter
        guard let resultImage = filter.outputImage else {
            return nil
        }
        
        let context = CIContext()
        guard let outputImage = context.createCGImage(resultImage, from: ciImage.extent) else{
            return nil
        }
            
        return UIImage(cgImage: outputImage)
    }
}
