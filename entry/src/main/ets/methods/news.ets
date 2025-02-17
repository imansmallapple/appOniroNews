import { OniroNewsDB } from '../database/OniroNewsDB'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'
import { NewsDto } from '../database/dto/News/NewsDto'
import Log from '../utils/Log'

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
    const newsById = await newsDao.getNewsById('wdwcw2rk2of3')
    Log.info(Tag, 'News with ID wdwcw2rk2of3:', newsById)
    // const addId = await newsDao.addNews(newNews)
    // const addId = await newsDao.addNews(newNews)
  } catch (error) {
    Log.error(Tag, 'Error during DB operations', JSON.stringify(error))
  }
}
