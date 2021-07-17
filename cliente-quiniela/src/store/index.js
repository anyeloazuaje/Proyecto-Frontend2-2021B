import Vue from 'vue'
import Vuex from 'vuex'
import {obtenerDatosToken} from '@/utils/token'
import {AUTENTICACION_TOKEN_CLIENTE} from '@/utils/constante'
import router from '@/router/index' 
import axios from 'axios';
import {SET_DATOS_CLIENTE, LOGOUT, OBTENER_CLIENTE, MODIFICAR_COINS} from './types/' 
Vue.use(Vuex)

const estadoInicial  =  {
  cliente:{},
  token:null,
  estaAutenticado:false
};
export default new Vuex.Store({
  state:estadoInicial,
  mutations: {
    establecerToken(state, payload){
      state.token = payload
    },
    establecerCliente(state, payload){
      state.cliente = payload
    },
    establecerAutenticado(state, payload){
      state.estaAutenticado = payload
    },
    establecerCoins(state,payload){
      state.cliente.coins = payload
    },
    reestablecerStore(state){
      state.token = null,
      state.cliente = {}
      state.estaAutenticado = false
    }
  },
  actions: {
    SET_DATOS_CLIENTE(context, payload) {
      const { id, nombre, correo, coins } = obtenerDatosToken(payload);
      const datosCliente = {
        id, nombre, correo, coins
      };
      localStorage.setItem(AUTENTICACION_TOKEN_CLIENTE, payload);
      axios.defaults.headers.common['Authorization'] = 'Bearer ' + payload;
      context.commit('establecerToken', payload);
      context.commit('establecerCliente', datosCliente);
      context.commit('establecerAutenticado', true);
    },
    LOGOUT(context){
      localStorage.removeItem(AUTENTICACION_TOKEN_CLIENTE);
      delete axios.defaults.headers.common['Authorization'];
      context.commit('reestablecerStore');
      router.push('/iniciar-sesion')
    },
    OBTENER_CLIENTE(context){
      const existeTokenCliente = localStorage.getItem(AUTENTICACION_TOKEN_CLIENTE)
      if(existeTokenCliente){
        return context.dispatch(SET_DATOS_CLIENTE, existeTokenCliente)
      }
      context.commit('reestablecerStore')
    },
    MODIFICAR_COINS(context, payload){
      context.commit('establecerCoins', payload)
    },
    },  
    getters:{
      estaAutenticado:state=>{
        return state.estaAutenticado
      },
      nombreCliente:state=>{
        return state.cliente.nombre
      },
      coinsCliente:state=>{
        return state.cliente.coins
      },
      idCliente:state=>{
        return state.cliente.id
      }
    }
  })
