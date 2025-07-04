import dayjs from '@mui/dayjs'

export interface IFormatDate {
  day: string,
  date: string
}

//dayjs转换日期
function dayJsFormatDate(timestamp: number, format: string = 'YYYY-MM-DD'): string {
  return dayjs(timestamp).format(format)
}

function formatDay(timestamp: number): string {
  const day: number = dayjs(timestamp).day()
  let formatDay: string = ''
  switch (day) {
    case 1:
      formatDay = '周一'
      break;
    case 2:
      formatDay = '周二'
      break;
    case 3:
      formatDay = '周三'
      break;
    case 4:
      formatDay = '周四'
      break;
    case 5:
      formatDay = '周五'
      break;
    case 6:
      formatDay = '周六'
      break;

    default:
      formatDay = '周日'
      break;
  }
  return formatDay
}

export function dateFormat(): IFormatDate[] {
  const dateList: IFormatDate[] = []
  for (let index = 1; index <= 7; index++) {
    const date: IFormatDate = {
      day: index === 1 ? '今天' : formatDay(Date.now() + index * 24 * 3600 * 1000),
      date: dayJsFormatDate(Date.now() + index * 24 * 3600 * 1000)
    }
    dateList.push(date)
  }
  return dateList
}