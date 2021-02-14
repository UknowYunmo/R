1. 데이터를 로드

build <- read.csv("building.csv" , header = T)
View(build)

2. na 를 0 으로 변경

build[is.na(build)] <- 0  
build

3. 필요한 변수만 선별\

build <- build[-1]   # 건물번호를 제외
build 

4. 연관규칙 패키지를 다운로드\

install.packages("arules")
library(arules) 

5. 연관규칙 모델을 생성

trans <- as.matrix(build , "Transaction") # 행렬로 변환
View(trans)

#설명: 지지도 0.2 이상이고 신뢰도 0.6 이상인 규칙을 만들어라 ~
rules1 <- apriori(trans , parameter = list(supp=0.2 , conf = 0.6 , target = "rules"))
rules1 

transactions class : 1과 0으로 이루어져 있는 데이터에서 0이 훨씬많을 때
(spase format - 희소 형태의 데이터). 

즉, 의미 없는 정보가 많고 크기가 커서 데이터를 처리하기 힘들 때 
transactions class로 처리한다

6. 연관규칙을 확인

inspect(sort(rules1))
inspect(rules1)

7. 시각화

# 여러 규칙들 중에서 보습학원 부분만 따로 검색
rules2 <- subset(rules1 , subset = lhs %pin% '보습학원' & confidence > 0.7)

# 설명: subset 함수는 전체 규칙에서 일부 규칙만 검색하는 함수 
inspect(sort(rules2))

# 여러 규칙들 중에서 편의점에 연관된 부분만 따로 검색
rules3 <- subset(rules1 , subset = rhs %pin% '편의점' & confidence > 0.7)
rules3
inspect(sort(rules3))

#visualization

b2 <- t(as.matrix(build)) %*% as.matrix(build)   # 희소행렬로 변경 

install.packages("sna")
install.packages("rgl")
library(sna)
library(rgl)

b2.w <- b2 - diag(diag(b2))  # 희소행렬의  대각선을 0으로 변경
rownames(b2.w) 
colnames(b2.w) 
b2.w

gplot(b2.w , displaylabel=T , vertex.cex=sqrt(diag(b2)) , vertex.col = "green" , edge.col="blue" , boxed.labels=F , arrowhead.cex = .7 , label.pos = 2 , edge.lwd = b2.w*2)

1)배치 관련
gmode= "digraph", "graph", "twomode"
mode= "fruchtermanreingold", "kamadakawai", "spring", 고유벡터에 기초한"eigen", "hall", "princoord", 다차원척도법 "mds", 임의화 "random", 원 "circle"

displayisolates = T or F, 고립 노드를 그릴 것인가

2)연결선(edge) 관련
userarrows = T or F , 화살표로 나타낼 것인가(T), 선분으로 나타낼 것인가(F)
edge.lwd =  선의 폭 지정
edge.lty =  solid, dashed, dotted 선의 유형
edge.col = 선의 색상
arrowhead.cex = 화살머리의 확대 배수
thresh = 선을 이 값 이상인 경우만 표현. 디폴트는 0
usecureve = 연결선을 곡선으로 나타냄
diag = 인접행렬의 대각성분이 있는 경우 T로 놓으면 루프로 표현됨.

3) 노드관련

vertex.cex = 노드 크기의 확대 배수
vertex.col = 노드의 색을 지정한다.
vertex.sides = 노드 다각형에서 변의 수. 12 이상으로 놓으면 거의 원형이 된다.
displaylabels = 노드 레이블을 표시하고자 하는 경우 T
label = 노드 레이블의 지정
boxed.labels = 노드레이블을 사각형으로 테두리하고 싶지 않은 경우 F
label.pos = 노드 레이블의 위치. 0은 중심에서 바깥쪽, 1은 아래, 2는 왼쪽, 3은 위쪽, 4는 오른쪽, 5는 중심.
label.col = 레이블 색상
label.cex, label.lwd, label.lty등이 있음 