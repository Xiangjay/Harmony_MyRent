export interface ISearchHouseParams {
  page: number
  limit: number
  provinceCode?: string
  cityCode?: string
  districtCode?: string
  minRent?: string
  maxRent?: string
  paymentType?: string
  orderBy?: string
  orderType?: string
}

export interface IHouseModel {
  id: string
  housePicture: string
  tags: Array<IHouseTag>
  houseTitle: string
  address: string
  rentPriceUnit: string
  rentPriceListing: string
  rentArea: string
  activity?: IHouseActivity
}

export interface IHouseTag {
  name: string
}

export interface IHouseActivity {
  title: string
  textColor: string
  textBackGroundColor: string
  '#text': string
  icon: string
}

export interface ISearchHouseResponse {
  records: Array<IHouseModel>
  total: string
}

export interface IProvinceModel {
  code: string
  name: string
}

export interface ICityModel extends IProvinceModel {
  provinceCode: string
}

export interface IAreaModel extends ICityModel {
  cityCode: string
}

export interface IPriceModel {
  id: number,
  minRent: string
  maxRent: string
  text: string
}

export interface ISortModel {
  id: string
  text: string
  orderBy: string
  orderType: string
  img: ResourceStr
}

export interface IHouseDetailHousePicture {
  spaceName: string,
  picList: string[]
}

export interface IHouseDetailTag {
  name: string
}

export interface IHouseDetailRentTerm {
  checkInTime: string
  term: string
  kitchen: string
  lift: string
  seeTime: string
  year: string
  renovation: string
  grounding: string
  heating: string
  green: string
  protection: string
  house: string
}

export interface IHouseDetailMetaInfo {
  name: string
  desc: string
}

export interface IHouseDetailDiscounts {
  tagTxtBgAroundColor: string
  image: string
  txt: string
  tagTxt: string
  tagTxtColor: string
}

export interface IHouseSupport {
  image: string
  title: string
  subTitle: string
}

export interface IHouseDetailRentInfo {
  image: string
  title: string
  userTag: string
}

export interface IHouseDetailHouseHoldItemList {
  icon: string
  value: string
}

export interface IHouseDetailHouseHold {
  name: string
  itemList: IHouseDetailHouseHoldItemList[]
}

export interface IHouseDetailDistanceInfo {
  distance: string
  line: string
  name: string
}

export interface IHouseDetailModel {
  houseTitle: string
  address: string
  rentPriceUnit: string
  housePicture: IHouseDetailHousePicture[]
  tags: IHouseDetailTag[]
  rentPriceUnitListing: string
  distanceInfo: IHouseDetailDistanceInfo | null
  rentTerm: IHouseDetailRentTerm
  metaInfo: IHouseDetailMetaInfo[],
  id: string
  rentArea: string
  discounts: IHouseDetailDiscounts[],
  householdItem: IHouseDetailHouseHold[],
  support: IHouseSupport[],
  rentInfo: IHouseDetailRentInfo[]
}

export interface IHouseDetailRouterParams {
  id: string
}

export interface IReservation {
  name: string
  date: string
  houseId: string
  phone: string
  comment: string
}


export interface IReservationRouterParams {
  list: Array<IReservedHouse>
}

export interface IReservedHouse {
  id: string
  date: string
  tags: Array<IHouseTag>
  houseId: string
  img: string
  title: string
  subTitle: string
  distanceInfo: IHouseDetailDistanceInfo | null
  rentPrice: string
  comment: string
}