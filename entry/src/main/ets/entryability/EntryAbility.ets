import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { util } from '@kit.ArkTS';
import Log from '../utils/Log';
let dataPreferences: preferences.Preferences | null = null;
let Tag: string = 'onWindowStageCreate'

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    //获取Preferences实例。
    let options: preferences.Options = {
      name: 'myStore'
    };
    dataPreferences = preferences.getPreferencesSync(this.context, options);
    if (dataPreferences.hasSync('startup')) {
      Log.info(Tag, "The key 'startup' is contained.");
    } else {
      Log.info(Tag, "The key 'startup' does not contain.");
      // 此处以此键值对不存在时写入数据为例
      dataPreferences.putSync('startup', 'auto');
      // 当字符串有特殊字符时，需要将字符串转为Uint8Array类型再存储，长度均不超过16 * 1024 * 1024个字节。
      let uInt8Array1 = new util.TextEncoder().encodeInto("~！@#￥%……&*（）——+？");
      dataPreferences.putSync('uInt8', uInt8Array1);
    }
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Login', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
