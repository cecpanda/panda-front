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
  name: 'Docs'
}
</script>
