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

    <a-row :gutter="30" class="group">
      <a-col :span="3" class="title">TITAN</a-col>
      <a-col :span="21">
        <a-tabs defaultActiveKey="1" tabPosition="left">
          <a-tab-pane tab="普通文档" key="1">
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
            <a-col :span="6">
              <img src="@/components/Docs/it/sys/titan/sl/cover.svg" alt="" class="cover">
            </a-col>
            <a-col :span="6">
              <router-link :to="{ name: 'docs-it-sys-titan-lantern' }">
                <img src="@/components/Docs/it/sys/titan/lantern/cover.svg" alt="" class="cover">
              </router-link>
            </a-col>
          </a-tab-pane>
          <a-tab-pane tab="异常处理" key="2">

          </a-tab-pane>
          <a-tab-pane tab="管理员" key="3">
            <a-col :span="6">
              <router-link :to="{ name: 'docs-it-sys-titan-serviceguard' }">
                <img src="@/components/Docs/it/sys/titan/serviceguard/cover.svg" alt="" class="cover">
              </router-link>
            </a-col>
            <a-col :span="6">
              <router-link :to="{ name: 'docs-it-sys-titan-pkg' }">
                <img src="@/components/Docs/it/sys/titan/pkg/cover.svg" alt="" class="cover">
              </router-link>
            </a-col>
          </a-tab-pane>

        </a-tabs>
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
.group
  margin 20px 0
  padding 20px 0
  border-top 1px dashed #000
.title
  font-size 2.5em
  font-weight bold
  color #555
.cover
  width 150px
  height 150px
</style>
