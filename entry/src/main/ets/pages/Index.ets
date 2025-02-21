import { DataSource } from '../data/DataSource'
import { NewsResponse, News } from '../model/news'
import { CategoryResponse } from '../model/categories'
import router from '@ohos.router'
import { timeFormatModify } from '../utils/timeUtil'
import { HttpErrorComponent, LoadComponent } from '../component/components'
import Storage from '../preference/Storage'
import common from '@ohos.app.ability.common'
import NewsItem from '../component/newsItem'
import { runAccountOperations } from '../methods/account'
import { NewsManager, runNewsOperations } from '../methods/news'
import { AccountNewsManager } from '../methods/accountNews'
import Log from '../utils/Log'
import { OniroNewsDB } from '../database/OniroNewsDB'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'
import { NewsDto } from '../database/dto/News/NewsDto'

let context = getContext(this) as common.UIAbilityContext;

interface RouterParams {
  email: string
  username: string
}

@Entry
@Component
struct Index {
  @State latestNews: News[] = []
  @State categories: string[] = []
  @State isHttpError: boolean = false
  @State isLoading: boolean = false
  @State httpCode: number = 0
  @State retryButtonColor: string = ''
  private source = new DataSource()
  // List
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
  // auth
  @State isUserExist: boolean = false
  // database
  private newsManager: NewsManager = new NewsManager(context)
  private accountNewsManager: AccountNewsManager = new AccountNewsManager(context)
  private dbInstance!: OniroNewsDB
  private newsDao!: NewsDaoRdb
  // user info
  // todo: unblock it later
  // @State email: string = ''
  private email: string = 'alf138540fun@gmail.com'
  @State savedNewsId: string[] = []
  @State currentUserNews: NewsDto[] = []

  async getUserNews(id: string): Promise<NewsDto> {
    let res: NewsDto[] = await this.newsDao.getNewsById(id)
    let toPush: NewsDto = res.pop() as NewsDto
    Log.info('check getUserNews', `get news with id ${id}:`, toPush)
    this.currentUserNews.push(toPush)
    Log.info('check getUserNews', `check currnet user news list:`, this.currentUserNews)
    return res.pop() as NewsDto
  }

