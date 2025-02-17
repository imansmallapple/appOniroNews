import { NewsDto } from '../dto/News/NewsDto'

export interface INewsDao {
  getAllNews(): Promise<NewsDto[]>

  addNews(news: NewsDto): Promise<number>

  updateNews(news: NewsDto): Promise<number>

  deleteNews(news: NewsDto): Promise<number>

  getNewsById(newsId: string): Promise<NewsDto[]>
}