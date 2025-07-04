import { window } from '@kit.ArkUI';

interface IScrollParams {
  bgColor: string
  fontColor: string
}

export class handelTopBar {
  windowClass: window.Window = AppStorage.get("windowClass") as window.Window;
  scrollY: number = 0
  topBuilderOpacity: number = 0
  bgColor: string = 'rgba(255,255,255,0)'
  fontColor: string = 'rgba(255,255,255,1)'
  handleScroll = (xOffset: number, yOffset: number): IScrollParams => {
    // yOffset是每次滚动的距离，不是一共的，所以要有个变量给保存起来
    this.scrollY += yOffset
    if (this.scrollY < 10) {
      this.bgColor = 'rgba(255,255,255,0)'
      this.fontColor = 'rgba(255,255,255,1)'
      this.windowClass.setWindowSystemBarProperties({
        statusBarContentColor: '#ffffff'
      });
    } else if (this.scrollY <= 150) {
      this.topBuilderOpacity = (this.scrollY - 10) / (150 - 10)
      this.bgColor = `rgba(255,255,255,${this.topBuilderOpacity})`
      this.fontColor = `rgba(0,0,0,${this.topBuilderOpacity})`
      this.windowClass.setWindowSystemBarProperties({
        statusBarContentColor: '#000000'
      });
    } else {
      this.bgColor = 'rgba(255,255,255,1)'
      this.fontColor = 'rgba(0,0,0,1)'
    }
    return {
      bgColor: this.bgColor,
      fontColor: this.fontColor
    }
  }
}