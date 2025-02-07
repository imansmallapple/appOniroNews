export class News {
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

export class NewsResponse {
  status: string
  news: News[]

  constructor(status: string, news: News[]) {
    this.status = status
    this.news = news
  }
}
