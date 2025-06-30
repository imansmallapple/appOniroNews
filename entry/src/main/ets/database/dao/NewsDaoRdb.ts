import { INewsDao } from './INewsDao'
import { BaseRelationalDatabase } from '../db/BaseRelationalDB'
import { relationalStore } from '@kit.ArkData'
import { NewsDto } from '../dto/News/NewsDto'
import { NewsEntity } from '../entity/NewsEntity'
import { NewsMapper } from '../mapper/NewsMapper'

// 使用封装过后的NewsDto来处理News
export class NewsDaoRdb implements INewsDao {
  private db: BaseRelationalDatabase

  constructor(dbInstance: BaseRelationalDatabase) {
    this.db = dbInstance
  }

  async getAllNews(): Promise<NewsDto[]> {
    return this.db.query(
      NewsEntity.getTableName(),
      NewsEntity.getTableColumns(),
      (predicates) => predicates,
      (resultSet: relationalStore.ResultSet) => NewsMapper.resultSetToNews(resultSet)
    )
  }

  async addNews(news: NewsDto): Promise<number> {
    return this.db.insert<NewsEntity>(
      NewsEntity.getTableName(),
      NewsMapper.toNewsEntity(news),
      (entity) => NewsMapper.entityToSave(entity),
      true
    )
  }

  updateNews(news: NewsDto): Promise<number> {
    return this.db.update<NewsEntity>(
      NewsEntity.getTableName(),
      NewsMapper.toNewsEntity(news),
      (predicates) => predicates.equalTo(
        NewsEntity.getTableColumns()[0], news.id
      ),
      (entity) => NewsMapper.entityToSave(entity)
    )
  }

  deleteNews(news: NewsDto): Promise<number> {
    return this.db.delete<NewsEntity>(
      NewsEntity.getTableName(),
      (predicates) => predicates.equalTo(NewsEntity.getTableColumns()[0], news.id)
    )
  }

  getNewsById(newsId: string): Promise<NewsDto[]> {
    return this.db.query(
      NewsEntity.getTableName(),
      NewsEntity.getTableColumns(),
      (predicates) => predicates.equalTo(NewsEntity.getTableColumns()[0], newsId),
      (resultSet: relationalStore.ResultSet) => NewsMapper.resultSetToNews(resultSet)
    )
  }
}

