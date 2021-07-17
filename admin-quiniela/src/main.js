import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import vuetify from './plugins/vuetify'
import axios from 'axios';
import VueAxios from 'vue-axios';
import {ENDPOINT} from '@/utils/constante'
Vue.config.productionTip = false
axios.defaults.baseURL = ENDPOINT

const token = localStorage.getItem('autenticacion-token');
if(token){
  axios.defaults.headers.common['Authorization'] = 'Bearer ' + token;
}else{
  delete axios.defaults.headers.common['Authorization'] 
}

Vue.use(VueAxios, axios)
new Vue({
  router,
  store,
  vuetify,
  render: h => h(App)
}).$mount('#app')
