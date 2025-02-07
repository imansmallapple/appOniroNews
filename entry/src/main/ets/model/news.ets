export class News {
  title: string
  image: string
  published: string
  description: string
  category: string
  author: string

  constructor(title: string, image: string, published: string, description: string, category: string, author: string) {
    this.title = title
    this.image = image
    this.published = published
    this.description = description
    this.category = category
    this.author = author
  }
}

export class NewsResponse {
  status: string
  news: News[]

  constructor(status: string, news: News[]) {
    this.status = status
    this.news = news
  }
}
