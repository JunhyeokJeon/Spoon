
## 1. 날짜 별 진행사항
##### 18년 05월 08일
경영대 세미나실2에 모여 아이디어 회의를 진행하였다. 각자 2~3개 씩을 모아 총 7개의 아이디어를 발표하여 공유하였고 토론 과정을 통하여 가장 톡톡튀는 아이디어라고 판단된 혼밥하는 사람들을 위한 감성 SNS 서비스 '혼밥감성' 플랫폼을 도출하였다.

##### 18녈 05월 15일
- UI Sketch Sheet
파워포인트를 이용하여 전체적인 UI 로직과 Sketch를 기획해 보았다.
- Back End  
혼밥인증 포스트를 올릴 Post와 댓글 기능 Comment, 사용자 User 모델을 생성하여 각각의 칼럼 속성을 설계함
- Front End
Main 페이지 작성, 서비스 첫 화면에 로그인 화면을 띄어주며, 로그인과 회원가입 버튼이 있다.
- Naming
혼밥감성이란 이름에서 Spoon(스푼)이란 이름으로 변경.

##### 18녈 05월 23일
- gem sipmle_form, bootstrap_sass, haml, rails_db 설치
- post, comment 모델 생성
- bootstrp 설정 (application.css.scss, application.js)

##### 18녈 05월 24일
* 프로젝트 재생성 (Pjt Name: Spoon_beta)
시간관계상 처음부터 프로젝트를 파서 시작하기 어려울 것이라 판단함. 그리고 spoon sns는 혼자 밥먹는 모습을 사진과 함께 description을 추가하여 포스팅하는 것, 타인의 포스팅에 공감하는 spoon을 입력하는 것, 타인의 글에 코멘트를 작성하는 것의 기본적인 sns기능을 필요로하는 것이다.

그래서 Mackenzie 의 3~4 강의에서 코딩한 Pin_board 프로젝트를 기본 베이스로 삼아 깃허브를 통해 클론을 해옴.

* 추가한 기능
- My Profile page
- Comment Model을 새로 생성한 후 Pin과 User 모델들과의 관계 설정

##### 18녈 05월 30일
* front-end design
- body background
- logo design
- index>panel border

* views file
- 만약 어떤 콘텐츠도 존재하지 않을 시 아이콘과 함께 nothing을 표시해 준다.
- 포스팅 작성자에 원랜 이메일이 표시되었는데, 일반 sns처럼 닉네임이 표시되도록 하였다.

* user 모델 업데이트
- 프로필 사진과 닉네임 속성 추가
- 닉네임, 이메일 validates 추가

##### 서비스 명칭 : 혼밥감성 -> Spoon(스푼)

##### 서비스 컨셉
- 혼밥감성은 혼밥 족에 의한, 혼밥 족을 위한, 혼밥 족의 SNS이다.
- 혼밥감성은 혼밥을 하는 사람들이 혼자 먹은 메뉴사진과 함께 감성적인 이야기를 올리는 혼밥감성 Social network service 이다.
- 혼밥감성은 혼밥하는 혼밥감성 게시물과 함께 식당의 위치(location)를 함께 공유하여 혼밥을 하고싶은 사람들이 해당 게시물에 올라온 맛집을 찾을수 있도록 도움을 주는 플랫폼(SNS)이다.


## 2. 역할분담 내용
* 준혁: Control 코드 구축 및 전체 프로젝트 총괄
* 민석: 서비스 기획, Model 구축 및 책임
* 호령: View 구축 및 책임

## 3. 조원별 오류 내용
* Comments 연동 후 관계 설정
- Comment 모델과 User, Pin 모델과의 관계설정
- 댓글 작성자의 email을 가져오지 못해 No Method 오류가 발생하는 것
의 문제가 발생함
- 타인의 댓글까지 모두 Delete 버튼이 생성되는 것


## 4. 해결방법
##### 1) Comment, User, Pin 모델 관계설정
Stackoverflow를 통해 rails devise user post comment 검색을 통해 관계설정의 전반적인 흐름을 알아보았다. post와 comment는 user에, comment는 post에 속해 있어야 하며, post는 다수의 comments를, user은 다수의 comments를 가질 수 있다.

