//
//  DetailHeaderNode.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class DetailHeaderNode: ASDisplayNode {
  
  private var imageNode: ASNetworkImageNode!
  private var titleNode: ASTextNode!
  private var descriptionNode: ASTextNode?
  
  init(with viewModel: DetailHeaderViewModel) {
    super.init()
    self.automaticallyManagesSubnodes = true
    setupUI(viewModel)
  }
  
  private func setupUI(_ viewModel: DetailHeaderViewModel) {
    imageNode = ASNetworkImageNode()
    imageNode.contentMode = .scaleAspectFill
    imageNode.clipsToBounds = true
    imageNode.placeholderFadeDuration = 0.15
    imageNode.shouldRenderProgressImages = true
    imageNode.setURL(viewModel.imageURL, resetToDefault: false)
    
    titleNode = ASTextNode()
    titleNode.attributedText = NSAttributedString.attributed(string: viewModel.title, font: UIFont.systemFont(ofSize: 24, weight: .medium), color: UIColor.darkText)
    
    if let descriptionText = viewModel.description {
      descriptionNode = ASTextNode()
      descriptionNode?.attributedText = NSAttributedString.attributed(string: descriptionText, font: UIFont.systemFont(ofSize: 12, weight: .regular), color: UIColor.darkGray)
    }
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    imageNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 250)
    
    let textStack = ASStackLayoutSpec.vertical()
    textStack.spacing = 12
    textStack.alignContent = .stretch
    textStack.justifyContent = .spaceBetween
    textStack.children = descriptionNode != nil ? [titleNode, descriptionNode!] : [titleNode]
    
    let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    let textStackWithInsets = ASInsetLayoutSpec(insets: insets, child: textStack)
    
    let stack = ASStackLayoutSpec.vertical()
    stack.justifyContent = .spaceBetween
    stack.children = [imageNode, textStackWithInsets]
    stack.style.flexGrow = 1.0
    stack.style.flexShrink = 1.0
    
    return stack
  }
}
