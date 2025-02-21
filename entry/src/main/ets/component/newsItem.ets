import { News } from '../model/news'
import { timeFormatModify } from '../utils/timeUtil'
import router from '@ohos.router'
import { AccountNewsManager } from '../methods/accountNews'
import { NewsManager } from '../methods/news'
import { AccountNewsDto } from '../database/dto/AccountNews/AccountNewsDto'
import promptAction from '@ohos.promptAction'
import Log from '../utils/Log'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'
import { NewsDto } from '../database/dto/News/NewsDto'

const Tag = 'Test NewsItem'

@Component
export default struct NewsItem {
  private item!: News
  @State isStared: boolean = false
  // @State authorTimeColor: string = '#56000000'
  // @State txtColor: string = '#ff000000'
  @Link authorTimeColor: string
  @Link txtColor: string
  private accountNewsManager!: AccountNewsManager
  private newsManager!: NewsManager
  private currentUserEmail!: string
  @Link savedNewsId: string[]
  private newsDao!: NewsDaoRdb
  @Link currentUserNews: NewsDto[]

  async aboutToAppear(): Promise<void> {
    let res = await this.accountNewsManager.getUserNews(this.currentUserEmail)
    this.savedNewsId = res
    // Log.info('check savedNewsId in newsItem', 'user all news id:', JSON.stringify(res))
    // this.savedNewsId.forEach((id: string) => {
    //   this.getUserNews(id)
    // })
    this.isStared = await this.checkUserNewsExist(this.item.id)
  }

  async saveNews(email: string, id: string) {
    this.accountNewsManager.addUserNews(email, id)
    let res = await this.accountNewsManager.getUserNews(email)
    Log.info('check getUserNews', 'user all news id:', JSON.stringify(res))
    this.savedNewsId = res
    Log.info(Tag, 'savedNewsId:', JSON.stringify(this.savedNewsId))
  }

  async removeNews(email: string, id: string){
    this.accountNewsManager.removeUserNews(email, id)
    let res = await this.accountNewsManager.getUserNews(email)
    Log.info('check getUserNews', 'user all news id:', JSON.stringify(res))
    this.savedNewsId = res
    Log.info(Tag, 'savedNewsId:', JSON.stringify(this.savedNewsId))
  }

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

  async checkUserNewsExist(id: string): Promise<boolean> {
    let res: NewsDto[] = await this.newsDao.getNewsById(id)
    if (res.length == 0) {
      return false
    } else {
      return true
    }
  }

  async getUserNews(id: string): Promise<NewsDto> {
    let res: NewsDto[] = await this.newsDao.getNewsById(id)
    let toPush: NewsDto = res.pop() as NewsDto
    Log.info('check getUserNews', `get news with id${id}:`, toPush)
    this.currentUserNews.push(toPush)
    Log.info('check getUserNews', `check currnet user news list:`, this.currentUserNews)
    return res.pop() as NewsDto
  }

  async popUserNews(id: string) {
    let res: NewsDto[] = await this.newsDao.getNewsById(id)
    let toPop: NewsDto = res.pop() as NewsDto
    Log.info('check getUserNews', `get news with id${id}:`, toPop)
    this.currentUserNews = this.currentUserNews.filter(news => news.id !== id)
    Log.info('check getUserNews', `check currnet user news list:`, this.currentUserNews)
  }

  checkCurrentUserNews() {
    Log.info(Tag,'checkCurrentUserNews: ', this.currentUserNews)
  }

  async pushNews(item: News): Promise<boolean> {
    try {
      // Log.info(Tag, 'Input item params:', item)

      const newNews: NewsDto = {
        id: item.id,
        title: item.title,
        description: item.description,
        url: item.url,
        author: item.author,
        image: item.image,
        language: item.language,
        category: item.category.toString(),
        published: item.published,
      }
      const addId: number = await this.newsDao.addNews(newNews)
      Log.info(Tag, 'Inserted news with ID:', addId)
      return true
    } catch (error) {
      Log.error(Tag, 'catch error: ', JSON.stringify(error))
      return false
    }
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
          .onClick(async () => {
            this.isStared = !this.isStared
            if (this.isStared == true) {
              this.saveNews(this.currentUserEmail, this.item.id)
              Log.info(Tag, 'add email:', this.currentUserEmail)
              Log.info(Tag, 'add news id:', this.item.id)
              promptAction.showToast({
                message: "News saved!"
              })
              let res2 = await this.pushNews(this.item)
              Log.info(Tag, 'test push result: ', res2)
              await this.getUserAllNews()
              this.getUserNews(this.item.id)
              this.checkCurrentUserNews()
            } else {
              this.removeNews(this.currentUserEmail, this.item.id)
              await this.getUserAllNews()
              this.popUserNews(this.item.id)
              this.checkCurrentUserNews()
              promptAction.showToast({
                message: "News removed!"
              })
            }
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