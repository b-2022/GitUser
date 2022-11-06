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
    func loadImage(urlString : String, completion: @escaping ((UIImage?) -> ())) {
        //Get document directory
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        //Form url from the string
        guard let url = URL(string: urlString) else{
            return completion(nil)
        }
        
        //Get URL last path component to be save as file name
        let urlPath = url.lastPathComponent
        
        //Diretory append with file path, return completion nil if invalid file path
        guard let fullURL = dir?.appendingPathComponent(urlPath) else{
            return completion(nil)
        }
        
        //Check if file exist, if exist then return the image
        if FileManager.default.fileExists(atPath: fullURL.path) {
            let image = UIImage(contentsOfFile: fullURL.path)
            completion(image)
        }
        else{
            //Download Image from url in background thread
            DispatchQueue.global().async {
                do{
                    guard let data = try? Data(contentsOf: url) else{
                        return completion(nil)
                    }
                    
                    //Save image data to file
                    try data.write(to: fullURL)
                    
                    //Response to completion in main thread
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        completion(image)
                    }
                }catch{
                    print("Error Download Image")
                    completion(nil)
                }
                
            }
        }
    }
}

extension UIImage {
    func invertColor() -> UIImage? {
        //create CIImage
        let ciImage = CIImage(image: self)
        
        //create CIFilter
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        //Convert to CIImage from result of CIFilter
        if let resultFilter = filter?.outputImage {
            let invertedImage = UIImage(ciImage: resultFilter)
            return invertedImage
        }
        
        return nil
    }
}
