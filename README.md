# Covid19View
*edit by ominiv*

shiny R package를 통해 국내외 Covid19 발생현황을 보여주고 추후 어떻게 증감될 것인지 예측해보자.

---
## 결과물
---
## 수행 과정
- 22.02.06 : shiny R package 사전조사
- 22.02.07 : api 적용 & leafletplot 추가
- 22.02.08 : 국내외 데이터셋 구축 & leafletplot 수정
- 22.02.09 : 세계지도 shp파일 적용 
- 22.02.10 : layout 구성 완료
- 22.02.11 : 예측 모델링
- 22.02.12 : 배포예정
---
### 아쉬운점
---
## Reference

<details>
<summary> 참고 자료 </summary>
<div markdown="1">

- [corona-live](https://corona-live.com/)
- [대한민국 SHP](http://www.gisdeveloper.co.kr/?p=2332)
- [SHP파일 적용예시](https://kuduz.tistory.com/1196)
- [지도시각화 참고자료](https://ysuks.shinyapps.io/dashboard/)
- [세계지도시각화 참고자료](https://dschloe.github.io/r/shiny/project_06_02/)
- [layout 참고](https://superkong1.tistory.com/15)
- [leaflet desc](https://inziwiduk.blogspot.com/2019/01/r-shiny-interactive-mapping.html)
- [위젯참고](https://wikidocs.net/71930)
</div>
</details>

<details>
<summary> 데이터 출처 </summary>
<div markdown="1">

- [World_covid19 : 공공데이터활용지원센터_보건복지부 코로나19해외발생 현황](https://www.data.go.kr/iim/api/selectAPIAcountView.do)
- [Korea_*_covid19 : 공공데이터활용지원센터_보건복지부 코로나19 시·도발생 현황](https://www.data.go.kr/iim/api/selectAPIAcountView.do)
- [TL_SCCO_CTPRVN.shp : KOREA SHP FILE](http://www.gisdeveloper.co.kr/?p=2332)
- [WORLD SHP FILE](https://hub.arcgis.com/datasets/UIA::uia-world-countries-boundaries/about)
</div>
</details>


