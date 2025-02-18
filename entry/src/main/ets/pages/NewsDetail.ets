import webview from '@ohos.web.webview'
import router from '@ohos.router'
import hilog from '@ohos.hilog'
import { News } from '../model/news'

@Entry
@Component
struct NewsDetail {
  private controller: WebviewController = new webview.WebviewController()
  @State localUrl: string = ''

  aboutToAppear(): void {
    let res: News = router.getParams() as News
    // hilog.info(0x00, 'localUrl', JSON.stringify(res))
    this.localUrl = res.url
  }

  build() {
    Column() {
      Web({ src: this.localUrl, controller: this.controller })
        .width('100%')
        .height('110%')
        .padding({ bottom: 56 })
        .javaScriptAccess(true)
        .fileAccess(true)
        .domStorageAccess(true)
        .zoomAccess(true)
    }
    .width('100%')
    .height('91%')
    .backgroundColor(Color.Black)
  }
}