import { News } from '../model/news'
import { timeFormatModify } from '../utils/timeUtil'
import router from '@ohos.router'
import { AccountNewsManager } from '../methods/accountNews'
import { NewsManager } from '../methods/news'
import { AccountNewsDto } from '../database/dto/AccountNews/AccountNewsDto'
import promptAction from '@ohos.promptAction'
import Log from '../utils/Log'

const Tag = 'Test NewsItem'

@Component
export default struct NewsItem {
  private item!: News
  @State isStared: boolean = false
  @State authorTimeColor: string = '#56000000'
  @State txtColor: string = '#ff000000'
  private accountNewsManager!: AccountNewsManager
  private newsManager!: NewsManager
  private currentUserEmail!: string
  @Link savedNewsId: string[]

  async aboutToAppear(): Promise<void> {
    let res = await this.accountNewsManager.getUserNews(this.currentUserEmail)
    this.savedNewsId = res
  }

  async saveNews(email: string, id: string) {
    this.accountNewsManager.addUserNews(email, id)
    let res = await this.accountNewsManager.getUserNews(email)
    Log.info(Tag, 'user all news:', JSON.stringify(res))
    this.savedNewsId = res
    Log.info(Tag, 'savedNewsId:', JSON.stringify(this.savedNewsId))
  }

  build() {
    Column() {
      Column() {
        Column() {
          Image(this.item.image)
            .width('100%')
            .objectFit(ImageFit.Contain)
            .borderRadius({ topLeft: 10, topRight: 10 })
          Row() {
            Text(this.item.title)
              .fontSize(20)
              .fontWeight(700)
              .fontColor(this.txtColor)
          }
          .width('100%')
          .padding(10)
        }
        .onClick(() => {
          router.pushUrl({
            url: "pages/NewsDetail",
            params: this.item
          })
        })
      }
      .width('100%')

      Row({ space: 10 }) {
        Text(this.item.author)
          .fontSize(15)
          .fontWeight(FontWeight.Normal)
          .fontColor(this.authorTimeColor)
          .padding(10)
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')

      // Description
      Row() {
        Text(this.item.description)
          .width('100%')
          .fontColor(this.txtColor)
      }
      .padding(10)

      Row({ space: 10 }) {
        Image(this.isStared ? $r('app.media.icon_stared') : $r('app.media.icon_not_stared'))
          .width(25)
          .onClick(() => {
            this.isStared = !this.isStared
            // todo: Implement user save functionality
            this.saveNews(this.currentUserEmail, this.item.id)
            Log.info(Tag, 'add email:', this.currentUserEmail)
            Log.info(Tag, 'add news id:', this.item.id)
            promptAction.showToast({
              message: "News saved!"
            })
          })
        Image($r('app.media.icon_link'))
          .width(20)

        Row() {
          Text(timeFormatModify(this.item.published))
            .fontSize(15)
            .fontColor(this.authorTimeColor)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.End)
        .padding(10)
      }
      .width('100%')
      .height('7%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .margin({ left: 10 })
    }
    .width('100%')
  }
}