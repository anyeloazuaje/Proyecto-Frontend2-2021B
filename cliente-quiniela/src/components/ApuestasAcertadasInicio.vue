<template>
  <section class="my-4">
    <h1 class="text-center font-weight-bold mt-5 titulo">
      Clientes que han ganado apuestas recientemente
    </h1>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
      <mdb-container class="mt-5">
        <div v-if="!apuestasAcertadas.length">
          <h3 class="text-center font-weight-bold">
            No existen apuestas acertadas registradas.
          </h3>
        </div>
        <div v-else>
          <mdb-container>
            <mdb-row>
              <template v-for="apuesta in apuestasAcertadas">
                <mdb-col lg="4" md="12" class="mb-lg-0 mb-4" :key="apuesta.id">
                  <mdb-container>
                    <mdb-view hover class="rounded z-depth-2 mb-4">
                      <img
                        class="img-fluid"
                        src="@/assets/img/apuesta-img.jpeg"
                        :alt="apuesta.cliente"
                      />
                      <mdb-mask overlay="white-slight" waves />
                    </mdb-view>
                    <a class="green-text">
                      <h6 class="font-weight-bold mb-3">
                        <mdb-icon icon="user-circle" /> Cliente:
                        <a class="font-weight-bold">{{ apuesta.cliente }}</a>
                      </h6>
                    </a>
                    <h4 class="font-weight-bold mb-3">
                      <strong>{{ apuesta.titulo }}</strong>
                    </h4>
                    <p class="fecha-ganada">
                      <span class="clock">
                        <mdb-icon icon="clock" />
                      </span>
                      Fecha del resultado:
                      <a class="font-weight-bold">
                        {{ formatearFecha(apuesta.fecha) }}</a
                      >
                    </p>
                    <p class="apuesta">
                      <mdb-icon icon="dice" /> Apuesta realizada:
                      <a class="font-weight-bold">
                        {{ apuesta.id_apuesta.id_equipo1 }} VS
                        {{ apuesta.id_apuesta.id_equipo2 }}</a
                      >
                    </p>
                    <p class="equipo-ganador">
                      <mdb-icon icon="check-circle" /> Aposto por:
                      <a class="font-weight-bold"> {{ apuesta.id_equipo }}</a>
                    </p>
                    <p class="resultado">
                      <mdb-icon icon="trophy" /> Resultado:
                      <a class="font-weight-bold">
                        <span class="dark-grey-text">
                          {{ apuesta.resultado }}
                        </span>
                      </a>
                    </p>
                  </mdb-container>
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
import Spinner from "@/components/Spinner";
export default {
  name: "ApuestasAcertadasInicio",
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
      apuestasAcertadas: [],
    };
  },
  created() {
    this.obtenerApuestasGanadas();
  },
  methods: {
    formatearFecha(fecha) {
      const fechaFormato = new Date(fecha);
      return fechaFormato.toLocaleDateString();
    },
    async obtenerApuestasGanadas() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get("/obtener-apuestasGanadas");
        this.apuestasAcertadas = data.slice(0, 3);
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
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
  },
};
</script>

<style>
</style>