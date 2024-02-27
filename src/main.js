import { createApp } from 'vue'
import App from './App.vue'
import { globalVariable } from '../global'
// import 'bootstrap'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
//i18n
import i18n from './i18n/language';
// Vuetify
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'


//Vue-Router

const vuetify = createVuetify({
  components,
  directives,
})
// End Vuetify

import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css'

const app = createApp(App);
app.use(vuetify);
app.use(i18n);
app.component('VueDatePicker', VueDatePicker);
app.config.globalProperties.$globalVariable = globalVariable;





app.mount('#app');
