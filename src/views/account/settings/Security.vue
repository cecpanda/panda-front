<template>
  <div>
    <a-list
      itemLayout="horizontal"
      :dataSource="data"
    >
      <a-list-item slot="renderItem" slot-scope="item, index" :key="index">
        <a-list-item-meta>
          <a slot="title">{{ item.title }}</a>
          <span slot="description">
            <span class="security-list-description">{{ item.description }}</span>
            <span v-if="item.value"> : </span>
            <span class="security-list-value">{{ item.value }}</span>
          </span>
        </a-list-item-meta>
        <template v-if="item.actions">
          <a slot="actions" @click="item.actions.callback">{{ item.actions.title }}</a>
        </template>

      </a-list-item>
    </a-list>
    <a-modal
      title="修改密码"
      :visible="passwordModalVisible"
      @ok="handleOk"
      @cancel="handleCancel"
    >
      <a-form layout="horizontal" :form="passwordForm">
        <a-form-item label="旧密码">
          <a-input type="password" v-decorator="rules.oldPassword" />
        </a-form-item>
        <a-form-item label="新密码">
          <a-input type="password" v-decorator="rules.newPassword" />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script>
import { changePassword } from '@/api/user'

export default {
  data () {
    return {
      passwordModalVisible: false,
      passwordForm: this.$form.createForm(this),
      rules: {
        oldPassword: [
          'old_password',
          {
            rules: [
              { required: true, message: '请输入旧密码' }
            ]
          }
        ],
        newPassword: [
          'new_password',
          {
            rules: [
              { required: true, message: '请输入新密码' }
            ]
          }
        ]
      },
      data: [
        { title: '账户密码', description: '当前密码强度', value: '强', actions: { title: '修改', callback: () => { this.passwordModalVisible = true } } },
        { title: '密保手机', description: '已绑定手机', value: '***********', actions: { title: '修改', callback: () => { this.$message.info('预留') } } },
        { title: '密保问题', description: '未设置密保问题，密保问题可有效保护账户安全', value: '', actions: { title: '设置', callback: () => { this.$message.info('预留') } } },
        { title: '备用邮箱', description: '已绑定邮箱', value: '******', actions: { title: '修改', callback: () => { this.$message.info('预留') } } },
        { title: 'MFA 设备', description: '未绑定 MFA 设备，绑定后，可以进行二次确认', value: '', actions: { title: '绑定', callback: () => { this.$message.info('预留') } } }
      ]
    }
  },
  methods: {
    handleOk (e) {
      e.preventDefault()
      this.passwordForm.validateFields((err, values) => {
        if (!err) {
          changePassword(values)
            .then(res => {
              this.$message.success('修改成功')
              this.passwordModalVisible = false
            })
            .catch(err => {
              this.$message.error(`修改失败: ${err.error}`)
            })
        }
      })
    },
    handleCancel () {
      this.passwordForm.resetFields()
      this.passwordModalVisible = false
    }
  }
}
</script>

<style scoped>

</style>
