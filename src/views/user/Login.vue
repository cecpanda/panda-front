<template>
  <div class="main">
    <a-form
      class="user-layout-login"
      ref="formLogin"
      :form="form"
      @submit="handleSubmit"
    >

      <a-tabs
        :activeKey="activeKey"
        size="large"
        :tabBarStyle="{ textAlign: 'center', borderBottom: 'unset' }"
        @change="handleTabClick"
      >
        <a-tab-pane key="tab1" tab="账号密码登录">
          <a-form-item>
            <a-input
              size="large"
              type="text"
              placeholder="请输入用户名"
              v-decorator="rules.username"
            >
              <a-icon slot="prefix" type="user" />
            </a-input>
          </a-form-item>

          <a-form-item>
            <a-input
              size="large"
              type="password"
              autocomplete="false"
              placeholder="请输入密码"
              v-decorator="rules.password"
            >
              <a-icon slot="prefix" type="lock" />
            </a-input>
          </a-form-item>
        </a-tab-pane>

        <a-tab-pane key="tab2" tab="手机号登录">
          <a-form-item>
            <a-input
              size="large"
              type="text"
              placeholder="请输入手机号"
              v-decorator="rules.mobile"
            >
              <a-icon slot="prefix" type="mobile" />
            </a-input>
          </a-form-item>

          <a-row :gutter="16">
            <a-col class="gutter-row" :span="16">
              <a-form-item>
                <a-input
                  size="large"
                  type="text"
                  placeholder="验证码"
                  v-decorator="rules.captcha"
                >
                  <a-icon slot="prefix" type="mail"/>
                </a-input>
              </a-form-item>
            </a-col>
            <a-col class="gutter-row" :span="8">
              <a-button
                class="getCaptcha"
                tabindex="-1"
                @click.stop.prevent="getCaptcha"
                v-text="!state.smsSendBtn && '获取验证码' || (state.time+' s')"
              ></a-button>
            </a-col>
          </a-row>

        </a-tab-pane>
      </a-tabs>

      <a-form-item>
        <a-checkbox :checked="true">自动登录</a-checkbox>
        <a class="forge-password" @click="handleForgetPassword">忘记密码</a>
      </a-form-item>

      <a-form-item style="margin-top:24px">
        <a-button
          size="large"
          type="primary"
          htmlType="submit"
          class="login-button"
          :loading="state.loginBtn"
          :disabled="state.loginBtn"
        >登录</a-button>
      </a-form-item>

      <div class="user-login-other">
        <span>预留登录方式</span>
        <a>
          <a-icon class="item-icon" type="wechat"></a-icon>
        </a>
        <a>
          <a-icon class="item-icon" type="qq"></a-icon>
        </a>
        <a>
          <a-icon class="item-icon" type="alipay-circle"></a-icon>
        </a>
        <router-link
          class="register"
          :to="{ name: 'register' }"
        >注册账户</router-link>
      </div>
    </a-form>
  </div>
</template>

<script>
// import md5 from 'md5'
import { mapActions, mapGetters } from 'vuex'
import { timeFix, welcome } from '@/utils/util'
import { getSmsCaptcha } from '@/api/login'

