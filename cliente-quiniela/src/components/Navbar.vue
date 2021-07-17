<template>
  <mdb-navbar color="indigo" dark>
    <mdb-navbar-brand to="/"> La Quiniela </mdb-navbar-brand>
    <mdb-navbar-toggler>
      <mdb-navbar-nav class="margin-left">
        <mdb-nav-item to="/" active> Inicio</mdb-nav-item>
        <mdb-nav-item to="/noticias">Noticias</mdb-nav-item>
        <mdb-nav-item to="/equipos">Equipos</mdb-nav-item>
        <mdb-nav-item to="/">Apuestas</mdb-nav-item>
        <mdb-nav-item to="/contacto">Contacto</mdb-nav-item>

        <template v-if="!estaAutenticado">
          <mdb-nav-item to="/iniciar-sesion">Login</mdb-nav-item>
          <mdb-nav-item to="/registro">Registro</mdb-nav-item>
        </template>
        <template v-if="estaAutenticado">
          <mdb-nav-item @click="obtenerCoins"> Coins del cliente : <mdb-icon icon="dollar-sign"/> {{coinsCliente}} </mdb-nav-item>
          <mdb-dropdown tag="li" class="nav-item">
            <mdb-dropdown-toggle
              tag="a"
              navLink
              color="indigo"
              slot="toggle"
              waves-fixed
              ><i class="fas fa-user"></i
              ><span class="cliente">
                {{ nombreCliente }}
              </span></mdb-dropdown-toggle
            >
            <mdb-dropdown-menu class="color">
              <mdb-dropdown-item>Apuestas<mdb-icon class="pl-2" icon="trophy"/> </mdb-dropdown-item>
              <mdb-dropdown-item @click="$router.push('/seguimientos')">Equipos Seguidos  <mdb-icon class="pl-2" icon="heart" /> </mdb-dropdown-item>
              <mdb-dropdown-item @click="$router.push('/solicitud-recarga')">Solocitudes de recarga  <mdb-icon class="pl-2" icon="search-dollar" /> </mdb-dropdown-item>
              <mdb-dropdown-item class="salir" @click="logoutCliente">Salir <mdb-icon icon="sign-out-alt" /></mdb-dropdown-item>
            </mdb-dropdown-menu>
          </mdb-dropdown>
        </template>
      </mdb-navbar-nav>
    </mdb-navbar-toggler>
  </mdb-navbar>
</template>

<script>
import Swal from 'sweetalert2'
import {LOGOUT, MODIFICAR_COINS} from '@/store/types'
import {
  mdbDropdown,
  mdbDropdownToggle,
  mdbDropdownMenu,
  mdbDropdownItem,
  mdbContainer,
  mdbNavbar,
  mdbNavbarBrand,
  mdbNavbarToggler,
  mdbNavbarNav,
  mdbNavItem,
  mdbIcon
} from "mdbvue";
export default {
  name: "Navbar",
  components: {
    mdbNavbar,
    mdbNavbarBrand,
    mdbNavbarToggler,
    mdbNavbarNav,
    mdbNavItem,
    mdbContainer,
    mdbDropdown,
    mdbDropdownToggle,
    mdbDropdownMenu,
    mdbDropdownItem,
    mdbIcon
  },
  computed: {
    estaAutenticado() {
      return this.$store.getters.estaAutenticado;
    },
    nombreCliente() {
      return this.$store.getters.nombreCliente;
    },
    coinsCliente() {
      return this.$store.getters.coinsCliente;
    },
  },
  methods:{
     mostrarMensaje(tipoIcono, mensaje) {
      const Toast = Swal.mixin({
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });
      Toast.fire({
        icon: tipoIcono,
        title: mensaje,
      });
    },
    logoutCliente(){
      this.$store.dispatch(LOGOUT)
    },
     async obtenerCoins() {
      const estaAutenticado = this.$store.getters.estaAutenticado;
      if (estaAutenticado) {
        const clienteID = this.$store.getters.idCliente;
        const { data } = await this.axios.get(
          `/cliente/obtener-coins/${clienteID}`
        );
        this.$store.dispatch(MODIFICAR_COINS, data);
        this.mostrarMensaje('success', 'Coins sincronizados correctamente.')
        return;
      }
    },
  }
};
</script>
<style scoped>
.salir{
  color: white !important;
    background: #F44336;
    border-radius: 30em;
    padding: 4px 1px;
    text-align: center;
    font-size: 1em;
    font-weight: bold !important;
    font-style: oblique  !important;
    transition: .3s all;
}
.salir:hover{
    background: #ff685d;

}
.cliente {
  text-transform: capitalize;
}
.margin-left {
  margin-left: 24em;
}
.color {
  color: white;
}
@media screen and (max-width: 1261px) {
  .margin-left {
    margin: 0;
  }
}
</style>
