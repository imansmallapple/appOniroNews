export class CategoryResponse {
  categories: string[]
  description: string
  status: string

  constructor(categories: string[], description: string, status: string) {
    this.categories = categories
    this.description = description
    this.status = status
  }
}