<template>
  <div class="account-settings-info-view">
    <a-row :gutter="16">
      <a-col :md="24" :lg="16">

        <a-form
          layout="vertical"
          :form="form"
          @submit="handleSubmit"
        >
          <a-form-item label="用户名">
            {{ userInfo.username }}
          </a-form-item>
          <a-form-item
            label="真名"
          >
            <a-input v-decorator="rules.realname" />
          </a-form-item>
          <a-form-item
            label="电子邮件"
          >
            <a-input v-decorator="rules.email" />
          </a-form-item>
          <a-form-item
            label="手机"
          >
            <a-input v-decorator="rules.mobile" />
          </a-form-item>
          <a-form-item
            label="性别"
          >
            <a-radio-group v-decorator="rules.gender">
              <a-radio value="M">男</a-radio>
              <a-radio value="F">女</a-radio>
            </a-radio-group>
          </a-form-item>
          <a-form-item
            label="职位"
          >
            <a-input v-decorator="rules.job" />
          </a-form-item>
          <a-form-item
            label="简介"
          >
            <a-textarea rows="4" v-decorator="rules.brief" />
          </a-form-item>
          <a-form-item>
            <a-button type="default" class="reset-button" @click="handleResetFields">重置</a-button>
            <a-button type="primary" htmlType="submit">提交</a-button>
          </a-form-item>
        </a-form>

      </a-col>
      <a-col :md="24" :lg="8" :style="{ minHeight: '180px' }">
        <div class="ant-upload-preview" @click="$refs.modal.edit(1)" >
          <a-icon type="cloud-upload-o" class="upload-icon"/>
          <div class="mask">
            <a-icon type="plus" />
          </div>
          <img :src="userInfo.avatar"/>
        </div>
      </a-col>

    </a-row>

    <avatar-modal
      :avatar="user().avatar"
      @changeAvatar="handleAvatarChanged"
      ref="modal"
    >
    </avatar-modal>

  </div>
</template>

<script>
import AvatarModal from './AvatarModal'
import { mapGetters } from 'vuex'
import { getUser, changeProfile } from '@/api/user'

export default {
  components: {
    AvatarModal
  },
  data () {
    return {
      userInfo: {},
      form: this.$form.createForm(this)
    }
  },
  computed: {
    rules () {
      return {
        realname: [
          'realname',
          {
            initialValue: this.userInfo.realname,
            rules: [
              { required: true, max: 10, message: '不超过10个字符' }
            ]
          }
        ],
        email: [
          'email',
          {
            initialValue: this.userInfo.email,
            rules: [
              { required: false, type: 'email', message: '请输入正确的邮箱' }
            ]
          }
        ],
        mobile: [
          'mobile',
          {
            initialValue: this.userInfo.mobile,
            rules: [
              { required: false, max: 20, message: '不超过20个字符' }
            ]
          }
        ],
        gender: [
          'gender',
          {
            initialValue: this.userInfo.gender,
            rules: [
              { required: true }
            ]
          }
        ],
        job: [
          'job',
          {
            initialValue: this.userInfo.job,
            rules: [
              { required: false, max: 10, message: '不超过10个字符' }
            ]
          }
        ],
        brief: [
          'brief',
          {
            initialValue: this.userInfo.brief,
            rules: [
              { required: false, max: 50, message: '不超过50个字符' }
            ]
          }
        ]
      }
    }
  },
  methods: {
    ...mapGetters(['user']),
    getUserInfo () {
      const username = this.user().username
      getUser(username)
        .then(res => {
          this.userInfo = res
        })
    },
    handleAvatarChanged (avatar) {
      this.userInfo.avatar = avatar
      this.$store.commit('SET_AVATAR', avatar)
    },
    handleResetFields () {
      this.form.resetFields()
    },
    handleSubmit (e) {
      e.preventDefault()
      this.form.validateFields((err, values) => {
        if (!err) {
          changeProfile(values)
            .then(res => {
              this.$message.success('修改成功')
              this.getUserInfo()
            })
            .catch(err => {
              this.$message.error(`修改失败: ${err}`)
            })
        }
      })
    }
  },
  mounted () {
    this.getUserInfo()
  }
}
</script>

<style lang="less" scoped>
  .reset-button {
    margin-right: 25px;
  }

  .avatar-upload-wrapper {
    height: 200px;
    width: 100%;
  }

  .ant-upload-preview {
    position: relative;
    margin: 0 auto;
    width: 100%;
    max-width: 180px;
    border-radius: 50%;
    box-shadow: 0 0 4px #ccc;

    .upload-icon {
      position: absolute;
      top: 0;
      right: 10px;
      font-size: 1.4rem;
      padding: 0.5rem;
      background: rgba(222, 221, 221, 0.7);
      border-radius: 50%;
      border: 1px solid rgba(0, 0, 0, 0.2);
    }
    .mask {
      opacity: 0;
      position: absolute;
      background: rgba(0,0,0,0.4);
      cursor: pointer;
      transition: opacity 0.4s;

      &:hover {
        opacity: 1;
      }

      i {
        font-size: 2rem;
        position: absolute;
        top: 50%;
        left: 50%;
        margin-left: -1rem;
        margin-top: -1rem;
        color: #d6d6d6;
      }
    }

    img, .mask {
      width: 100%;
      max-width: 180px;
      height: 100%;
      border-radius: 50%;
      overflow: hidden;
    }
  }
</style>