그리고 rails g migraition을 통해 comment와 post에 각가 user_id 칼럼을 추가하여 각 commen, post가 생성 될 때마다 current_user의 id를 저장하였다.


```
#bash
$rails g migration add_user_id_to_posts user_id:integer:index
$rails g migration add_user_id_to_comments user_id:integer:index

#user.rb
has_many :posts,    dependent: :destroy
has_many :comments

#post.rb
has_many :comments, dependent: :destroy
elongs_to :user

#comment.rb
belongs_to :user
belongs_to :post
```


##### 2) 댓글 작성자의 email을 가져오지 못해 No Method 오류가 발생하는 것
comment에 rails g migraition을 통해 comment 모델에 user_email 칼럼을 추가하여, current_user가 comment를 달때마다 current_user의 email을 저장하였다.

- bash

```
$rails g migration add_user_email_to_comments user_email:string
```

- comments_controller.rb

```
@comment.user_email = current_user.email
```

##### 3) 타인의 댓글까지 모두 Delete 버튼이 생성되는 것
pin에 달려있는 comment의 user_id와 current_user(현재 로그인 되어 있는 사용자)의 id를 비교하여 같은 경우 delete 버튼이 달리도록 하였다.

- comment.html.haml

```
-if user_signed_in?
  - if comment.user_id == current_user.id
    %p
     = link_to 'Delete', [comment.pin, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure? '}
```

###### 6) 내 포스트가 아닐경우 delete와 edit 버튼 가리기
views/pins/show.html.haml

```
- if user_signed_in?
  - if current_user.id == @pin.user_id
    = link_to "Edit", edit_pin_path, class: "btn btn-default"
    = link_to "Delete", pin_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
```

## 5. 모델 속성 정보
1. User
 |id | email | nickname | password | profile_image |
|--------|--------|--------|--------|--------|
 integer | string | string | string | string 

2. Pin(Post)
|id|title|description|user_id|image|
|--------|--------|--------|--------|--------|
|integer|string|text|integer|string|

3. comment
|id|description|user_id|pin_id|user_nickname|user_email|
|--------|--------|--------|--------|--------|--------|
|integer|text|integer|integer|string|string|


## 6. 사용한 Gem 정리

```
gem 'rails_db'
gem 'acts_as_votable', '~> 0.11.1'
gem 'masonry-rails', '~> 0.2.4'
gem 'paperclip', '~> 6.0'
gem 'devise', '~> 4.4', '>= 4.4.3'
gem 'simple_form', '~> 4.0', '>= 4.0.1'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
gem 'haml', '~> 5.0', '>= 5.0.4'
```

## 7. 참고문서 링크
https://github.com/twbs/bootstrap-rubygem

https://getbootstrap.com

https://m.blog.naver.com/PostView.nhn?blogId=qls0147&logNo=220627002837&proxyReferer=https%3A%2F%2Fwww.google.co.kr%2F

https://stackoverflow.com

https://fontawesome.com/icons/exclamation-triangle?style=solid


## 8. 완성본 스크린샷
updated page: mypage

![mypage_jun](https://user-images.githubusercontent.com/28127231/40716593-7d0cd95a-6444-11e8-8ec4-530c9c84fb6d.png)

page1

![main page](https://user-images.githubusercontent.com/28127231/40472283-f637a916-5f73-11e8-93a0-0af11a927fbc.png)

page2

![comment](https://user-images.githubusercontent.com/28127231/40472282-f60025c2-5f73-11e8-82a3-7ccc1acd9d00.png)

page3

![my page](https://user-images.githubusercontent.com/28127231/40472284-f66ccb46-5f73-11e8-8480-29b2c59e7f00.png)

## 9. 추후 추가할 것
- 글들을 보여주는 show와 index부분의 글과 제목, 내용 뿐만아니라 글 작성자의 프로필 사진 노출시키기 (size 약 50x50: 인스타와 유사하게)
- 댓글 좋아요 기능

| column | column |
|--------|--------|
|        |        |
