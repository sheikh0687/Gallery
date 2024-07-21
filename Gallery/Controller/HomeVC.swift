//
//  HomeVC.swift
//  Gallery
//
//  Created by Sheikh Arbaz on 7/20/24.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var gallery_Collection: UICollectionView!
    
    var galleryViewModel = GalleryViewModel()
    
    var array_GalleryImages: [Json_Gallery] = []
    var array_CoreDataImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        gallery_Collection.register(UINib(nibName: "GalleryCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCell")
        fetchPhotos()
    }
    
    @IBAction func btn_Logout(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: k.google.userStatus)
        UserDefaults.standard.removeObject(forKey: k.google.googleClientId)
        UserDefaults.standard.synchronize()
        Switcher.updateRootVC()
    }
}

extension HomeVC {
    
    func fetchPhotos() {
        galleryViewModel.fetchPhotos { [weak self] photos in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
                    self.array_GalleryImages = photos
                } else {
                    Utility.showAlertWithAction(withTitle: "", message: "No internet connection offline mode", delegate: nil, parentViewController: self) { _ in
                        self.galleryViewModel.fetchImagesFromCoreData { [weak self] fetchedImages in
                            self?.array_CoreDataImages = fetchedImages
                            self?.gallery_Collection.reloadData()
                        }
                    }
                }
                self.gallery_Collection.reloadData()
            }
        }
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            return array_GalleryImages.count
        } else {
            return array_CoreDataImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            let obj = self.array_GalleryImages[indexPath.row]
            Utility.setImageWithSDWebImage(obj.image ?? "", cell.gallery_Images)
        } else {
            cell.gallery_Images.image = array_CoreDataImages[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        return CGSize(width: collectionWidth/2, height: 150)
    }
}
