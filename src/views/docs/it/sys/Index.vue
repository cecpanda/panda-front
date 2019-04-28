<template>
  <div>
    <h1>信息工程部 运营系统科 文档中心</h1>
    <h2>TFT</h2>
    <ul>
      <li></li>
      <li></li>
    </ul>
    <h2>LCD</h2>
    <ul>
      <li></li>
      <li></li>
    </ul>
    <a-row>
      <a-col :span="4" class="title">TITAN</a-col>
      <a-col :span="20">
        <a-col :span="6">
          <router-link :to="{ name: 'docs-it-sys-titan-check' }">
            <img src="@/components/Docs/it/sys/titan/check/cover.svg" alt="" class="cover">
          </router-link>
        </a-col>
        <a-col :span="6">
          <router-link :to="{ name: 'docs-it-sys-titan-protocol' }">
            <img src="@/components/Docs/it/sys/titan/protocol/cover.svg" alt="" class="cover">
          </router-link>
        </a-col>

      </a-col>
    </a-row>
  </div>
</template>

<script>
export default {
  name: 'DocsItSys'
}
</script>

<style lang="stylus" scoped>
.title
  font-size 2.5em
  font-weight bold
  color #555
.cover
  width 150px
  height 150px
</style>
