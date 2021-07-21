<template>
  <section>
    <mdb-modal :show="mostrarModal" @close="cerrarModal">
      <template v-if="cargando">
        <div class="my-5">
          <Spinner />
        </div>
      </template>
      <template v-else>
        <mdb-modal-header>
          <mdb-modal-title class="text-center"
            >{{ tituloFormulario }}
            <span class="trofeo"> <mdb-icon icon="trophy" /></span>
          </mdb-modal-title>
        </mdb-modal-header>
        <mdb-modal-body>
          <mdb-container>
            <template v-if="Object.keys(apuesta).length">
              <div class="d-flex justify-content-between">
                <p>
                  <span class="text-modal costo mr-2"
                    >Costo {{ apuesta.costo }} coins</span
                  >
                  <span class="usd"> <mdb-icon icon="donate" /> </span>
                </p>
                <p>
                  <span class="text-modal ganancia">
                    Ganancia: {{ apuesta.ganancia }} Coins
                  </span>
                  <span> <mdb-icon class="check" icon="check-circle" /> </span>
                </p>
              </div>
              <p class="text-center text-modal">
                <span class="fecha-resultado">
                  El resultado se definiria: {{ apuesta.fecha_resultado }}

                  <span>
                    <mdb-icon icon="calendar-check" />
                  </span>
                </span>
              </p>
              <h3 class="text-center titulo">
                Seleccionar Equipo <mdb-icon icon="mouse-pointer" />
              </h3>
              <div class="text-center">
                <div class="text-left">
                  <label for="equipo1" class="gray-text p-2"
                    >Seleccionar {{ apuesta.id_equipo1.nombre }}</label
                  >
                  <input
                    v-model="equipo"
                    type="radio"
                    :value="apuesta.id_equipo1.id"
                    id="equipo1"
                  />
                </div>
                <img
                  width="200"
                  :src="apuesta.id_equipo1.imagen"
                  :alt="apuesta.id_equipo1.nombre"
                />
                <p class="equipo">{{ apuesta.id_equipo1.nombre }}</p>
              </div>

              <div class="text-center">
                <div class="text-left">
                  <label for="equipo2" class="gray-text p-2"
                    >Seleccionar {{ apuesta.id_equipo2.nombre }}
                  </label>
                  <input
                    v-model="equipo"
                    type="radio"
                    :value="apuesta.id_equipo2.id"
                    id="equipo2"
                  />
                </div>
                <img
                  width="200"
                  :src="apuesta.id_equipo2.imagen"
                  :alt="apuesta.id_equipo2.nombre"
                />
                <p class="equipo">{{ apuesta.id_equipo2.nombre }}</p>
              </div>
              <mdb-btn
                class="btn btn-block"
                title="Apostar"
                :disabled="deshabilitado || !equipo"
                :icon="deshabilitado ? 'circle-notch' : 'dice'"
                :icon-class="deshabilitado ? 'fa-spin' : ''"
                color="primary"
                @click="crearApuesta"
                >Crear apuesta</mdb-btn
              >
            </template>
          </mdb-container>
        </mdb-modal-body>
      </template>
    </mdb-modal>
  </section>
</template>


<script>
import {
  mdbModal,
  mdbIcon,
  mdbContainer,
  mdbModalHeader,
  mdbModalTitle,
  mdbModalBody,
  mdbModalFooter,
  mdbBtn,
  mdbInput,
} from "mdbvue";
import { MODIFICAR_COINS } from "@/store/types";
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner";
export default {
  name: "ModalApuesta",
  components: {
    mdbModal,
    mdbIcon,
    mdbContainer,
    mdbModalHeader,
    mdbModalTitle,
    mdbModalBody,
    mdbModalFooter,
    mdbBtn,
    mdbInput,
    Spinner,
  },
  props: {
    mostrarModal: {
      type: Boolean,
      required: true,
    },
    tituloFormulario: {
      type: String,
      required: false,
    },
    apuestaID: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      cargando: false,
      deshabilitado: false,
      apuesta: {},
      equipo: "",
    };
  },
  watch: {
    mostrarModal() {
      if (this.mostrarModal) {
        this.obtenerDatosApuesta();
      }
    },
  },
  methods: {
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
    async crearApuesta() {
      if (!this.equipo || !JSON.stringify(this.equipo).length) {
        return this.mostrarMensaje("error", "Debes seleccionar un equipo");
      }
      try {
        this.deshabilitado = true;
        const apuestaCrear = {
          id_cliente: this.$store.getters.idCliente,
          id_equipo: this.equipo,
          id_apuesta: this.apuestaID,
        };
        const { data } = await this.axios.post(
          "/cliente/crear-apuestaCliente",
          apuestaCrear
        );
        this.mostrarMensaje("success", data.msg);
        this.deshabilitado = false;
        setTimeout(() => {
          this.obtenerCoins();
        }, 2500);
        this.cerrarModal();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
    async obtenerCoins() {
      const clienteID = this.$store.getters.idCliente;
      const { data } = await this.axios.get(
        `/cliente/obtener-coins/${clienteID}`
      );
      this.$store.dispatch(MODIFICAR_COINS, data);
      this.mostrarMensaje("success", "Coins sincronizados correctamente.");
      return;
    },
    async obtenerDatosApuesta() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get(
          `/obtener-apuesta/${this.apuestaID}`
        );
        this.apuesta = data[0];
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
    cerrarModal() {
      this.apuesta = {};
      this.equipo = "";
      this.cargando = false;
      this.deshabilitado = false;
      this.$emit("cerrar", false);
    },
  },
};
</script>

<style>
.text-modal {
  font-weight: bold;
  font-size: 1em;
  font-style: italic;
}
.ganancia {
  color: #1d8622 !important;
}
.check {
  color: #27d62e !important;
}
.costo {
  color: #dc4135 !important;
}
.usd {
  color: #fb4235 !important;
}
.trofeo {
  color: #ffc107;
}
.fecha-resultado {
  color: #4085e0;
}
.equipo {
  font-size: 2em;
  font-weight: normal;
  font-style: initial;
  font-family: "Trebuchet MS", "Lucida Sans Unicode", "Lucida Grande",
    "Lucida Sans", Arial, sans-serif;
}
</style>
