export interface IHomeData {
  bannerList: Array<HomeBanner>
  navList: Array<HomeNav>
  tileList: Array<HomeTitle>
  planList: Array<HomePlan>
  adPicture: string
}

export interface HomeBanner {
  id: number
  name: string
  imageURL: string
}

export interface HomeNav {
  id: number
  title: string
  imageURL: string
}

export interface HomeTitle {
  id: number
  title: string
  sub_title: string
  imageURL: string
}

export interface HomePlan {
  id: number
  imageURL: string
}

export interface IRecommendHouse {
  id: string
  housePicture: string
  tags: Array<RecommendHouseTag>
  houseTitle: string
  address: string
  rentPriceUnit: string
  rentPriceListing: string
  rentArea: string
}

export interface RecommendHouseTag {
  name: string
}

export interface topBuilderParams {
  fontColor: string
}