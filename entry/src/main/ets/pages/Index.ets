import { DataSource } from '../data/DataSource'
import { NewsResponse, News } from '../model/news'
import hilog from '@ohos.hilog'
import { CategoryResponse } from '../model/categories'
import router from '@ohos.router'
import { timeFormatModify } from '../utils/timeUtil'
import { HttpErrorComponent, LoadComponent } from '../component/components'
import Log from '../utils/Log'
import Storage from '../preference/Storage'

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

  async aboutToAppear(): Promise<void> {
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
  }

  async getCategorizedLatestNews(language: string, category: string) {
    let res: NewsResponse = await this.source.getLatestNews(language, category)
    this.latestNews = res.news
  }

  // private smoothScrollToTop() {
  //   const scrollDuration = 1000
  //   const frameRate = 60
  //   const interval = 1000 / frameRate
  //   const totalFrames = scrollDuration / interval
  //
  //   let currentFrame = 0;
  //   const startY = this.scroller.currentOffset().yOffset
  //   const distance = -startY
  //
  //   const scrollStep = () => {
  //     currentFrame++;
  //     const progress = Math.min(currentFrame / totalFrames, 1)
  //     const easeOutQuad = (t: number) => t * (2 - t)
  //     const easedProgress = easeOutQuad(progress)
  //
  //     this.scroller.scrollTo({
  //       xOffset: 0,
  //       yOffset: startY + distance * easedProgress,
  //       animation: false,
  //     });
  //
  //     if (currentFrame < totalFrames) {
  //       setTimeout(scrollStep, interval)
  //     }
  //   };
  //   scrollStep()
  // }

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
            // Log.info('isLoading: ', this.isLoading)
          })
        }
        .width('100%')
        .height('100%')
        .align(Alignment.Center)
      }
    }
    else {
      Stack() {
        Column() {
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

                      Row({ space: 10 }) {
                        Image($r('app.media.icon_stared'))
                          .width(25)
                        Image($r('app.media.icon_link'))
                          .width(20)

                        Row() {
                          Text(timeFormatModify(item.published))
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
              url: 'pages/StarPage'
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