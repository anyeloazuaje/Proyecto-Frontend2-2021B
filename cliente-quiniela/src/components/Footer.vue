<template>
  <mdb-footer color="indigo" class="font-small pt-0">
    <mdb-container>
      <mdb-row class="pt-5 mb-3 text-center d-flex justify-content-center">
        <mdb-col md="2" class="b-3">
          <h6 class="title font-weight-bold"><router-link to="/">Inicio</router-link></h6>
        </mdb-col>
        <mdb-col md="2" class="b-3">
          <h6 class="title font-weight-bold"><router-link to="/">Noticias</router-link></h6>
        </mdb-col>
        <mdb-col md="2" class="b-3">
          <h6 class="title font-weight-bold"><router-link to="/">Equipos</router-link></h6>
        </mdb-col>
        <mdb-col md="2" class="b-3">
          <h6 class="title font-weight-bold"><router-link to="/">Apuestas</router-link></h6>
        </mdb-col>
        <mdb-col md="2" class="b-3">
          <h6 class="title font-weight-bold"><router-link to="/">Contácto</router-link></h6>
        </mdb-col>
      </mdb-row>
      <hr class="rgba-white-light" style="margin: '0 15%'" />
      <mdb-row class="d-flex text-center justify-content-center mb-md-0 mb-4">
        <mdb-col md="8" sm="12" class="mt-5">
          <p style="lineHeight: '1.7rem'">Ya en el {{anioActual}}, con varios años en la red, La Quiniela es uno de los portales exitosos, considerado como una referencia en el ámbito de las apuestas deportivas online en Internet. El éxito se ha reflejado en el volumen de usuarios que visitan nuestra comunidad cada día.</p>
        </mdb-col>
      </mdb-row>
      <hr class="clearfix d-md-none rgba-white-light" style="margin: '10% 15% 5%'" />
      <mdb-row class="pb-3">
        <mdb-col md="12">
          <div class="mb-5 flex-center">
            <a class="fb-ic"><i class="fab fa-facebook fa-lg white-text mr-md-4"> </i></a>
            <a class="ins-ic"><i class="fab fa-instagram fa-lg white-text mr-md-4"> </i></a>
            <a class="pin-ic"><i class="fab fa-youtube fa-lg white-text"> </i></a>
          </div>
        </mdb-col>
      </mdb-row>
    </mdb-container>
    <div class="footer-copyright text-center py-3">
      <mdb-container fluid>
        &copy; {{anioActual}}  La Quiniela
      </mdb-container>
    </div>
  </mdb-footer>
</template>
<script>
  import { mdbFooter, mdbContainer, mdbRow, mdbCol } from 'mdbvue';
  export default {
    name: 'FooterPage',
    components: {
      mdbFooter,
      mdbContainer,
      mdbRow,
      mdbCol
    },
    computed:{
      anioActual(){
        return new Date().getFullYear();
      }
    }
  }
</script>

<style>

</style>