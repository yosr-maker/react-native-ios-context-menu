import type React from 'react';

import type { TSEventEmitter } from '@dominicstop/ts-event-emitter';

import type { ViewProps } from 'react-native';
import type { OnMenuDidHideEventObject } from 'src/types/MenuEvents';
import type { KeyMapType } from 'src/types/UtilityTypes';

import type { RNIContextMenuViewProps } from '../../native_components/RNIContextMenuView';
import type { MenuElementConfig } from 'src/types/MenuConfig';


export type RenderItem = () => React.ReactElement;

export type DeferredElementProvider = ( 
  deferredID: string, 
  completion: (items: MenuElementConfig[]) => void
) => void;

export type ContextMenuViewBaseProps = Pick<RNIContextMenuViewProps,
  | 'menuConfig'
  | 'previewConfig'
  | 'auxiliaryPreviewConfig'
  | 'shouldUseDiscoverabilityTitleAsFallbackValueForSubtitle'
  | 'isContextMenuEnabled'
  | 'isAuxiliaryPreviewEnabled'
  // Lifecycle Events
  | 'onMenuWillShow'
  | 'onMenuWillHide'
  | 'onMenuWillCancel'
  | 'onMenuDidShow'
  | 'onMenuDidHide'
  | 'onMenuDidCancel'
  | 'onMenuAuxiliaryPreviewWillShow'
  | 'onMenuAuxiliaryPreviewDidShow'
  // `OnPress` Events
  | 'onPressMenuItem'
  | 'onPressMenuPreview'
> & {
  lazyPreview?: boolean;
  useActionSheetFallback?: boolean;
  shouldWaitForMenuToHideBeforeFiringOnPressMenuItem?: boolean;

  onRequestDeferredElement?: DeferredElementProvider;

  renderPreview?: RenderItem;
  renderAuxiliaryPreview?: RenderItem;
};

export type ContextMenuViewProps = 
  ContextMenuViewBaseProps & ViewProps;

export type ContextMenuViewState = {
  menuVisible: boolean;
  mountPreview: boolean;
};

export enum ContextMenuEmitterEvents {
  onMenuDidHide = "onMenuDidHide",
};

export type ContextMenuEmitterEventMap = KeyMapType<ContextMenuEmitterEvents, {
  onMenuDidHide: OnMenuDidHideEventObject['nativeEvent'],
}>

export type NavigatorViewEventEmitter = 
  TSEventEmitter<ContextMenuEmitterEvents, ContextMenuEmitterEventMap>;