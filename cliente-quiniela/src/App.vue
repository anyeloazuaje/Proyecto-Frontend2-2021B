<template>
  <div>
    <Navbar />
    <div class="contenedor-vista">
      <transition name="animacion" mode="out-in">
        <router-view :key="$route.fullPath" />
      </transition>
    </div>
    <Footer />
  </div>
</template>

<script>
import Navbar from "@/components/Navbar.vue";
import Footer from "@/components/Footer.vue";
import { OBTENER_CLIENTE, MODIFICAR_COINS } from "@/store/types/";

export default {
  name: "App",
  components: {
    Navbar,
    Footer,
  },
  created() {
    this.$store.dispatch(OBTENER_CLIENTE);
    this.obtenerCoins();
  },
  methods: {
    async obtenerCoins() {
      const estaAutenticado = this.$store.getters.estaAutenticado;
      if (estaAutenticado) {
        const clienteID = this.$store.getters.idCliente;
        const { data } = await this.axios.get(
          `/cliente/obtener-coins/${clienteID}`
        );
        this.$store.dispatch(MODIFICAR_COINS, data);
        return;
      }
    },
  },
};
</script>
<style>
.animacion-enter-active,
.animacion-leave-active {
  transition: opacity 0.5s;
}
.animacion-enter,
.animacion-leave-to {
  opacity: 0;
}
.contenedor-vista {
  min-height: 100vh;
}
</style>