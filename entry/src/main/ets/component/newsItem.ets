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
  @State authorTimeColor: string = '#56000000'
  @State txtColor: string = '#ff000000'
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
  }

  async saveNews(email: string, id: string) {
    this.accountNewsManager.addUserNews(email, id)
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

  async getUserNews(id: string): Promise<NewsDto> {
    let res: NewsDto[] = await this.newsDao.getNewsById(id)
    let toPush: NewsDto = res.pop() as NewsDto
    Log.info('check getUserNews', `get news with id${id}:`, toPush)
    this.currentUserNews.push(toPush)
    Log.info('check getUserNews', `check currnet user news list:`, this.currentUserNews)
    return res.pop() as NewsDto
  }

  checkCurrentUserNews() {
    Log.info(Tag, this.currentUserNews)
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
      // const newNews4: NewsDto = {
      //   id: '511836a8-9726-47a0-8155-3ad7a3552e19',
      //   title: 'Fear of political meddling grips Malaysia’s legal circles ahead of changes in judiciary leadership',
      //   description: 'KUALA LUMPUR: A leadership transition is set to strike at the heart of Malaysia’s judiciary in the coming months and how the government pushes ahead with new appointments could have far-reaching ramif...',
      //   url: 'https://www.channelnewsasia.com/asia/malaysia-legal-chief-justice-appointment-fear-political-meddling-4949201',
      //   author: 'Leslie Lopez',
      //   image: 'https://dam.mediacorp.sg/image/upload/s--0Mg17AIt--/c_crop,h_720,w_1280,x_0,y_79/f_auto,q_auto/c_fill,g_auto,h_676,w_1200/v1/mediacorp/cna/image/2025/02/21/tengku_maimun_oly_facebook_malaysian_judiciary.jpg?itok=KK5n_sKx',
      //   language: 'en',
      //   category: 'world',
      //   published: '2025-02-21 09:00:00 +0000',
      // }
      const addId: number = await this.newsDao.addNews(newNews)
      Log.info(Tag, 'Inserted news with ID:', addId)
      // const addId2: number = await this.newDao.addNews(newNews4)
      // Log.info(Tag, 'Inserted news with ID:', addId2)
      // const addId3: number = await this.newDao.addNews(item)
      // Log.info(Tag, 'Inserted news with ID:', addId3)
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