//
//  ComicCellNode.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ComicCellNode: ASCellNode {
  
  private let imageNode = ASNetworkImageNode()
  
  required init(with viewModel: ComicCellViewModel) {
    super.init()
    self.automaticallyManagesSubnodes = true
    
    imageNode.imageModificationBlock = { image in
      return image.makeImageWithRoundedCorners
    }
    
    imageNode.setURL(viewModel.imageURL, resetToDefault: false)
    imageNode.contentMode = .scaleAspectFill
    imageNode.clipsToBounds = true
    imageNode.placeholderFadeDuration = 0.15
    imageNode.shouldRenderProgressImages = true
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    imageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height)
    
    let stackLayout = ASStackLayoutSpec.vertical()
    stackLayout.justifyContent = .center
    stackLayout.alignItems = .center
    stackLayout.child = imageNode
    
    let insets = UIEdgeInsetsMake(5, 5, 5, 5)
    
    return  ASInsetLayoutSpec(insets: insets, child: stackLayout)
  }
}
