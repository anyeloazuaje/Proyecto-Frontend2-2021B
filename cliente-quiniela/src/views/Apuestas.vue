<template>
  <section>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
      <template v-if="!apuestas.length">
        <h3 class="mt-5 text-center font-weight-bold gray-text">
          No existen apuestas registradas actualmente.
        </h3>
      </template>
      <template v-else>
        <h2
          class="
            h1-responsive
            font-weight-bold
            text-center
            my-5
            titulo
            text-uppercase
          "
        >
          Apuestas registradas en La Quiniela
        </h2>
        <p class="text-center w-responsive mx-auto mb-5 gray-text">
          Proximás apuestas definidas. Puedes apostar eligiendo un equipo y
          participar para ganar recompenza de coins. Recuerda que para apostar
          debes iniciar sesión.
        </p>

        <section>
          <mdb-container>
            <mdb-row>
              <template v-for="(apuesta, iApuesta) in apuestas">
                <div
                  class="my-5 contenedor-apuesta text-center"
                  :key="iApuesta"
                >
                  <mdb-row
                    class="
                      d-flex
                      mt-5
                      align-content-center
                      justify-space-between
                    "
                  >
                    <mdb-col class="justify-end text-center" lg="4 " sm="4">
                      <img
                        class="imagen"
                        :src="apuesta.id_equipo1.imagen"
                        :alt="apuesta.id_equipo1.nombre"
                      />
                      <br />
                      <span class="mt-5">{{ apuesta.id_equipo1.nombre }} </span>
                    </mdb-col>

                    <mdb-col
                      class="justify-content-center text-center"
                      lg="4 "
                      sm="4"
                    >
                      <template v-if="estaAutenticado">
                        <mdb-btn
                          @click="crearApuesta(apuesta.id)"
                          icon="dice"
                          color="danger"
                          title="Crear apuesta"
                          >Apostar</mdb-btn
                        >
                      </template>
                      <template v-else>
                        <mdb-btn
                          title="Necesitas iniciar sesión"
                          :disabled="true"
                          color="danger"
                          class="mt-2 btn-block text-white"
                          icon="window-close"
                          >Necesitas inciar sesión</mdb-btn
                        >
                      </template>
                      <small class="d-block mt-3">
                        <strong>Fecha de la apuesta</strong>:
                        {{ apuesta.fecha_resultado }}</small
                      >
                    </mdb-col>
                    <mdb-col
                      class="justify-content-start text-center"
                      lg="4 "
                      sm="4"
                    >
                      <img
                        class="imagen"
                        :src="apuesta.id_equipo2.imagen"
                        :alt="apuesta.id_equipo2.nombre"
                      />
                      <br />

                      <span>
                        {{ apuesta.id_equipo2.nombre }}
                      </span>
                    </mdb-col>
                  </mdb-row>
                </div>
              </template>
            </mdb-row>
          </mdb-container>
          <hr />
          <h2
            class="
              h1-responsive
              font-weight-bold
              text-center
              my-5
              titulo
              text-uppercase
            "
          >
            Apuestas acertadas recientemente
          </h2>
          <template v-if="!apuestasGanadas.length">
            <h3 class="mt-5 text-center font-weight-bold gray-text">
              No existen apuestas acertadas por los clientes.
            </h3>
          </template>
          <template v-else>
            <mdb-container>
              <mdb-row>
                <template v-for="apuesta in apuestasGanadas">
                  <mdb-col
                    lg="4"
                    md="12"
                    class="mb-lg-0 mb-4"
                    :key="apuesta.id"
                  >
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
          </template>
        </section>
      </template>
    </template>
    <ModalApuesta
      :mostrarModal="mostrarModal"
      tituloFormulario="Apuesta en la Quiniela"
      :apuestaID="apuestaCrearID"
      @cerrar="cerrarModal"
    />
  </section>
</template>

<script>
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner";
import ModalApuesta from "@/components/ModalApuesta";
import {
  mdbContainer,
  mdbRow,
  mdbCard,
  mdbCol,
  mdbIcon,
  mdbCardImage,
  mdbCardBody,
  mdbCardTitle,
  mdbCardText,
  mdbBtn,
  mdbView,
  mdbMask,
} from "mdbvue";

export default {
  name: "Apuestas",
  components: {
    Spinner,
    mdbContainer,
    mdbRow,
    mdbCol,
    mdbCard,
    mdbIcon,
    mdbCardImage,
    mdbCardBody,
    mdbCardTitle,
    mdbCardText,
    mdbBtn,
    mdbView,
    mdbMask,
    ModalApuesta,
  },
  data() {
    return {
      apuestas: [],
      apuestasGanadas: [],
      cargando: false,
      deshabilitado: false,
      mostrarModal: false,
      apuestaCrearID: 0,
    };
  },
  created() {
    this.obtenenerApuestas();
    this.obtenerApuestasGanadas();
  },
  computed: {
    estaAutenticado() {
      return this.$store.getters.estaAutenticado;
    },
  },
  methods: {
    formatearFecha(fecha) {
      const fechaFormato = new Date(fecha);
      return fechaFormato.toLocaleDateString();
    },
    async obtenenerApuestas() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get("/obtener-apuestas");
        this.apuestas = data;
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
    async obtenerApuestasGanadas() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get("/obtener-apuestasGanadas");
        this.apuestasGanadas = data;
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
    cerrarModal() {
      this.mostrarModal = false;
      this.apuestaCrearID = 0;
    },
    crearApuesta(apuestaID) {
      this.apuestaCrearID = apuestaID;
      this.mostrarModal = true;
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

<style >
.contenedor-apuesta {
  background: #f7f6f6;
  padding: 2em;
  margin: 0em;
  border-radius: 2em;
  border-bottom: 2em;
  color: #3f51b5;
  font-weight: bold;
  border: 1px solid #607d8b;
}
.imagen {
  width: 200px;
}
.fecha {
  background: #eee;
  padding: 1em;
  border-radius: 2em;
  font-weight: bold;
}
.fecha-ganada {
  color: rebeccapurple;
}
.apuesta {
  color: #009688;
}
.equipo-ganador {
  color: green;
}
.resultado {
  color: #ff9800;
}
</style>