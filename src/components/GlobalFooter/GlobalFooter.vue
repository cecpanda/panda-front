<template>
  <div class="footer">
    <div class="links">
      <a href="/" target="_blank">首页</a>
      <a href="#">帮助</a>
      <a href="#">隐私</a>
      <a href="#">条款</a>
    </div>
    <div class="copyright">
      Copyright
      <a-icon type="copyright" /> 2019 <span>南京华东电子信息科技股份有限公司</span>
    </div>
  </div>
</template>

<script>
export default {
  name: 'GlobalFooter',
  data () {
    return {}
  }
}
</script>

<style lang="less" scoped>
.footer {
  padding: 0 16px;
  margin: 48px 0 24px;
  text-align: center;

  .links {
    margin-bottom: 8px;

    a {
      color: rgba(0, 0, 0, 0.45);

      &:hover {
        color: rgba(0, 0, 0, 0.65);
      }

      &:not(:last-child) {
        margin-right: 40px;
      }
    }
  }
  .copyright {
    color: rgba(0, 0, 0, 0.45);
    font-size: 14px;
  }
}
</style>
