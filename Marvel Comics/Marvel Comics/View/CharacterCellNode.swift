//
//  CharacterCellNode.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CharacterCellNode: ASCellNode {
  
  private var imageNode: ASNetworkImageNode!
  private var nameNode: ASTextNode!
  
  init(with viewModel: CharacterCellViewModel) {
    super.init()
    self.automaticallyManagesSubnodes = true
    setupUI(viewModel)
  }
  
  private func setupUI(_ viewModel: CharacterCellViewModel) {
    imageNode = ASNetworkImageNode()
    
    imageNode.imageModificationBlock = { image in
      return image.makeImageWithRoundedCorners
    }
    
    imageNode.contentMode = .scaleAspectFill
    imageNode.clipsToBounds = true
    imageNode.placeholderFadeDuration = 0.15
    imageNode.shouldRenderProgressImages = true
    imageNode.setURL(viewModel.imageURL, resetToDefault: false)
    
    nameNode = ASTextNode()
    nameNode.attributedText = NSAttributedString.attributed(string: viewModel.name, font: UIFont.systemFont(ofSize: 16, weight: .regular), color: UIColor.darkGray)
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    imageNode.style.preferredSize = CGSize(width: 50, height: 50)
    nameNode.style.alignSelf = .center
    
    let stack = ASStackLayoutSpec.horizontal()
    stack.spacing = 15
    stack.children = [imageNode, nameNode]
    
    let insets = UIEdgeInsetsMake(5, 5, 5, 5)
    return ASInsetLayoutSpec(insets: insets, child: stack)
  }
}
