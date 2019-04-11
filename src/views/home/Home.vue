<template>
  <a-carousel autoplay>
    <div><h3>1</h3></div>
    <div><h3>2</h3></div>
    <div><h3>3</h3></div>
    <div><h3>4</h3></div>
  </a-carousel>
</template>

<script>
export default {
  name: 'Home'
}
</script>

<style lang="stylus">
.ant-carousel
  margin -25px
.slick-slide
  text-align: center
  height: 550px
  line-height: 550px
  overflow: hidden
  background-image: linear-gradient(180deg, #8da4bb 25%, #a29b6d 100%)
</style>
