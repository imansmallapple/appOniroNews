import { DBConfig } from '../config/DbConfig';
import { BaseEntity } from '../db/BaseEntity';
import { DbTable } from '../db/DbTable';
import { Entity } from '../db/Entity';

export class AccountNewsEntity extends BaseEntity implements Entity {
  protected static readonly TABLE: DbTable = DBConfig.ACCOUNT_NEWS_TABLE

  account_email: string
  news_id: string

  constructor(email: string, newsId: string) {
    super()
    this.account_email = email
    this.news_id = newsId
  }
}