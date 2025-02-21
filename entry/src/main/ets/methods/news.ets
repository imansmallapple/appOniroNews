import { OniroNewsDB } from '../database/OniroNewsDB'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'
import { NewsDto } from '../database/dto/News/NewsDto'
import Log from '../utils/Log'
import { News } from '../model/news'

const Tag = 'Test RDB'

export async function runNewsOperations(context: Context) {
  try {
    const dbInstance = await OniroNewsDB.getInstance(context)

    const newsDao = new NewsDaoRdb(dbInstance)

    const newNews1: NewsDto = {
      id: 'wdwcw2rk2of32',
      title: 'This is title1',
      image: 'this is image1',
      url: 'this is url1',
      published: 'published1',
      description: 'description1',
      category: 'category1',
      author: 'author1',
      language: 'language1'
    }
    const newNews2: NewsDto = {
      id: 'wdwcw2rk2of3222',
      title: 'This is title2',
      image: 'this is image2',
      url: 'this is url2',
      published: 'published2',
      description: 'description2',
      category: 'category2',
      author: 'author2',
      language: 'language2'
    }
    const newNews3: NewsDto = {
      id: 'wdwcw2rk2of3222',
      title: 'This is title2',
      image: 'this is image2',
      url: 'this is url2',
      published: 'published2',
      description: 'description2',
      category: 'category2',
      author: 'author2',
      language: 'language2'
    }
    const addId1 = await newsDao.addNews(newNews1)
    const addId2 = await newsDao.addNews(newNews2)
    const addId3 = await newsDao.addNews(newNews3)
    Log.info(Tag, 'Inserted news with ID:', addId1)
    Log.info(Tag, 'Inserted news with ID:', addId2)
    Log.info(Tag, 'Inserted news with ID:', addId3)
    const allNews = await newsDao.getAllNews()
    Log.info(Tag, `All news length:`, allNews.length)
    allNews.forEach((item, number) => {
      Log.info(Tag, `All news ${number}:`, JSON.stringify(item))
    })
    const newsById = await newsDao.getNewsById('wdwcw2rk2of32')
    Log.info(Tag, 'News with ID wdwcw2rk2of32:', newsById)
    // const addId = await newsDao.addNews(newNews)
    // const addId = await newsDao.addNews(newNews)
  } catch (error) {
    Log.error(Tag, 'Error during DB operations', JSON.stringify(error))
  }
}

export class NewsManager {
  private TAG = 'Test RDB'
  private dbInstance!: OniroNewsDB
  private newsDao!: NewsDaoRdb

  private async initialize(context: Context) {
    try {
      this.dbInstance = await OniroNewsDB.getInstance(context)
      this.newsDao = new NewsDaoRdb(this.dbInstance)
    }
    catch (error) {
      Log.error(Tag, 'Error during DB operations', JSON.stringify(error))
    }
  }

  constructor(context: Context) {
    this.initialize(context)
  }

  newsToDto(news: News): NewsDto {
    return {
      id: news.id,
      title: news.title,
      image: news.image,
      url: news.url,
      published: news.published,
      description: news.description,
      category: news.category,
      author: news.author,
      language: news.language
    }
  }

  // async addNews(item: News): Promise<number> {
  //   let newsDto: NewsDto = this.newsToDto(item)
  //   let res = await this.newsDao.addNews(newsDto)
  //   Log.info('test string inside fuc add', res)
  //   return res
  // }
  // todo: Check add news implementation
  async addNews(item: News): Promise<number> {
    let newsDto: NewsDto = this.newsToDto(item)
    // newsDto ok
    // Log.info('test string before addNews', JSON.stringify(newsDto))

    let res = await this.newsDao.addNews(newsDto)

    Log.info('test string inside func add', res)
    return res
  }

  async removeNews(item: News): Promise<number> {
    let newsDto: NewsDto = this.newsToDto(item)
    let res = await this.newsDao.deleteNews(newsDto)
    return res
  }

  async getNewsById(id: string): Promise<NewsDto[]> {
    let res: NewsDto[] = await this.newsDao.getNewsById(id)
    return res
  }

  async getAllNews(): Promise<NewsDto[]> {
    let res: NewsDto[] = await this.newsDao.getAllNews()
    Log.info('test string inside fuc get', res)
    return res
  }
}