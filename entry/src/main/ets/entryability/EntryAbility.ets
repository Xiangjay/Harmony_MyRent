import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { preferencesUtil } from '../common/utils/PreferencesUtils';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    /*
       * 设置窗口全屏
       * 1. 获取应用主窗口并设置窗口全屏
       * 2. 获取布局避让遮挡的区域
       * 3. 注册监听函数，动态获取避让区域数据
      */
    // 获取应用主窗口
    const windowClass: window.Window = windowStage.getMainWindowSync();
    // 1. 设置窗口全屏
    windowClass.setWindowLayoutFullScreen(true)
    // 2. 获取布局避让遮挡的区域
    const top = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height
    AppStorage.setOrCreate<number>('safeTop', px2vp(top));
    const bottom = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height
    AppStorage.setOrCreate<number>('safeBottom', px2vp(bottom));
    // 3. 注册监听函数，动态获取避让区域数据
    windowClass.on('avoidAreaChange', (data) => {
      if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
        let top = data.area.topRect.height;
        AppStorage.setOrCreate<number>('safeTop', px2vp(top));
      } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
        let bottom = data.area.bottomRect.height;
        AppStorage.setOrCreate<number>('safeBottom', px2vp(bottom));
      }
    });
    // 设置状态栏文字颜色
    windowClass.setWindowSystemBarProperties({
      statusBarContentColor: '#ffffff'
    })
    // 设置顶部状态栏隐藏
    // windowClass.setSpecificSystemBarEnabled('status', false)
    // 设置底部导航条隐藏
    windowClass.setSpecificSystemBarEnabled('navigationIndicator', false)
    // 保存到全局方便其他页面设置
    AppStorage.setOrCreate('windowClass', windowClass);
    //存一下窗口宽高
    const windowWidth = px2vp(windowClass.getWindowProperties().windowRect.width)
    const windowHeight = px2vp(windowClass.getWindowProperties().windowRect.height)
    AppStorage.setOrCreate<number>('windowWidth', windowWidth);
    AppStorage.setOrCreate<number>('windowHeight', windowHeight);

    windowStage.loadContent('pages/Index', (err) => {
      preferencesUtil.init(this.context, 'MyRentStore')
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}