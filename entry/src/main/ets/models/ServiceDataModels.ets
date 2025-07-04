export interface IServiceData {
  vipServiceList: vipService[]
  homeServiceList: homeService[]
  serviceActivity: serviceActivity
  newcomerZone: newcomerZone
  cleaningServiceInfo: cleaningServiceInfo[]
}

export interface vipService {
  name: string
  content: number
}

export interface homeService {
  icon: string
  title: string
}

export interface serviceActivity {
  name: string
  img: string
  title: string
  subTitle: string
}

export interface newcomerZone {
  img: string
}

export interface cleaningServiceInfo {
  originalPrice: string
  img: string
  title: string
  subTitle: string
  priceAfterDiscounts: string
}