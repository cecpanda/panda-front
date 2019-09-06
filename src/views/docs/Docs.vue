<template>
  <div>
    <router-view></router-view>
    <a-back-top />
  </div>
</template>

<script>
// import 'animate.css'
import 'highlight.js/styles/github.css'
import 'github-markdown-css'
/*
或者也可以在 md 文件的头部加上 script 包裹起来的:
import 'highlight.js/styles/github.css'
import 'github-markdown-css'
export default {
}
*/
export default {
  name: 'Docs'
}
</script>

<style lang='stylus'>
.markdown-body
  h1
    font-size 35px
    font-weight bold
  h2
    margin-top 50px
    font-size 32px
    font-weight bold
  h3
    margin-top 30px
    font-size 28px
    font-weight bold
  h4
    margin-top 20px
    font-size 24px
    font-weight bold
  h5
    margin-top 10px
    font-size 23px
    font-weight bold
  h6
    font-size 22px
    font-weight bold
  p
    font-size 20px
.toc
  max-width 90%
  // border-top 1px dashed #000
  // border-left 1px dashed #000
  // position fixed
  // bottom 20%
  ul
    list-style none
    margin 0
    padding .2em 1em
    li
      font-size 1em
      padding .1em 0
      a
        color #536D88
</style>
