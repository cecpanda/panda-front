<template>
  <a-tabs defaultActiveKey="cak" tabPosition="left">
    <a-tab-pane tab="CAK" key="cak"><cak/></a-tab-pane>
    <a-tab-pane tab="KOI" key="koi">koi</a-tab-pane>
    <a-tab-pane tab="RRS" key="rrs">rrs</a-tab-pane>
  </a-tabs>
</template>

<script>
export default {
  name: 'DocsItSysTitanProtocol',
  components: {
    cak: () => import('@/components/Docs/it/sys/titan/protocol/cak.md')
  }
}
</script>
