import { DbTable } from './DbTable'

export abstract class BaseEntity {
  /**
   * static: 用于创建类的静态成员，不依赖于类的实例存在
   */
  protected static TABLE: DbTable

  static getTableName(): string {
    return this.TABLE?.tableName ?? 'unknown table'
  }

  static getTableColumns(): string[] {
    return this.TABLE?.columns ?? []
  }

  getTableName(): string {
    return (this.constructor as typeof BaseEntity).getTableName()
  }

  getTableColumns(): string[] {
    return (this.constructor as typeof BaseEntity).getTableColumns()
  }
}