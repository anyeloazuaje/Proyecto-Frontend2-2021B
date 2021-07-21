<template>
  <mdb-card class="card-image background">
    <div class="text-white text-center py-5 px-4 my-5">
      <div>
        <h2 class="card-title h1-responsive pt-3 mb-5 font-bold">
          <strong>{{ titulo }}</strong>
        </h2>
        <p class="mx-5 mb-5">
          {{ descripcion }}
        </p>
        <template v-if="!estaAutenticado">
          <router-link to="/registro" class="link">
            <mdb-btn
              title="Registrate"
              rounded
              size="lg"
              icon="user-plus"
              class="radius boton"
              >¡Registrate!</mdb-btn
            >
          </router-link>
        </template>
        <template v-else>
          <router-link to="/apuestas" class="link">
            <mdb-btn
              title="Registrate"
              rounded
              size="lg"
              icon="trophy"
              class="radius boton"
              >¡Apostar!</mdb-btn
            >
          </router-link>
        </template>
      </div>
    </div>
  </mdb-card>
</template>
<script>
import { mdbCard, mdbBtn } from "mdbvue";
export default {
  name: "Hero",
  components: {
    mdbCard,
    mdbBtn,
  },
  data() {
    return {
      titulo: "Bienvenido al centro de apuestas La Quiniela",
      descripcion:
        "Elige ahora tu deporte favorito y apuesta con las mejores cuotas en tiempo real de forma fácil y Segura. La información más preciosa del mundo del periodismo deportivo Únete a nuestro equipo y recuerda ¡Nunca dejes de invertir en lo que te gusta!",
    };
  },
  computed: {
    estaAutenticado() {
      return this.$store.getters.estaAutenticado;
    },
  },
};
</script>
<style >
.link {
  text-decoration: none;
  color: white;
}
</style>
<style scoped>
.radius {
  border-radius: 3em !important;
  font-weight: bold;
  background-color: #d34040 !important;
  color: white;
}
.boton:hover {
  color: white;
  background-color: #eb6d6d !important;
}
.background {
  background-image: url(../assets/img/hero.jpg);
  background-size: cover;
  background-color: #3f51b5;
  background-attachment: fixed;
  background-repeat: no-repeat;
}
</style>
