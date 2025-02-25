import { AccountNewsManager } from '../viewModel/accountNews'
import router from '@ohos.router'
import { NewsDto } from '../database/dto/News/NewsDto'
import { NewsManager } from '../viewModel/news'
import Log from '../utils/Log'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'
import { EmptyComponent } from '../view/components'
import NewsItem from '../view/newsItem'
import { News } from '../model/news'
import Storage from '../preference/Storage'

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
  @State currentUserNews: NewsDto[] = []
  private scroller: Scroller = new Scroller()
  //Preferences
  private localStorage = new Storage()
  @State style: string[] = []
  @State bgColor: string = '#ffffffff'
  @State txtColor: string = '#ff000000'
  @State cardColor: string = '#ffe4f3f3'
  @State authorTimeColor: string = '#56000000'
  @State cateTxtColor: string = '#56000000'
  @State cateBgColor: string = '#fff5f1f1'
  @State searchBarBgColor: string = '#ffffffff'
  @State searchBarPlaceholderColor: string = '#b0918383'
  @State searchBarBorderColor: string = '#46000000'
  @State topBarBgColor: string = '#ffe4f3f3'
  @State isBlack: boolean = false

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
    this.currentUserNews = res.currentUserNews
    Log.info('Test Star', 'About To Appear')
    Log.info('Test Star', res)
    Log.info('Test Star saved news ids: ', this.savedNewsId)
    Log.info('Test Star this.SavedNews: ', this.currentUserNews)
    let temp: string[] = (await this.localStorage.getStyle('style')) as string[]

    if (temp.length !== 0) {
      this.bgColor = temp[temp.length-10]
      this.txtColor = temp[temp.length-9]
      this.cardColor = temp[temp.length-8]
      this.authorTimeColor = temp[temp.length-7]
      this.cateTxtColor = temp[temp.length-6]
      this.cateBgColor = temp[temp.length-5]
      this.searchBarBgColor = temp[temp.length-4]
      this.searchBarPlaceholderColor = temp[temp.length-3]
      this.searchBarBorderColor = temp[temp.length-2]
      this.topBarBgColor = temp[temp.length-1]
      if (this.bgColor == '#ff000000') {
        this.isBlack = true
      } else if (this.bgColor == '#ffffffff') {
        this.isBlack = false
      }
    } else {
      this.isBlack = false
    }
  }

  async showAllNews(email: string) {
    let res = await this.accountNewsManager.getUserNews(email)
    Log.info(Tag, 'user all news:', JSON.stringify(res))
  }

  dtoToNews(dto: NewsDto): News {
    return new News(
      dto.id,
      dto.url,
      dto.language,
      dto.title,
      dto.image,
      dto.published,
      dto.description,
      dto.category,
      dto.author
    )
  }

  build() {
    Column() {
      if (this.currentUserNews.length == 0) {
        EmptyComponent()
      } else {
        Scroll() {
          Column() {
            List({ scroller: this.scroller }) {
              ForEach(this.currentUserNews, (item: NewsDto) => {
                ListItem() {
                  // NewsItem({
                  //   item: this.dtoToNews(dto),
                  //   newsManager: this.newsManager,
                  //   accountNewsManager: this.accountNewsManager,
                  //   currentUserEmail: this.email,
                  //   savedNewsId: $savedNewsId,
                  //   newsDao: this.newsDao,
                  //   currentUserNews: $currentUserNews,
                  //   txtColor: $txtColor,
                  //   authorTimeColor: $authorTimeColor
                  // })
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
        .height('100%')
        .align(Alignment.Top)
        .zIndex(0)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.bgColor)
  }
}