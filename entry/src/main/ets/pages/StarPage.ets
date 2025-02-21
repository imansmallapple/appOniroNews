import { AccountNewsManager } from '../methods/accountNews'
import router from '@ohos.router'
import { NewsDto } from '../database/dto/News/NewsDto'
import { NewsManager } from '../methods/news'
import Log from '../utils/Log'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'

interface RouterParams {
  email: string
  accountNewsManager: AccountNewsManager
  newsManager: NewsManager
  savedNewsId: string[]
  newsDao: NewsDaoRdb
  currentUserNews: NewsDto[]
}

const Tag: string = 'Test saved news'

@Entry
@Component
struct StarPage {
  private email: string = ''
  private accountNewsManager!: AccountNewsManager
  private newsManager !: NewsManager
  private newsDao !: NewsDaoRdb
  @State message: string = ''
  @State savedNewsId: string[] = []
  @State SavedNews: NewsDto[] = []
  private scroller: Scroller = new Scroller()
  @State cardColor: string = '#ffe4f3f3'
  @State txtColor: string = '#ff000000'
  @State authorTimeColor: string = '#56000000'

  async getUserAllNews(): Promise<NewsDto[]> {
    try {
      const res: NewsDto[] = await this.newsDao.getAllNews()
      Log.info(Tag, 'User all news:', res)
      return res
    }
    catch (error) {
      Log.error(Tag, 'error: ', JSON.stringify(error))
      return []
    }
  }

  async aboutToAppear(): Promise<void> {
    let res: RouterParams = router.getParams() as RouterParams
    this.email = res.email
    this.accountNewsManager = res.accountNewsManager
    this.savedNewsId = res.savedNewsId
    this.newsDao = res.newsDao
    this.SavedNews = res.currentUserNews
    Log.info('Test Star', 'About To Appear')
    Log.info('Test Star', res)
    Log.info('Test Star saved news ids: ', this.savedNewsId)
    Log.info('Test Star this.SavedNews: ', this.SavedNews)
  }

  async showAllNews(email: string) {
    let res = await this.accountNewsManager.getUserNews(email)
    Log.info(Tag, 'user all news:', JSON.stringify(res))
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          List({ scroller: this.scroller }) {
            ForEach(this.SavedNews, (item: NewsDto) => {
              ListItem() {
                Column() {
                  Column() {
                    Column() {
                      Image(item.image)
                        .width('100%')
                        .objectFit(ImageFit.Contain)
                        .borderRadius({ topLeft: 10, topRight: 10 })
                      Row() {
                        Text(item.title)
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
                        params: item
                      })
                    })
                  }
                  .width('100%')

                  Row({ space: 10 }) {
                    Text(item.author)
                      .fontSize(15)
                      .fontWeight(FontWeight.Normal)
                      .fontColor(this.authorTimeColor)
                      .padding(10)
                  }
                  .justifyContent(FlexAlign.Start)
                  .width('100%')

                  // Description
                  Row() {
                    Text(item.description)
                      .width('100%')
                      .fontColor(this.txtColor)
                  }
                  .padding(10)

                  .width('100%')
                  .height('7%')
                  .justifyContent(FlexAlign.Start)
                  .alignItems(VerticalAlign.Center)
                  .margin({ left: 10 })
                }
                .width('100%')
              }
              .margin({ bottom: 40 })
              .backgroundColor(this.cardColor)
              .borderRadius(10)
            })
          }
          .width('90%')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('92%')
      .align(Alignment.Top)
      .zIndex(0)
    }
    .width('100%')
    .height('100%')
  }
}