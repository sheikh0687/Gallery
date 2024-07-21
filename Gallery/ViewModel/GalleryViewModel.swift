//
//  GalleryViewModel.swift
//  Gallery
//
//  Created by Sheikh Arbaz on 7/21/24.
//

import Foundation

import CoreData

class GalleryViewModel {
    
    private var fetchedResultsController: NSFetchedResultsController<ProfileEntity>?
    
    func fetchPhotos(completion: @escaping ([Json_Gallery]) -> Void) {
        guard let url = URL(string: "https://api.escuelajs.co/api/v1/categories") else {
            print("Invalid URL")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching photos: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Json_Gallery].self, from: data)
                self.savePhotosToCoreData(photos)
                DispatchQueue.main.async {
                    completion(photos)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
    
    func savePhotosToCoreData(_ photos: [Json_Gallery]) {
        let context = CoreDataStack.shared.viewContext
        
        context.perform {
            for photo in photos {
                let imageEntity = ProfileEntity(context: context)
                imageEntity.imageURL = photo.image
                
                do {
                    try context.save()
                } catch {
                    print("Error saving image entity to Core Data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchImagesFromCoreData(completion: @escaping ([UIImage]) -> Void) {
        let context = CoreDataStack.shared.viewContext
        let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        
        context.perform {
            do {
                let imageEntities = try context.fetch(fetchRequest)
                var images: [UIImage] = []
                
                for entity in imageEntities {
                    if let urlString = entity.imageURL, let url = URL(string: urlString) {
                        if let imageData = entity.image, let image = UIImage(data: imageData) {
                            images.append(image)
                        } else {
                            URLSession.shared.dataTask(with: url) { data, response, error in
                                if let data = data, let image = UIImage(data: data) {
                                    images.append(image)
                                }
                                DispatchQueue.main.async {
                                    completion(images)
                                }
                            }.resume()
                        }
                    }
                }
            
                DispatchQueue.main.async {
                    completion(images)
                }
                
            } catch {
                print("Error fetching images from Core Data: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
