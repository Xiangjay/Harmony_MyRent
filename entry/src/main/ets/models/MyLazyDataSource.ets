import { BasicDataSource } from './BasicDataSource';

export class MyLazyDataSource<T> extends BasicDataSource<T> {
  public dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    return this.dataArray[index];
  }

  public addData(index: number, data: T): void {
    this.dataArray.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public pushAllData(data: T[]): void {
    for (let index = 0; index < data.length; index++) {
      this.pushData(data[index])
    }
  }
}