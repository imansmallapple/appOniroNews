import { DBConfig } from '../config/DbConfig';
import { BaseEntity } from '../db/BaseEntity';
import { DbTable } from '../db/DbTable';
import { Entity } from '../db/Entity';

export class NewsEntity extends BaseEntity implements Entity {
  protected static readonly TABLE: DbTable = DBConfig.NEWS_TABLE

  id: string
  title: string
  image: string
  url: string
  published: string
  description: string
  category: string
  author: string
  language: string

  constructor(id: string, url: string, language: string, title: string, image: string, published: string, description: string, category: string, author: string) {
    super()
    this.title = title
    this.image = image
    this.published = published
    this.description = description
    this.category = category
    this.author = author
    this.id = id
    this.url = url
    this.language = language
  }
}