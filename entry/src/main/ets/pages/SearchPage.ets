import { DataSource } from '../data/DataSource'
import { News, NewsResponse } from '../model/news'
import router from '@ohos.router'
import { timeFormatModify } from '../utils/timeUtil'
import Log from '../utils/Log'
import { Callback } from '@ohos.base'
import { LoadComponent, EmptyComponent } from '../component/components'
import { spaceToPlus } from '../utils/searchUtil'
import Storage from '../preference/Storage'
import NewsItem from '../component/newsItem'
import { AccountNewsManager } from '../methods/accountNews'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'
import { NewsDto } from '../database/dto/News/NewsDto'
import { OniroNewsDB } from '../database/OniroNewsDB'
import common from '@ohos.app.ability.common'

interface RouterParams {
  currentUserEmail: string,
  savedNewsId: string[],
  currentUserNews: NewsDto[],
  txtColor: string,
  authorTimeColor: string
}
let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct SearchPage {
  // Search
  @State searchValue: string = ''
  @State isSearched: boolean = false
  @State @Watch('checkLoading') searchedNews: News[] = []
  private searchController: SearchController = new SearchController()
  private source = new DataSource()
  private searchResultCategory: string[] = ['news', 'articles', 'discussion']
  // Category
  @State newsCount: number = 0
  @State articlesCount: number = 0
  @State discussionCount: number = 0
  @State cate1TextColor: string = '#56000000'
  @State cate2TextColor: string = '#56000000'
  @State cate3TextColor: string = '#56000000'
  @State cate1TextFont: number = FontWeight.Medium
  @State cate2TextFont: number = FontWeight.Medium
  @State cate3TextFont: number = FontWeight.Medium
  @State cate1BgColor: string = '#ffe4f3f3'
  @State cate2BgColor: string = '#ffe4f3f3'
  @State cate3BgColor: string = '#ffe4f3f3'
  @State searchButtonColor: string = ''
  @State backButtonColor: string = ''
  @State isLoading: boolean = false
  @State isEmpty: boolean = false
  @State @Watch('checkLoading') searchNewsLen: number = 0
  @State isCateSelected: boolean = false
  @State isTouch: boolean = false
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
  //router params
  private accountNewsManager: AccountNewsManager = new AccountNewsManager(context)
  private currentUserEmail!: string
  @State savedNewsId: string[] = []
  private newsDao!: NewsDaoRdb
  @State currentUserNews: NewsDto[] = []
  private dbInstance!: OniroNewsDB

  async onPageShow(): Promise<void> {
    Log.info('onpageshow search', this.currentUserNews)
  }


  async aboutToAppear(): Promise<void> {
    Log.info('onpageshow abouttoappear', this.currentUserNews)
    this.dbInstance = await OniroNewsDB.getInstance(context)
    this.newsDao = new NewsDaoRdb(this.dbInstance)
    let res: RouterParams = router.getParams() as RouterParams
    this.currentUserEmail = res.currentUserEmail
    this.savedNewsId = res.savedNewsId
    this.currentUserNews = res.currentUserNews

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
      if (temp[temp.length-10] == '#ff000000') {
        this.isBlack = true
      } else if (temp[temp.length-10] == '#ffffffff') {
        this.isBlack = false
      }
    } else {
      this.isBlack = false
    }
    Log.info('isBlack', this.isBlack)
  }

  async searchNews(keyword: string) {
    let res: NewsResponse = await this.source.searchNews('en', keyword, 1)
    this.searchNewsLen = this.searchedNews.length
    this.searchedNews = res.news
    this.newsCount = res.news.length

    if (this.newsCount == 0) {
      this.isEmpty = true
    } else {
      this.isEmpty = false
    }
  }

  async searchArticles(keyword: string) {
    let res: NewsResponse = await this.source.searchNews('en', keyword, 2)
    this.searchedNews = res.news
    this.searchNewsLen = this.searchedNews.length
    this.articlesCount = res.news.length

    if (this.articlesCount == 0) {
      this.isEmpty = true
    } else {
      this.isEmpty = false
    }
  }

  async searchDiscussion(keyword: string) {
    let res: NewsResponse = await this.source.searchNews('en', keyword, 3)
    this.searchedNews = res.news
    this.searchNewsLen = this.searchedNews.length
    this.discussionCount = res.news.length

    if (this.discussionCount == 0) {
      this.isEmpty = true
    } else {
      this.isEmpty = false
    }
  }

  async loadSearchCategoryCounts(keyword: string) {
    // this.isLoading = true
    let c1: NewsResponse = await this.source.searchNews('en', keyword, 1)
    let c2: NewsResponse = await this.source.searchNews('en', keyword, 2)
    let c3: NewsResponse = await this.source.searchNews('en', keyword, 3)
    this.newsCount = c1.news.length
    this.articlesCount = c2.news.length
    this.discussionCount = c3.news.length
  }

  checkLoading() {
    Log.info('Loading', 'List length changed')
    this.isLoading = false
  }

  build() {
    Column() {
      Row({ space: 5 }) {
        Row() {
          Image(this.isBlack ? $r('app.media.icon_back_white') : $r('app.media.icon_back_black'))
            .width(20)
        }
        .width(30)
        .height(30)
        .borderRadius(20)
        .margin({ left: 5 })
        .onTouch((event: TouchEvent) => {
          if (event.type == TouchType.Down) {
            this.backButtonColor = this.cateBgColor
          }
          if (event.type == TouchType.Up) {
            this.backButtonColor = ''
          }
        })
        .onClick(() => {
          router.back()
        })
        .backgroundColor(this.backButtonColor)

        Search({
          value: this.searchValue,
          placeholder: 'Search',
          controller: this.searchController
        })
          .focusable(true)
          .width('75%')
          .height(40)
          .backgroundColor(this.searchBarBgColor)
          .placeholderColor(this.searchBarPlaceholderColor)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .borderColor(this.searchBarBorderColor)
          .borderWidth(2)
          .fontColor(this.txtColor)
          .onChange((value: string) => {
            this.searchValue = value
          })
          .onSubmit(() => {
            this.isSearched = true
            this.isLoading = true
            this.searchNews(spaceToPlus(this.searchValue))
            this.loadSearchCategoryCounts(spaceToPlus(this.searchValue))
          })

        Row() {
          Text('Search')
            .fontSize(18)
            .fontColor('#fffa6f6f')
            .fontWeight(FontWeight.Bold)
        }
        .height(40)
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .borderRadius(20)
        // .borderWidth(2)
        // .borderColor(this.searchBarBorderColor)
        .backgroundColor(this.searchButtonColor)
        .onTouch((event: TouchEvent) => {
          if (event.type == TouchType.Down) {
            this.searchButtonColor = this.cateBgColor
          }
          if (event.type == TouchType.Up) {
            this.searchButtonColor = ''
          }
        })
        .onClick(() => {
          this.isSearched = true
          this.isLoading = true
          this.isCateSelected = false
          this.searchNews(spaceToPlus(this.searchValue))
          this.loadSearchCategoryCounts(spaceToPlus(this.searchValue))
          // Log.info('LinkedString', spaceToPlus(this.searchValue))
        })
      }
      .padding(5)
      .backgroundColor(this.topBarBgColor)

      if (this.isLoading) {
        LoadComponent()
      } else {
        Row() {
          List() {
            ForEach(this.searchResultCategory, (item: string, number: number) => {
              ListItem() {
                Column() {
                  Text(item + ` ${number == 0 ? (this.newsCount == 0 ? '' : this.newsCount) : (number == 1 ? (this.articlesCount == 0 ? '' : this.articlesCount) : (this.discussionCount == 0 ? '' : this.discussionCount))}`)
                    .fontWeight(FontWeight.Bold)
                    .fontSize(20)
                    .onClick(() => {
                      this.isCateSelected = true
                      if (number == 0) {
                        this.searchNews(spaceToPlus(this.searchValue))
                        this.cate2TextColor = this.cateTxtColor
                        this.cate3TextColor = this.cateTxtColor
                        this.cate1TextColor = '#fffa6f6f'

                        this.cate2TextFont = FontWeight.Medium
                        this.cate3TextFont = FontWeight.Medium
                        this.cate1TextFont = FontWeight.Bold
                      }
                      else if (number == 1) {
                        this.searchArticles(spaceToPlus(this.searchValue))
                        this.cate1TextColor = this.cateTxtColor
                        this.cate3TextColor = this.cateTxtColor
                        this.cate2TextColor = '#fffa6f6f'

                        this.cate1TextFont = FontWeight.Medium
                        this.cate3TextFont = FontWeight.Medium
                        this.cate2TextFont = FontWeight.Bold
                      }
                      else if (number == 2) {
                        this.searchDiscussion(spaceToPlus(this.searchValue))
                        this.cate1TextColor = this.cateTxtColor
                        this.cate2TextColor = this.cateTxtColor
                        this.cate3TextColor = '#fffa6f6f'

                        this.cate1TextFont = FontWeight.Medium
                        this.cate2TextFont = FontWeight.Medium
                        this.cate3TextFont = FontWeight.Bold
                      }
                      else {
                        Log.info('Trigger no content result')
                      }
                    })// .fontColor(this.cateTxtColor)
                    .fontColor(!this.isCateSelected ? this.cateTxtColor : (number == 0 ? this.cate1TextColor : (number == 1 ? this.cate2TextColor : this.cate3TextColor)))
                    .fontWeight(!this.isCateSelected ? FontWeight.Medium : (number == 0 ? this.cate1TextFont : (number == 1 ? this.cate2TextFont : this.cate3TextFont)))
                }
                .onTouch((event: TouchEvent) => {
                  this.isTouch = true
                  if (event.type == TouchType.Down) {
                    if (number == 0) {
                      this.cate1BgColor = this.cateBgColor
                      this.cate2BgColor = this.topBarBgColor
                      this.cate3BgColor = this.topBarBgColor
                    }
                    else if (number == 1) {
                      this.cate1BgColor = this.topBarBgColor
                      this.cate2BgColor = this.cateBgColor
                      this.cate3BgColor = this.topBarBgColor
                    }
                    else if (number == 2) {
                      this.cate1BgColor = this.topBarBgColor
                      this.cate2BgColor = this.topBarBgColor
                      this.cate3BgColor = this.cateBgColor
                    }
                  }
                  if (event.type == TouchType.Up) {
                    this.isTouch = false
                    this.cate1BgColor = this.topBarBgColor
                    this.cate2BgColor = this.topBarBgColor
                    this.cate3BgColor = this.topBarBgColor
                  }
                })
                .backgroundColor(!this.isTouch ? this.topBarBgColor : (number == 0 ? this.cate1BgColor : (number == 1 ? this.cate2BgColor : this.cate3BgColor)))
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .width('33.3%')
                .height(40)
              }
            })
          }
          .listDirection(Axis.Horizontal)
        }
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(40)
        .margin({ bottom: 5 })

        if (!this.isEmpty) {
          Column() {
            Column() {
              List() {
                ForEach(this.searchedNews, (item: News) => {
                  ListItem() {
                    NewsItem({
                      item: item,
                      accountNewsManager: this.accountNewsManager,
                      currentUserEmail: this.currentUserEmail,
                      savedNewsId: $savedNewsId,
                      newsDao: this.newsDao,
                      currentUserNews: $currentUserNews,
                      txtColor: $txtColor,
                      authorTimeColor: $authorTimeColor
                    })
                    // Column() {
                    //   Column() {
                    //     Column() {
                    //       Image(item.image)
                    //         .width('100%')
                    //         .objectFit(ImageFit.Contain)
                    //         .borderRadius({ topLeft: 10, topRight: 10 })
                    //       Row() {
                    //         Text(item.title)
                    //           .fontSize(20)
                    //           .fontWeight(700)
                    //           .fontColor(this.txtColor)
                    //       }
                    //       .width('100%')
                    //       .padding(10)
                    //     }
                    //     .onClick(() => {
                    //       router.pushUrl({
                    //         url: "pages/NewsDetail",
                    //         params: item
                    //       })
                    //     })
                    //   }
                    //   .width('100%')
                    //
                    //   Row({ space: 10 }) {
                    //     Text(item.author)
                    //       .fontSize(15)
                    //       .fontWeight(FontWeight.Normal)
                    //       .padding(10)
                    //       .fontColor(this.authorTimeColor)
                    //   }
                    //   .justifyContent(FlexAlign.Start)
                    //   .width('100%')
                    //
                    //   // Description
                    //   Row() {
                    //     Text(item.description)
                    //       .width('100%')
                    //       .fontColor(this.txtColor)
                    //   }
                    //   .padding(10)
                    //
                    //   Row({ space: 10 }) {
                    //     Image($r('app.media.icon_stared'))
                    //       .width(25)
                    //     Image($r('app.media.icon_link'))
                    //       .width(20)
                    //
                    //     Row() {
                    //       Text(timeFormatModify(item.published))
                    //         .fontSize(15)
                    //         .fontColor(this.authorTimeColor)
                    //     }
                    //     .layoutWeight(1)
                    //     .justifyContent(FlexAlign.End)
                    //     .padding(10)
                    //   }
                    //   .width('100%')
                    //   .height('7%')
                    //   .justifyContent(FlexAlign.Start)
                    //   .alignItems(VerticalAlign.Center)
                    //   .margin({ left: 10 })
                    // }
                    // .width('100%')
                  }
                  .margin({ bottom: 40 })
                  .backgroundColor(this.cardColor)
                  .borderRadius(10)
                })
              }
              .width('90%')
            }
            .width('100%')
            .height('85%')
            .alignItems(HorizontalAlign.Center)
          }
        } else {
          EmptyComponent()
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.bgColor)
  }
}