<template>
  <div>
    <a-carousel autoplay>
      <div><h3>1</h3></div>
      <div><h3>2</h3></div>
      <div><h3>3</h3></div>
      <div class="jntm"><h3>ikun</h3></div>
    </a-carousel>
  </div>
</template>

<script>
export default {
  name: 'Home'
}
</script>

<style lang="stylus">
.ant-carousel
  margin -25px
  .slick-dots li button
    width 30px
    height 10px
.slick-slide
  text-align: center
  height: 550px
  line-height: 550px
  overflow: hidden
  background-image: linear-gradient(180deg, #8da4bb 25%, #a29b6d 100%)
.jntm
  // width 500px
  // height 500px
  // border 1px solid #000
  background-color #ccc
  background-image url('../../assets/images/cxk.jpg')
  background-size 100% 100%
  background-position center
</style>
