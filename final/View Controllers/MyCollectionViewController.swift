//
//  MyCollectionViewController.swift
//  final
//
//  Created by Mark Hoath on 16/10/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MyCell"

class MyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var array: [MyData] = []

    var imageBorder : CGFloat = 0
    var screenWidth : CGFloat = 0
    var headerHeight : CGFloat = 0
    var tagHeight : CGFloat = 0
    var cellHeight : CGFloat = 0
    var mainPicSize : CGFloat = 0
    var twoImageSize : CGFloat = 0
    var threeImageSize : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPicSize = 45
        imageBorder = 4
        screenWidth = UIScreen.main.bounds.width
        headerHeight = 16 + mainPicSize
        twoImageSize = (screenWidth - imageBorder) / 2
        threeImageSize = (screenWidth - (2 * imageBorder)) / 3

        self.clearsSelectionOnViewWillAppear = false
    
        
        let firstRecord = MyData(name: "Audrey", age: 34, gender: true, tags: ["TheTags", "Very Long Tag", "Short", "This is a Sentence Tag", "Test Height", "Super Tags"],
                    theImages: [ UIImage(named: "pic1")!, UIImage(named: "pic2")!, UIImage(named: "pic3")!, UIImage(named: "pic4")!, UIImage(named: "pic5")!, UIImage(named: "pic6")!] )
        let secondRecord = MyData(name: "Brian", age: 27, gender: false, tags: ["More Tags"], theImages: [UIImage(named: "placeholder")!] )
        
        array.append( firstRecord)
        array.append( secondRecord)
        
        array.sort { $0.name < $1.name }
        
        navigationItem.title = "My Database"
        navigationController?.navigationBar.isTranslucent = false

        self.collectionView?.backgroundColor = .white
        
        // Register cell classes
        self.collectionView!.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDetails))
        navigationItem.rightBarButtonItem = addButton

        // Do any additional setup after loading the view.
    }
    
    @objc func addDetails() {
        
        let detailVC = MyViewController()
        detailVC.delegate = self
        detailVC.mode = .add
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func add(record: MyData) {
        
        array.append(record)
        array.sort { $0.name < $1.name }
        collectionView?.reloadData()
    }
    
    func modify(record: MyData) {
        
        let indexPath = collectionView?.indexPathsForSelectedItems
        
        array.remove(at: indexPath![0].row)
        array.append(record)
        array.sort { $0.name < $1.name }
        collectionView?.reloadData()
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = MyViewController()
        detailVC.delegate = self
        detailVC.mode = .edit
        detailVC.record = array[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return array.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        
        var imageCount = 0
        var tagCount: CGFloat = 0
        var tagTopPos: CGFloat = headerHeight + imageBorder
        var tagLeftPos: CGFloat = imageBorder
        var tagRightPos: CGFloat = imageBorder
        
        tagHeight = calcTagHeight(inc: indexPath.row)
        cell.backgroundColor = .yellow
        cell.nameLabel.text = array[indexPath.row].name
        cell.imageView.image = array[indexPath.row].theImages[0]
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = 8
        
        // Build the Tag List
        
        if !array[indexPath.row].tags.isEmpty {
            for tag in array[indexPath.row].tags {
                let tagLabel = UILabel(frame: CGRect(x: 8, y: 60, width: 200, height: 30))
                cell.addSubview(tagLabel)
                
                let tagLeft = NSLayoutConstraint(item: tagLabel, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: tagLeftPos)
                let tagTop = NSLayoutConstraint(item: tagLabel, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: tagTopPos)
                tagLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.addConstraints([tagLeft, tagTop])

                tagLabel.font = UIFont.systemFont(ofSize: 12.0)
                tagLabel.backgroundColor = .lightGray
                tagLabel.clipsToBounds = true
                tagLabel.layer.cornerRadius = 6.0
                tagLabel.text = "  \(tag)  "
                tagLabel.sizeToFit()
                tagCount += 1
                tagRightPos += imageBorder + tagLabel.frame.width
                
                if tagRightPos > view.bounds.width {
                    tagLeft.isActive = false
                    tagTop.isActive = false
                    tagLeftPos = imageBorder
                    tagTopPos += imageBorder + tagLabel.frame.height
                    tagRightPos = imageBorder + imageBorder + tagLabel.frame.width
                    let tagLeftNew = NSLayoutConstraint(item: tagLabel, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: tagLeftPos)
                    let tagTopNew = NSLayoutConstraint(item: tagLabel, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: tagTopPos)
                    tagLabel.translatesAutoresizingMaskIntoConstraints = false
                    cell.addConstraints([tagLeftNew, tagTopNew])

                }
                tagLeftPos += imageBorder + tagLabel.frame.width
            }
        } else {
            print ("No Tags")
        }
        
        // Build the Photo List
        
        if !array[indexPath.row].theImages.isEmpty {
            for image in array[indexPath.row].theImages {
                if (imageCount < 5) {
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 21))
                    cell.addSubview(imageView)
                    imageView.contentMode = .scaleToFill
                    setImageRect(cell: cell, count: imageCount, imageView: imageView)
                    imageCount += 1
                    imageView.image = image
                } else if imageCount == 5 {
                    let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: threeImageSize, height: threeImageSize))
                    cell.addSubview(label)
                    let labelLeft = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: 2 * threeImageSize + threeImageSize/2 - label.frame.width/2)
                    let labelTop = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: headerHeight + tagHeight + twoImageSize + 2 * imageBorder + threeImageSize/2 - label.frame.height/2)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    cell.addConstraints([labelLeft, labelTop])
                    label.text = "+ \(array[indexPath.row].theImages.count - 4)"
                    label.textColor = .white
                    label.textAlignment = .center
                    label.font = UIFont.boldSystemFont(ofSize: 16.0)
                    imageCount += 1
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellHeight = headerHeight + calcTagHeight(inc: indexPath.row) + imageBorder
        
        let inc = indexPath.row
        
        let numPics = array[inc].theImages.count
        
        if numPics == 0 {       // No Pics
            return(CGSize(width: view.bounds.width, height: cellHeight))
        } else if numPics > 2 { // 3-5 Pics
            cellHeight += 2 * imageBorder + twoImageSize + threeImageSize
            return(CGSize(width: view.bounds.width, height: cellHeight))
        }
        // 1 or 2 Pics
        cellHeight += imageBorder + twoImageSize
        return(CGSize(width: view.bounds.width, height: cellHeight))
    }
    
    func setImageRect(cell: MyCollectionViewCell, count: Int, imageView: UIImageView) {

        switch count {
        case 0:
            let ivLeft = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: 0)
            let ivTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: headerHeight + tagHeight + imageBorder)
            let ivHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: twoImageSize)
            let ivWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: twoImageSize)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints([ivLeft, ivTop, ivHeight, ivWidth])
            
        case 1:
            let ivLeft = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: twoImageSize + imageBorder)
            let ivTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: headerHeight + tagHeight + imageBorder)
            let ivHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: twoImageSize)
            let ivWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: twoImageSize)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints([ivLeft, ivTop, ivHeight, ivWidth])

        case 2:
            let ivLeft = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: 0)
            let ivTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: headerHeight + tagHeight + 2 * imageBorder + twoImageSize)
            let ivHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: threeImageSize)
            let ivWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: threeImageSize)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints([ivLeft, ivTop, ivHeight, ivWidth])

        case 3:
            let ivLeft = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: imageBorder +  threeImageSize )
            let ivTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: headerHeight + tagHeight + 2 * imageBorder + twoImageSize )
            let ivHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: threeImageSize)
            let ivWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: threeImageSize)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints([ivLeft, ivTop, ivHeight, ivWidth])

        case 4:
            let ivLeft = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: 2 * (imageBorder + threeImageSize))
            let ivTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: headerHeight + tagHeight + 2 * imageBorder + twoImageSize )
            let ivHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: threeImageSize)
            let ivWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: threeImageSize)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraints([ivLeft, ivTop, ivHeight, ivWidth])

        default:
            break
        }
    }
    
    func calcTagHeight(inc: Int) -> CGFloat {
        
        var height: CGFloat = 25
        var tagCount: CGFloat = 0
        var tagTopPos: CGFloat = headerHeight + imageBorder
        var tagLeftPos: CGFloat = imageBorder
        var tagRightPos: CGFloat = imageBorder
        
        for tag in array[inc].tags {
            let tagLabel = UILabel(frame: CGRect(x: 8, y: 60, width: 200, height: 30))
            
            tagLabel.font = UIFont.systemFont(ofSize: 12.0)
            tagLabel.clipsToBounds = true
            tagLabel.layer.cornerRadius = 6.0
            tagLabel.text = "  \(tag)  "
            tagLabel.sizeToFit()
            tagCount += 1
            tagRightPos += imageBorder + tagLabel.frame.width
            
            if tagRightPos > view.bounds.width {
                tagLeftPos = imageBorder
                tagTopPos += imageBorder + tagLabel.frame.height
                height += imageBorder + tagLabel.frame.height
                tagRightPos = imageBorder + imageBorder + tagLabel.frame.width
            }
            tagLeftPos += imageBorder + tagLabel.frame.width
        }
        return height
    }
    
}