  async aboutToAppear(): Promise<void> {
    // runNewsOperations(context)
    this.dbInstance = await OniroNewsDB.getInstance(context)
    this.newsDao = new NewsDaoRdb(this.dbInstance)
    Log.info('test render', this.dbInstance, this.newsDao)
    Log.info('saved news id', this.savedNewsId)
    // todo: Unblock it later
    // let res: RouterParams = router.getParams() as RouterParams
    // this.email = res.email
    let temp: string[] = (await this.localStorage.getStyle('style')) as string[]

    this.isLoading = true
    this.source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code === 200) {
        this.isLoading = false
        this.isHttpError = false
        let res1: NewsResponse = await this.source.getLatestNews('en')
        this.latestNews = res1.news
        let res2: CategoryResponse = await this.source.getCategories()
        this.categories = res2.categories

        let res3 = await this.accountNewsManager.getUserNews(this.email)
        this.savedNewsId = res3
        Log.info('test string res3', res3)
        Log.info('test string res3 savedNewsId', this.savedNewsId)

        this.savedNewsId.forEach((id: string) => {
          this.getUserNews(id)
        })
      } else {
        this.isLoading = false
        this.isHttpError = true
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })

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

  // async onPageShow(): Promise<void> {
  //   let res2 = await this.accountNewsManager.getUserNews(this.email)
  //   Log.info('test string res2', res2)
  // }

  async getCategorizedLatestNews(language: string, category: string) {
    let res: NewsResponse = await this.source.getLatestNews(language, category)
    this.latestNews = res.news
  }

  @Builder
  floatIconBuilder(icon: Resource, callback?: () => void) {
    Row() {
      Image(icon)
        .width(20)
        .height(20)
        .zIndex(1)
        .objectFit(ImageFit.Contain)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#33000000')
    .borderRadius(30)
    .width(45)
    .height(45)
    .margin({
      right: 10,
      bottom: 5
    })
    .backdropBlur(20)
    .onClick(callback)
  }

  build() {
    if (this.isHttpError) {
      if (this.isLoading) {
        Column() {
          LoadComponent()
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      else {
        Stack() {
          HttpErrorComponent()
          Column() {
            Text('Retry')
              .fontSize(25)
              .fontWeight(700)
          }
          .width('20%')
          .height(50)
          .zIndex(1)
          .margin({ top: '30%' })
          .borderWidth(2)
          .borderRadius(20)
          .justifyContent(FlexAlign.Center)
          .onTouch((event: TouchEvent) => {
            if (event.type == TouchType.Down) {
              this.retryButtonColor = '#68e7dada'
            }
            if (event.type == TouchType.Up) {
              this.retryButtonColor = ''
            }
          })
          .backgroundColor(this.retryButtonColor)
          .onClick(() => {
            this.isLoading = true
            this.source.fetchHttpCode().then(async (code) => {
              this.httpCode = code
              if (code === 200) {
                this.isLoading = false
                this.isHttpError = false
                let res1: NewsResponse = await this.source.getLatestNews('en')
                this.latestNews = res1.news
                let res2: CategoryResponse = await this.source.getCategories()
                this.categories = res2.categories
              } else {
                this.isLoading = false
                this.isHttpError = true
                console.error('Failed to fetch data: HTTP Code', code);
              }
            })
          })
        }
        .width('100%')
        .height('100%')
        .align(Alignment.Center)
      }
    }
    else {
      if (this.isLoading) {
        Column() {
          LoadComponent()
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        Stack() {
          Column() {
            Row() {
              Column() {
                Text(`Hi! ${this.email}`)
                  .fontSize(20)
                  .fontWeight(500)
                  .fontColor(this.txtColor)
              }
              .width('80%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 20 })
            }
            .width('100%')
            .height('7%')
            .backgroundColor(this.cardColor)

            Row({ space: 10 }) {
              List() {
                ForEach(this.categories, (item: string) => {
                  ListItem() {
                    Column() {
                      Text(item)
                        .fontWeight(600)
                        .fontSize(20)
                        .fontColor(this.txtColor)
                    }
                    .width('40%')
                    .height('100%')
                    .justifyContent(FlexAlign.Center)
                  }
                  .onClick(() => {
                    this.getCategorizedLatestNews('en', item)
                  })
                })
              }
              .listDirection(Axis.Horizontal)
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .height('7%')
            .zIndex(0)
            .margin({ bottom: 5 })
            .backgroundColor(this.cardColor)

            Scroll() {
              Column() {
                List({ scroller: this.scroller }) {
                  ForEach(this.latestNews, (item: News) => {
                    ListItem() {
                      NewsItem({
                        item: item,
                        newsManager: this.newsManager,
                        accountNewsManager: this.accountNewsManager,
                        currentUserEmail: this.email,
                        savedNewsId: $savedNewsId,
                        newsDao: this.newsDao,
                        currentUserNews: $currentUserNews,
                        txtColor: $txtColor,
                        authorTimeColor: $authorTimeColor
                      })
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
            .height('85%')
            .align(Alignment.Top)
            .zIndex(0)
          }
          .width('100%')
          .height('100%')

          Column() {
            this.floatIconBuilder($r('app.media.icon_daymode'), () => {
              // this.smoothScrollToTop()
              this.isBlack = !this.isBlack
              if (this.isBlack == true) {
                //Dark Mode
                this.bgColor = "#ff000000"
                this.txtColor = "#ffffffff"
                this.cardColor = "#ff3b3a3a"
                this.authorTimeColor = '#d3e0d8d8'
                this.cateTxtColor = '#b0ffffff'
                this.cateBgColor = '#b0514f4f'
                this.searchBarBgColor = '#c8181818'
                this.searchBarPlaceholderColor = '#b0ffffff'
                this.searchBarBorderColor = '#46dbcece'
                this.topBarBgColor = '#ff1c1b1b'
                this.style.push(this.bgColor)
                this.style.push(this.txtColor)
                this.style.push(this.cardColor)
                this.style.push(this.authorTimeColor)
                this.style.push(this.cateTxtColor)
                this.style.push(this.cateBgColor)
                this.style.push(this.searchBarBgColor)
                this.style.push(this.searchBarPlaceholderColor)
                this.style.push(this.searchBarBorderColor)
                this.style.push(this.topBarBgColor)
                this.localStorage.setStyle('style', this.style)
              } else {
                //Light Mode
                this.bgColor = "#ffffffff"
                this.txtColor = "#ff000000"
                this.cardColor = "#ffe4f3f3"
                this.authorTimeColor = '#56000000'
                this.cateTxtColor = '#56000000'
                this.cateBgColor = '#fff5f1f1'
                this.searchBarBgColor = '#ffffff'
                this.searchBarPlaceholderColor = '#b0918383'
                this.searchBarBorderColor = '#46000000'
                this.topBarBgColor = '#ffe4f3f3'
                this.style.push(this.bgColor)
                this.style.push(this.txtColor)
                this.style.push(this.cardColor)
                this.style.push(this.authorTimeColor)
                this.style.push(this.cateTxtColor)
                this.style.push(this.cateBgColor)
                this.style.push(this.searchBarBgColor)
                this.style.push(this.searchBarPlaceholderColor)
                this.style.push(this.searchBarBorderColor)
                this.style.push(this.topBarBgColor)
                this.localStorage.setStyle('style', this.style)
              }
            })
            this.floatIconBuilder($r('app.media.icon_stared'), () => {
              router.pushUrl({
                url: 'pages/StarPage',
                params: {
                  email: this.email,
                  accountNewsManager: this.accountNewsManager,
                  newsManager: this.newsManager,
                  savedNewsId: this.savedNewsId,
                  newsDao: this.newsDao,
                  currentUserNews: this.currentUserNews
                }
              })
            })
            this.floatIconBuilder($r('app.media.icon_search'), () => {
              router.pushUrl({
                url: 'pages/SearchPage'
              })
            })
          }
          .margin({ right: 10, bottom: 10 })
        }
        .width('100%')
        .height('100%')
        .align(Alignment.BottomEnd)
        .backgroundColor(this.bgColor)
      }
    }
  }
}