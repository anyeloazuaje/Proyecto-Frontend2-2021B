<template>
  <mdb-card class="card-image background">
    <div class="text-white text-center py-5 px-4 my-5">
      <div>
        <h2 class="card-title h1-responsive pt-3 mb-5 font-bold">
          <strong>{{titulo}}</strong>
        </h2>
        <p class="mx-5 mb-5">
          {{descripcion}}
        </p>
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
  data(){
    return{
      titulo:"Envianos tus mensajes de contácto",
      descripcion:"Queremos esucharte y saber tu opinion en la Quiniela. Cuentanos tu experiencia y que cosas te gustaria que se agregaran."
    }
  }
};
</script>

<style scoped>
.background {
  background-image: url(../assets/img/hero-contacto.jpg);
  background-size: cover;
  background-color: #3f51b5;
  background-attachment: fixed;
  background-repeat: no-repeat;
}
</style>