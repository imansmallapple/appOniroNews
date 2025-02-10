import { DataSource } from '../data/DataSource'
import { News, NewsResponse } from '../model/news'
import router from '@ohos.router'
import { timeFormatModify } from '../utils/timeUtil'

@Entry
@Component
struct SearchPage {
  // Search
  @State searchValue: string = ''
  @State isSearched: boolean = false
  @State searchedNews: News[] = []
  private searchController: SearchController = new SearchController()
  private source = new DataSource()

  async searchNews(keyword: string) {
    let res: NewsResponse = await this.source.searchNews('en', keyword, 1)
    this.searchedNews = res.news
  }

  build() {
    Column() {
      Row({ space: 5 }) {
        Image($r('app.media.icon_back'))
          .width(30)
          .onClick(() => {
            router.back()
          })
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
            // todo: 这里和按钮需要一个自动把句子中的空格转换成加号的函数
            this.isSearched = true
            this.searchNews(this.searchValue)
            this.searchValue = ''
          })

        Row() {
          Text('Search')
            .fontSize(18)
            .fontColor('#fffa6f6f')
            .fontWeight(FontWeight.Bold)
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .borderRadius(20)
        .onClick(() => {
          this.isSearched = true
          this.searchNews(this.searchValue)
          this.searchValue = ''
        })
      }
      .padding(5)

      Row() {

      }
      .width('100%')
      .height(40)
      .borderWidth(2)
      .borderColor(Color.White)

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
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}