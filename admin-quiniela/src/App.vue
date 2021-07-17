<template>
  <v-app>
    <v-main>
      <Sidebar v-if="renderizadoSidebar"/>
     <transition name="animacion" mode="out-in">
        <router-view  />
      </transition>
    </v-main>
  </v-app>
</template>

<script>
import Sidebar from './components/Sidebar.vue';
export default {
  components: { Sidebar },
  name: 'App',
  data: () => ({
  }),
  created(){   
  this.$store.dispatch('obtenerUsuario')
  },
  computed:{
    renderizadoSidebar(){
      return this.$store.state.estaAutenticado
    }
  }
};
</script>
<style scoped>
.animacion-enter-active,
.animacion-leave-active {
  transition: opacity 0.5s;
}
.animacion-enter,
.animacion-leave-to {
  opacity: 0;
}

</style>
