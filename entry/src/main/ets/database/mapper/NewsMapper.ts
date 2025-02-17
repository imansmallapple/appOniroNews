import { NewsDto } from '../dto/News/NewsDto';
import { NewsEntity } from '../entity/NewsEntity';
import relationalStore from '@ohos.data.relationalStore';

export class NewsMapper {
  public static toNewsEntity(news: NewsDto): NewsEntity {
    return new NewsEntity(
      news.id,
      news.url,
      news.language,
      news.title,
      news.image,
      news.published,
      news.description,
      news.category,
      news.author
    )
  }

  public static toNewsDto(news: NewsEntity): NewsDto {
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

  public static resultSetToNews(resultSet: relationalStore.ResultSet): NewsDto[] {
    const newsList: NewsDto[] = []
    while (resultSet.goToNextRow()) {
      const news: NewsDto = {
        id: resultSet.getString(resultSet.getColumnIndex('id')),
        title: resultSet.getString(resultSet.getColumnIndex('title')),
        image: resultSet.getString(resultSet.getColumnIndex('image')),
        url: resultSet.getString(resultSet.getColumnIndex('url')),
        published: resultSet.getString(resultSet.getColumnIndex('published')),
        description: resultSet.getString(resultSet.getColumnIndex('description')),
        category: resultSet.getString(resultSet.getColumnIndex('category')),
        author: resultSet.getString(resultSet.getColumnIndex('author')),
        language: resultSet.getString(resultSet.getColumnIndex('language'))
      }
      newsList.push(news)
    }
    return newsList
  }

  public static entityToSave(entity: NewsEntity): relationalStore.ValuesBucket {
    return {
      id: entity.id,
      title: entity.title,
      image: entity.image,
      url: entity.url,
      published: entity.published,
      description: entity.description,
      category: entity.category,
      author: entity.author,
      language: entity.language
    }
  }
}