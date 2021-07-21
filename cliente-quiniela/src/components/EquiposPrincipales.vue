<template>
  <section class="my-4">
    <h1 class="text-center font-weight-bold mt-5 titulo">
      Equipos Registrados
    </h1>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
      <mdb-container class="mt-5">
        <div v-if="!equipos.length">
          <h3 class="text-center font-weight-bold">
            No existen equipos registrados
          </h3>
        </div>
        <div v-else>
          <mdb-container>
            <mdb-row>
              <template v-for="equipo in equipos">
                <mdb-col sm="4" :key="equipo.id">
                  <mdb-card>
                    <mdb-view hover>
                      <router-link to="/">
                        <mdb-card-image
                          :src="equipo.url_imagen"
                        ></mdb-card-image>
                        <mdb-mask
                          flex-center
                          waves
                          overlay="white-slight"
                        ></mdb-mask>
                      </router-link>
                    </mdb-view>
                    <mdb-card-body>
                      <mdb-card-title class="text-center">{{
                        equipo.nombre
                      }}</mdb-card-title>
                      <hr />
                      <p class="font-small grey-dark-text text-center mb-0">
                        Director: {{ equipo.director }}
                      </p>
                    </mdb-card-body>
                    <mdb-card-footer
                      color="mdb-color"
                      class="lighten-3 p-0 text-center"
                    >
                      <ul class="list-unstyled list-inline font-small mt-3">
                        <li class="list-inline-item pr-2 white-text">
                          <mdb-icon far icon="user" class="pr-1" />Jugadores:
                          {{ equipo.jugadores }}
                        </li>
                      </ul>
                    </mdb-card-footer>
                  </mdb-card>
                </mdb-col>
              </template>
            </mdb-row>
          </mdb-container>
        </div>
      </mdb-container>
    </template>
  </section>
</template>

<script>
import {
  mdbContainer,
  mdbRow,
  mdbCol,
  mdbCard,
  mdbCardImage,
  mdbCardHeader,
  mdbCardBody,
  mdbCardTitle,
  mdbCardText,
  mdbCardFooter,
  mdbCardUp,
  mdbCardGroup,
  mdbBtn,
  mdbView,
  mdbMask,
  mdbIcon,
} from "mdbvue";

import Swal from "sweetalert2";
import Spinner from "@/components/Spinner.vue";
export default {
  name: "EquiposPrincipales",
  components: {
    Spinner,
    mdbContainer,
    mdbRow,
    mdbCol,
    mdbCard,
    mdbCardImage,
    mdbCardHeader,
    mdbCardBody,
    mdbCardTitle,
    mdbCardText,
    mdbCardFooter,
    mdbCardUp,
    mdbCardGroup,
    mdbBtn,
    mdbView,
    mdbMask,
    mdbIcon,
  },
  data() {
    return {
      cargando: false,
      equipos: [],
    };
  },
  created() {
    this.obtenerEquipos();
  },
  methods: {
    async obtenerEquipos() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get("/obtener-equipos");
        this.equipos = data.slice(0, 3);
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        Swal.fire("error", error.response.data.msg);
      }
    },
  },
};
</script>

<style scoped>
img {
  margin: 0 auto !important;
}
.img-fluid {
  max-height: 9em !important;
  margin: 0 auto !important;
  display: none;
}
</style>
