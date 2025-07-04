export interface IDiscoverModel {
  danMuList1: IDanMuListModel[]
  danMuList2: IDanMuListModel[]
  postZone: IPostZone
  benefits: IBenefits[]
}

export interface IDanMuListModel {
  avatar: string
  content: string
}

export interface IMainPost {
  followerNum: string
  title: string
  userAvatar: string
  userName: string
  postContent: string
}

export interface IContentBlock {
  img: string
}

export interface IPostZone {
  mainPost: IMainPost
  contentBlockList: Array<IContentBlock>
}

export interface IBenefits {
  title: string
  img: string
}