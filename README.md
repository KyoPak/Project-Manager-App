# Project Manager ReadME

- Kyo가 만든 일정을 관리할 수 있는 Project Manager App입니다.

## 목차
1. [팀 소개](#팀-소개)
2. [실행 화면](#실행-화면)
3. [Diagram](#diagram)
4. [폴더 구조](#폴더-구조)
5. [타임라인](#타임라인)
6. [기술적 도전](#기술적-도전)
7. [트러블 슈팅 및 고민](#트러블-슈팅-및-고민)
8. [참고 링크](#참고-링크)


## 팀 소개
 |[Kyo](https://github.com/KyoPak)|
 |:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://user-images.githubusercontent.com/59204352/193524215-4f9636e8-1cdb-49f1-9a17-1e4fe8d76655.PNG" >|


## 실행 화면

### ▶️ Step-1, 2 실행화면

<details>
<summary> 
펼쳐보기
</summary>

|**기능**|**실행화면**|
|:--:|:--:|
|Plan 등록|<img src="https://i.imgur.com/K4GmBny.gif" width=800>|
|Plan 변경|<img src="https://i.imgur.com/qLfYF4K.gif" width=800>|
|Plan 이동|<img src="https://i.imgur.com/41kaK6t.gif" width=800>|

</details>

### Class Diagram

<img src="https://i.imgur.com/eoeILza.png" width=800>
 
## 폴더 구조

```
├── ProjectManager
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── GoogleService-Info.plist
│   ├── Model
│   │   ├── MovePlan.swift
│   │   ├── Plan.swift
│   │   └── Process.swift
│   ├── Network
│   │   └── FireStoreManager.swift
│   ├── Util
│   │   ├── Extension
│   │   │   ├── DateFormatter+Extension.swift
│   │   │   └── UIComponent+Extension.swift
│   │   ├── Protocol.swift
│   │   |   └── Identifierable.swift
│   │   └── FireBaseError.swift
│   ├── View
│   │   ├── MainScenes
│   │   │   ├── MainViewController.swift
│   │   │   ├── ProcessTableViewCell.swift
│   │   │   └── ProcessView.swift
│   │   └── SubScenes
│   │       ├── DetailView.swift
│   │       └── DetailViewController.swift
│   └── ViewModel
│       ├── CellViewModel.swift
│       ├── DetailViewModel.swift
│       ├── MainViewModel.swift
│       └── ProcessViewModel.swift
└── ProjectManagerTests
    ├── CellViewModelTest.swift
    ├── DetailViewModelTest.swift
    ├── MainViewModelTest.swift
    └── TestData.swift
```

##  타임라인
### 👟 Step 1

- 사용할 기술 스택 선정 및 조사 
    - ✅ MVVM
    - ✅ SPM
    - ✅ CoreData
    - ✅ FireBase

### 👟 Step 2
- MVVM
    - ✅ MVVM사용
    - ✅ MVVM사용에 따른 Logic에 대한 UnitTest 경험
- GestureRecognizer
    - ✅ UILongPressGesureRecognizer 활용
- Present Style
    - ✅ Popover : Cell LongPress 터치 시 활용
    - ✅ FormSheet : 등록/편집에 대한 View Display시 활용

### 👟 Step 3
- FireBase 
    - ✅ FireStoreDB의 CRUD 기능 구현

<details>
<summary> 
펼쳐보기
</summary>

- `MainViewModel`
    - 모든 Process(todo, doing, done)에 대한 데이터를 가지고 있게끔 하였습니다.
    - Process 별로 Data의 추가, 변경, 삭제 기능을 구현하였습니다.
    - MainViewController에서 PopOver가 발생하면 누른 Process 이외의 Process들이 저장되는 `popOverProcessList`가 변경되고 bind를 통해서 PopOver이벤트가 MainViewController로 전달되게끔 구현하였습니다.

- `ProcessViewModel`
    - 각 Process에 해당하는 Data들을 가지고 있으며, Data의 갯수를 HeaderView에 표시해주고, `applySnapshot`이 Bind를 통해 Data들이 표시되게끔 구현하였습니다. 
    
- `ProcessViewController`
    - Cell 터치, Long Press의 이벤트가 발생한다면 Delegate를 통해 MainViewController로 전달되고, MainViewModel에서 이벤트가 처리되도록 구현하였습니다.
    
- `DetailViewModel`
    - `MainViewModel`에게 전달받은 Data를 UI로 보여주고, Edit할 수 있는지에 대한 로직이 담겨있는 ViewModel입니다.
    - `DetailViewModel`이 생성될때 주입되는 Data가 nil이라면 새로운 데이터를 추가, nil이 아니라면 Data Edit으로 로직이 작동되게끔 구현하였습니다.
    
- Data를 `DetailView`에서 입력 후, `MainViewModel`로 넘기는 과정
    - `DetailViewModel`에서 Data를 입력후 Done버튼을 누르면 `DetailViewModel`의 `createData()`를 통해 데이터가 만들어지고, 만들어진 데이터를 Delegate메서드`shareData()`를 통해 `MainViewController`에게 이벤트를 넘기면서 `MainViewModel`에서 이벤트에 대한 로직이 처리되게끔 구현하였습니다.

- `CellViewModel`
    - `CellViewModel`은 Data를 UI에 보여주고, DeadLine을 넘겼을 경우 날짜 Label의 색상을 변경하는 로직을 담았습니다.
    
</details>



## 기술적 도전
### ⚙️ MVVM
<details>
<summary> 
펼쳐보기
</summary>
    
- <img src="https://i.imgur.com/i14DfmA.png" width=500>
- 위의 그림처럼 MVVM에서의 View는 오직 시각적인 요소로만 이루어져야합니다.
- ViewModel에서는 View의 로직을 처리하며, ViewModel 자체는 View의 로직을 처리하는 객체입니다. 
    
- 💡 기존의 MVC와 다른 점은 ViewController내부가 계층화가 되었다는 점입니다. 로직에 대한 부분을 ViewModel에서 처리하기 때문에 ViewController가 비대해지지 않는 점도 있지만, 테스트가 용이해진다는 점이 강점이라 생각됩니다. 
- 실제로 프로젝트를 하며 가장 체감되었던 좋은 점은 모델의 로직이 아닌 View의 로직을 Test할 수 있다는 점 입니다. 
- MVC에서의 View의 로직 테스트가 어려웠던 이유는 ViewController 내부에 로직과 View가 결합되어 있고, ViewController의 LifeCycle 또한 고려해줘야하기 때문에 테스트 용이성이 더욱 체감되었습니다.
    
</details> 

### ⚙️ FireBase - Step3 작성 예정
<details>
<summary> 
펼쳐보기
</summary>
    
- 
- 💡 
    
</details> 



## 트러블 슈팅 및 고민
### 🔥 MVVM 설계에 대한 고민 
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
    
처음 구조를 생각 했을 때, `DataManager`라는 싱글톤 클래스에서 데이터를 관리하고,
`MainViewModel`의 역할은 `DataManager`의 데이터를 각 리스트에 보여주고, `DataManage`r의 변경사항에 따라 `MainViewModel`이 가지고 있는 데이터가 갱신되게끔 생각하였습니다.

하지만 굳이 `DataManager`라는 또 다른 Class를 만들어 관리하는 것이 불필요하다고 생각이 되었고, 
테스트에 사용되는 객체가 독립적이어야 하는데 싱글톤 같은 경우 하나의 객체에 접근하기 때문에 MVVM의 장점중 하나인 테스트 용이성이 자칫 떨어질 수 있다고 생각이 들었습니다.
    
때문에 현재와 같이 MainViewModel에서 데이터를 관리하고, Process(등록, 편집, 삭제), index를 관리하게끔 설계를 변경하였습니다.

설계는 추후 또 변경될 수 있습니다!
 
</details>

### 🔥 TableView 사이에 마진을 넣는 방법

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**

**해결 🔥**

</details>

### 🔥 ViewModel에 이벤트를 넘기는 방법

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**

**해결 🔥**

</details>


### 🔥 FireBase의 컬렉션 사용에 대한 고민 3개? 1개?

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**

**해결 🔥**

</details>


## 참고 링크

[공식문서]


