<template>
     <div class="py-5 bg-light contacto-seccion">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-7 text-center">
        <h2 class="mb-3 text-white font-weight-medium">{{titulo}}</h2>
        <p class="font-weight-light text-white op-8">{{descripcion}}</p>
        <router-link  to="/contacto" class="btn btn-contacto btn-md border-0 text-white mt-3 text-uppercase" >
         Contáctanos <i class="fas fa-comments"></i>
        </router-link>
      </div>
    </div>
  </div>
</div>
</template>

<script>
export default {
name:"SeccionContacto",
data(){
  return{
    titulo:"¿Tienes alguna duda?",
    descripcion:"Como plataforma de juego más innovadora y segura del mundo, nos comprometemos a hacer todo lo posible por ayudar a nuestros usuarios a jugar de forma responsable y segura."
  }
}
}
</script>

<style>
.contacto-seccion {
  font-family: "Montserrat", sans-serif;
	color: #8d97ad;
  font-weight: 300;
  background-image: url(../assets/img/seccion-contacto.jpg);
	background-position: center top;
    background-size: cover;
    background-attachment: fixed;
}

.contacto-seccion h1, .contacto-seccion h2, .contacto-seccion h3, .contacto-seccion h4, .contacto-seccion h5, .contacto-seccion h6 {
  color: #3e4555;
}

.contacto-seccion .op-8 {
	opacity: 0.8;
}

.contacto-seccion .font-weight-medium {
	font-weight: 500;
}

.contacto-seccion .btn-contacto {
  background: #2e84ca;
  background: -webkit-linear-gradient(legacy-direction(to right), #ff4d7e 0%, #ff6a5b 100%);
  background: -webkit-gradient(linear, left top, right top, from(#ff4d7e), to(#ff6a5b));
  background: -webkit-linear-gradient(left, #ff4d7e 0%, #ff6a5b 100%);
  background: -o-linear-gradient(left, #ff4d7e 0%, #ff6a5b 100%);
  background: linear-gradient(to right, #ff4d7e 0%, #ff6a5b 100%);
}

 .contacto-seccion .btn-contacto:hover {
  background: #ff6a5b;
  background: -webkit-linear-gradient(legacy-direction(to right), #ff6a5b 0%, #ff4d7e 100%);
  background: -webkit-gradient(linear, left top, right top, from(#ff6a5b), to(#ff4d7e));
  background: -webkit-linear-gradient(left, #ff6a5b 0%, #ff4d7e 100%);
  background: -o-linear-gradient(left, #ff6a5b 0%, #ff4d7e 100%);
  background: linear-gradient(to right, #ff6a5b 0%, #ff4d7e 100%);
}

.contacto-seccion .btn-md {
  padding: 15px 45px;
  font-size: 16px;
}

</style>