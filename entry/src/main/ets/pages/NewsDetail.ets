import { webview } from '@kit.ArkWeb';
import { News } from '../model/news'

@Entry
@Component
struct NewsDetail {
  private controller: WebviewController = new webview.WebviewController()
  @State localUrl: string = ''

  aboutToAppear(): void {

    let res: News = this.getUIContext().getRouter().getParams() as News
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