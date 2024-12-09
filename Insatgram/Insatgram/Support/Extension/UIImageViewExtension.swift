//
//  UIImageViewExtension.swift
//  Insatgram
//
//  Created by Apple on 23.11.24.
//

import UIKit

extension UIImageView{

    func imageFrom(url:URL){

        DispatchQueue.global().async { [weak self] in

            if let data = try? Data(contentsOf: url){

                if let image = UIImage(data:data){

                    DispatchQueue.main.async{

                        self?.image = image

                    }

                }

            }

        }

    }

}

//newsImageView.imageFrom(url: URL(string: article.urlToImage)!)
 
