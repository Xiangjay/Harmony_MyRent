import { BasicConstants } from '../constants/BasicConstants';

/*
  * 根据实际设计稿计算元素真正大小，保证元素在不同设备里比例是一样的
*/
const windowWidth: number = AppStorage.get('windowWidth') as number || 360

export function rvp(designValue: number): number {
  return designValue / BasicConstants.DRAFT_WIDTH * windowWidth
}