import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import axios from 'axios';
import VueAxios from 'vue-axios';
import 'bootstrap-css-only/css/bootstrap.min.css'
import 'mdbvue/lib/css/mdb.min.css'
import {ENDPOINT_BACKEND, AUTENTICACION_TOKEN_CLIENTE} from '@/utils/constante'
import './assets/bootstrap/bootstrap.min.css'
Vue.config.productionTip = false
axios.defaults.baseURL = ENDPOINT_BACKEND

const tokenCliente = localStorage.getItem(AUTENTICACION_TOKEN_CLIENTE);
if(tokenCliente){
  axios.defaults.headers.common['Authorization'] = 'Bearer ' + tokenCliente;
}else{
  delete axios.defaults.headers.common['Authorization'] 
}
Vue.use(VueAxios, axios);
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
