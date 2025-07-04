## 参照尚硅谷租房项目写的租房APP（不是照搬）

-

设计稿：https://lanhuapp.com/web/#/item/project/stage?pid=2a5559b7-7740-46cd-8ed6-c7e0216a1bde&image_id=d399c8c6-4ef1-4682-82c8-1a2ef6bcdb28

- 后台用的是尚硅谷提供的 ./backend/backend.exe，跑程序前先运行后端

#### 学到的知识点

- Axios的使用和简单二次封装，详见Http.ts
- 三级联动，详见SearchFilter.ets
- List组件的联动，详见HouseDetail.ets
- List组件的自动滚动(类似弹幕的效果)，详见Discover.ets
- Partial泛型的使用，把一个数据类型里的属性都变成可选的，详见SearchFilter.ets
- RelativeContainer组件高度不会自适应，需要写死，看需求尽量用Stack代替