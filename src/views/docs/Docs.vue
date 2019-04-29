<template>
  <router-view></router-view>
</template>

<script>
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
  name: 'Docs',
  updated () {
    console.log()
  }
}
</script>

<style lang='stylus'>
.markdown-body
  h1
    font-size 35px
    font-weight bold
  h2
    font-size 32px
    font-weight bold
  h3
    font-size 28px
    font-weight bold
  h4
    font-size 24px
    font-weight bold
  h5
    font-size 23px
    font-weight bold
  h6
    font-size 22px
    font-weight bold
  p
    font-size 20px
.table-of-contents
  border-top 1px dashed #000
  border-left 1px dashed #000
  position fixed
  ul
    list-style none
    margin 0
    padding .2em 1em
    li
      font-size 1em
      a
        color #536D88
</style>
