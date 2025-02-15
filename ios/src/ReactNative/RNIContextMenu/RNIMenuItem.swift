//
//  RNIMenuItem.swift
//  IosContextMenuExample
//
//  Created by Dominic Go on 10/23/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit;


@available(iOS 13.0, *)
class RNIMenuItem: RNIMenuElement {
  
  // MARK: - Serialized Properties
  // -----------------------------
  
  var menuTitle: String;
  var icon     : RNIImageItem?;
  
  var menuOptions: [String]?;
  var menuItems  : [RNIMenuElement]?;
  
  // MARK: - Properties
  // ------------------
  
  var shouldUseDiscoverabilityTitleAsFallbackValueForSubtitle = true;
  
  // MARK: - Init
  // ------------

  override init?(dictionary: NSDictionary){
    guard let menuTitle = dictionary["menuTitle"] as? String
    else { return nil };
    
    self.menuTitle = menuTitle;
    super.init(dictionary: dictionary);

    self.menuOptions = dictionary["menuOptions"] as? [String];
    
    self.icon = {
      if let dict = dictionary["icon"] as? NSDictionary {
        
        /// A. `ImageItemConfig` or legacy `IconConfig`
        return RNIImageItem(dict: dict) ??
          RNIMenuIcon.convertLegacyIconConfigToImageItemConfig(dict: dict);
        
      } else if let type  = dictionary["iconType" ] as? String,
                let value = dictionary["iconValue"] as? String {
        
        /// B. legacy `IconConfig`:  icon config shorthand/shortcut  (remove in the future)
        return RNIMenuIcon.convertLegacyIconConfigToImageItemConfig(dict: [
          "iconType" : type,
          "iconValue": value
        ]);
      
      } else if let type  = dictionary["imageType" ] as? String,
                let value = dictionary["imageValue"] as? String {
        
        /// C. legacy `IconConfig`:  old icon config  (remove in the future)
        return RNIMenuIcon.convertLegacyIconConfigToImageItemConfig(dict: [
          "iconType" : type,
          "iconValue": value
        ]);
        
      } else {
        return nil;
      };
    }();
    
    if let menuElements = dictionary["menuItems"] as? NSArray {
      self.menuItems = menuElements.compactMap {
        guard let dictItem = $0 as? NSDictionary else { return nil };
        
        if let menuItem = RNIMenuItem(dictionary: dictItem) {
          #if DEBUG
          print("RNIMenuItem, init - compactMap: Creating RNIMenuItem...");
          #endif
          return menuItem;
          
        } else if let menuAction = RNIMenuActionItem(dictionary: dictItem) {
          #if DEBUG
          print("RNIMenuItem, init - compactMap: Creating RNIMenuActionItem...");
          #endif
          return menuAction;
          
        } else if let deferredElement = RNIDeferredMenuElement(dictionary: dictItem) {
          return deferredElement;
          
        } else {
          #if DEBUG
          print("RNIMenuItem, init - compactMap: nil");
          #endif
          return nil;
        };
      };
    };
  };
};

// MARK: - Computed Properties
// ---------------------------

@available(iOS 13.0, *)
extension RNIMenuItem {
  /// get `UIMenu.Options` from `menuOptions` strings
  var UIMenuOptions: UIMenu.Options {
    UIMenu.Options(
      self.menuOptions?.compactMap {
        UIMenu.Options(string: $0);
      } ?? []
    );
  };
};

// MARK: - Functions
// -----------------

@available(iOS 13.0, *)
extension RNIMenuItem {
  func createMenu(
    actionItemHandler      actionHandler  : @escaping RNIMenuActionItem.ActionItemHandler,
    deferredElementHandler deferredHandler: @escaping RNIDeferredMenuElement.RequestHandler
  ) -> UIMenu {
    
    let menuItems: [UIMenuElement]? = self.menuItems?.compactMap {
      $0.createMenuElement(
        actionItemHandler: actionHandler,
        deferredElementHandler: deferredHandler
      );
    };
    
    return UIMenu(
      title: self.menuTitle,
      image: self.icon?.image,
      identifier: nil,
      options: self.UIMenuOptions,
      children: menuItems ?? []
    );
  };
};

