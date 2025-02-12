import { DataSource } from '../data/DataSource'
import { News, NewsResponse } from '../model/news'
import router from '@ohos.router'
import { timeFormatModify } from '../utils/timeUtil'
import Log from '../utils/Log'
import { Callback } from '@ohos.base'
import { LoadComponent, EmptyComponent } from '../component/components'
import { spaceToPlus } from '../utils/searchUtil'

@Entry
@Component
struct SearchPage {
  // Search
  @State searchValue: string = ''
  @State isSearched: boolean = false
  @State searchedNews: News[] = []
  private searchController: SearchController = new SearchController()
  private source = new DataSource()
  private searchResultCategory: string[] = ['news', 'articles', 'discussion']
  // Category
  @State newsCount: number = 0
  @State articlesCount: number = 0
  @State discussionCount: number = 0
  @State cate1TextColor: string = '#b0ffffff'
  @State cate2TextColor: string = '#b0ffffff'
  @State cate3TextColor: string = '#b0ffffff'
  @State cate1BgColor: string = ''
  @State cate2BgColor: string = ''
  @State cate3BgColor: string = ''
  @State searchButtonColor: string = ''
  @State backButtonColor: string = ''
  @State isLoading: boolean = false
  @State isEmpty: boolean = false
  @State @Watch('checkLoading') searchNewsLen: number = 0

  async searchNews(keyword: string) {
    let res: NewsResponse = await this.source.searchNews('en', keyword, 1)
    this.searchedNews = res.news
    this.searchNewsLen = this.searchedNews.length
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
        Image($r('app.media.icon_back'))
          .width(30)
          .onTouch((event: TouchEvent) => {
            if (event.type == TouchType.Down) {
              this.backButtonColor = '#b0514f4f'
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
          .backgroundColor('#c8181818')
          .placeholderColor('#b0ffffff')
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .borderColor('#46ffffff')
          .borderWidth(2)
          .fontColor(Color.White)
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
        .backgroundColor(this.searchButtonColor)
        .onTouch((event: TouchEvent) => {
          if (event.type == TouchType.Down) {
            this.searchButtonColor = '#b0514f4f'
          }
          if (event.type == TouchType.Up) {
            this.searchButtonColor = ''
          }
        })
        .onClick(() => {
          this.isSearched = true
          this.isLoading = true
          this.searchNews(spaceToPlus(this.searchValue))
          this.loadSearchCategoryCounts(spaceToPlus(this.searchValue))
          // Log.info('LinkedString', spaceToPlus(this.searchValue))
        })
      }
      .padding(5)

      if (this.isLoading) {
        LoadComponent()
      } else {
        Row() {
          List() {
            // todo: 搜索之后再显示结果栏， 更换浅点的背景颜色，去掉边框
            ForEach(this.searchResultCategory, (item: string, number: number) => {
              ListItem() {
                Column() {
                  Text(item + ` ${number == 0 ? (this.newsCount == 0 ? '' : this.newsCount) : (number == 1 ? (this.articlesCount == 0 ? '' : this.articlesCount) : (this.discussionCount == 0 ? '' : this.discussionCount))}`)
                    .fontWeight(FontWeight.Bold)
                    .fontSize(20)
                    .onClick(() => {
                      if (number == 0) {
                        this.searchNews(spaceToPlus(this.searchValue))
                        this.cate2TextColor = '#b0ffffff'
                        this.cate3TextColor = '#b0ffffff'
                        this.cate1TextColor = '#fffa6f6f'
                      }
                      else if (number == 1) {
                        this.searchArticles(spaceToPlus(this.searchValue))
                        this.cate1TextColor = '#b0ffffff'
                        this.cate3TextColor = '#b0ffffff'
                        this.cate2TextColor = '#fffa6f6f'
                      }
                      else if (number == 2) {
                        this.searchDiscussion(spaceToPlus(this.searchValue))
                        this.cate1TextColor = '#b0ffffff'
                        this.cate2TextColor = '#b0ffffff'
                        this.cate3TextColor = '#fffa6f6f'
                      }
                      else {
                        Log.info('Trigger no content result')
                      }
                    })
                    .fontColor(number == 0 ? this.cate1TextColor : (number == 1 ? this.cate2TextColor : this.cate3TextColor))
                }
                .onTouch((event: TouchEvent) => {
                  if (event.type == TouchType.Down) {
                    if (number == 0) {
                      this.cate1BgColor = '#b0514f4f'
                      this.cate2BgColor = ''
                      this.cate3BgColor = ''
                    }
                    else if (number == 1) {
                      this.cate1BgColor = ''
                      this.cate2BgColor = '#b0514f4f'
                      this.cate3BgColor = ''
                    }
                    else if (number == 2) {
                      this.cate1BgColor = ''
                      this.cate2BgColor = ''
                      this.cate3BgColor = '#b0514f4f'
                    }
                  }
                  if (event.type == TouchType.Up) {
                    this.cate1BgColor = ''
                    this.cate2BgColor = ''
                    this.cate3BgColor = ''
                  }
                })
                .backgroundColor(number == 0 ? this.cate1BgColor : (number == 1 ? this.cate2BgColor : this.cate3BgColor))
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .width('33%')
                .height(40)
              }
            })
          }
          .listDirection(Axis.Horizontal)
        }
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(40)

        if (!this.isEmpty) {
          Column() {
            Column() {
              List() {
                ForEach(this.searchedNews, (item: News) => {
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
                              .fontColor(Color.White)
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
                          .fontColor('#56000000')
                          .padding(10)
                          .fontColor(Color.White)

                        Row() {
                          Text(timeFormatModify(item.published))
                            .fontSize(15)
                            .fontColor(Color.White)
                        }
                        .layoutWeight(1)
                        .justifyContent(FlexAlign.End)
                        .padding(10)

                      }
                      .justifyContent(FlexAlign.Start)
                      .width('100%')

                      // Description
                      Row() {
                        Text(item.description)
                          .width('100%')
                          .fontColor(Color.White)
                      }
                      .padding(10)

                      Row({ space: 10 }) {
                        Image($r('app.media.icon_stared'))
                          .width(25)
                        Image($r('app.media.icon_link'))
                          .width(20)
                      }
                      .width('100%')
                      .height('7%')
                      .justifyContent(FlexAlign.Start)
                      .alignItems(VerticalAlign.Center)
                      .margin({ left: 10 })
                    }
                    .width('100%')
                  }
                  .margin({ bottom: 40 })
                  .backgroundColor('#ff3b3a3a')
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
    .backgroundColor(Color.Black)
  }
}