export default {
  name: 'Login',
  data () {
    return {
      activeKey: 'tab1',
      form: this.$form.createForm(this),
      form1: {
        username: '',
        password: '',
        mobile: '',
        captcha: ''
      },
      state: {
        time: 60,
        loginBtn: false,
        smsSendBtn: false
      },
      rules: {
        username: [
          'username',
          {
            rules: [
              { required: true, message: '请输入用户名' }
            ],
            validateTrigger: 'change'
          }
        ],
        password: [
          'password',
          {
            rules: [
              { required: true, message: '请输入密码' }
            ],
            validateTrigger: 'blur'
          }
        ],
        mobile: [
          'mobile',
          {
            rules: [
              { required: true, pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号' }
            ],
            validateTrigger: 'change'
          }
        ],
        captcha: [
          'captcha',
          {
            rules: [
              { required: true, message: '请输入验证码' }
            ],
            validateTrigger: 'blur'
          }
        ]
      }
    }
  },
  methods: {
    ...mapActions(['Login', 'Logout', 'InitLoginStatus']),
    ...mapGetters(['loginStatus']),
    handleTabClick (key) {
      this.activeKey = key
      if (key === 'tab2') {
        this.state.loginBtn = true
      } else {
        this.state.loginBtn = false
      }
      // this.form.resetFields()
    },
    getCaptcha (e) {
      e.preventDefault()
      const { form: { validateFields }, state } = this

      validateFields(['mobile'], { force: true }, (err, values) => {
        if (!err) {
          state.smsSendBtn = true

          const interval = window.setInterval(() => {
            if (state.time-- <= 0) {
              state.time = 60
              state.smsSendBtn = false
              window.clearInterval(interval)
            }
          }, 1000)

          const hide = this.$message.loading('验证码发送中..', 0)
          getSmsCaptcha({ mobile: values.mobile }).then(res => {
            setTimeout(hide, 2500)
            this.$notification['info']({
              message: '说明: 此功能暂不可用！',
              description: '验证码获取成功，您的验证码为：' + res.result.captcha,
              duration: 5
            })
          }).catch(err => {
            setTimeout(hide, 1)
            clearInterval(interval)
            state.time = 60
            state.smsSendBtn = false
            this.$notification['error']({
              message: '错误',
              description: ((err.response || {}).data || {}).message || '请求出现错误，请稍后再试',
              duration: 3
            })
          })
        }
      })
    },
    handleForgetPassword () {
      this.$notification['info']({
        message: '说明',
        description: '此功能暂不可用！',
        duration: 3
      })
    },
    handleSubmit (e) {
      e.preventDefault()
      this.state.loginBtn = true

      const {
        form: { validateFields },
        state,
        activeKey,
        Login
      } = this

      // this.form.validateFields(['username', 'password'],{force: true} (err, values) => {
      //   if (!err) {
      //     console.log(values)
      //   }
      // })

      const fields = activeKey === 'tab1' ? ['username', 'password']
        : ['mobile', 'captcha']

      validateFields(fields, { force: true }, (err, values) => {
        if (!err) {
          // values.password = md5(values.password)
          Login(values)
            .then((res) => {
              // console.log(res)
              this.$router.push({ name: 'index' })
              this.$notification.success({
                message: `${timeFix()}`,
                description: `${welcome()}`
              })
              setTimeout(() => {
                window.location.reload()
              }, 1000)
            })
            .catch((err) => {
              this.$notification['error']({
                message: '错误',
                description: ((err.response || {}).data || {}).message || '错误的账号或密码',
                duration: 3
              })
            })
        }
      })
      setTimeout(() => {
        state.loginBtn = false
      }, 500)
    }
  },
  async mounted () {
    // 此功能已经在 '@/permission.js' 中实现了
    //
    // await this.InitLoginStatus()
    // if (this.loginStatus()) {
    //   this.$notification.success({
    //     message: '你已经登录了',
    //     description: `${welcome()}`
    //   })
    //   this.$router.push({ name: 'account' })
    // }
  }
}
</script>

<style lang='stylus' scoped>
.user-layout-login
  label
    font-size 16px
  .anticon
    color: rgba(0, 0, 0, .35)
  .getCaptcha
    font-size 1.2em
    display block
    width 100%
    height 40px
  .forge-password
    float right
  button.login-button
    padding 0 15px
    font-size: 16px
    height 40px
    width 100%
  .user-login-other
    text-align: left
    margin-top: 24px
    line-height: 22px
    .item-icon
      font-size: 24px
      color: rgba(0, 0, 0, 0.2)
      margin-left: 16px
      vertical-align: middle
      cursor: pointer
      transition: color 0.3s
      &:hover
        color: #1890ff
    .register
      float right
</style>
