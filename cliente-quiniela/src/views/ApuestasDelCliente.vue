<template>
  <section>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
      <template v-if="!apuestasCliente.length">
        <h3 class="mt-5 text-center font-weight-bold">
          No tienes apuestas registradas
          <span class="apuesta-icon"> <mdb-icon icon="trophy" /> </span>
        </h3>
      </template>
      <template v-else>
        <div class="container">
          <h3 class="mt-5 text-center font-weight-bold titulo text-uppercase">
            Apuestas Registradas
            <span class="apuesta-icon"> <mdb-icon icon="trophy" /> </span>
          </h3>
          <p class="text-center w-responsive mx-auto pb-5 gray-text">
            Historial de las apuestas que has realizado en el transcurso de tu
            experiencia en la Quiniela.
          </p>
          <table class="table my-5">
            <thead>
              <tr class="table-striped table-active">
                <th>Apostaste por <mdb-icon icon="trophy" /></th>
                <th>Apuesta <mdb-icon icon="dice" /></th>
                <th>Fecha de la apuesta <mdb-icon icon="clock" /></th>
                <th>Estado <mdb-icon icon="dice-five" /></th>
                <th>Resulado <mdb-icon icon="crown" /></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="apuesta in apuestasCliente" :key="apuesta.id">
                <td>
                  <strong>
                    <img
                      width="50"
                      :src="apuesta.id_equipo.imagen"
                      :alt="apuesta.id_equipo.nombre"
                    />
                    <br />
                    {{ apuesta.id_equipo.nombre }}
                  </strong>
                </td>
                <td class="apuesta-td">
                  <strong>
                    {{ apuesta.id_apuesta.equipo1.nombre }}
                    <img
                      width="50"
                      :src="apuesta.id_apuesta.equipo1.imagen"
                      :alt="apuesta.id_apuesta.equipo1.nombre"
                    />
                    VS
                    <img
                      width="50"
                      :src="apuesta.id_apuesta.equipo2.imagen"
                      :alt="apuesta.id_apuesta.equipo1.nombre"
                    />
                    {{ apuesta.id_apuesta.equipo2.nombre }}
                  </strong>
                </td>
                <td>
                  <strong>{{ formatearFecha(apuesta.fecha) }}</strong>
                </td>
                <td>
                  {{
                    apuesta.apuesta_acertada
                      ? "Apuesta Acertada"
                      : "Apuesta No Acertada"
                  }}
                  <template v-if="apuesta.apuesta_acertada">
                    <span class="circle">
                      <mdb-icon size="lg" icon="check-circle" />
                    </span>
                  </template>
                  <template v-else>
                    <span class="error">
                      <mdb-icon icon="times-circle" size="lg" />
                    </span>
                  </template>
                </td>
                <td>
                  {{ apuesta.resultado ? apuesta.resultado : "Por Definirse" }}
                  <span class="definir"
                    ><mdb-icon
                      v-if="!apuesta.resultado"
                      size="lg"
                      icon="hourglass"
                    />
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>
    </template>
  </section>
</template>

<script>
import { mdbIcon } from "mdbvue";
import { MODIFICAR_COINS } from "@/store/types";
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner";
export default {
  name: "ApuestasDelCliente",
  components: {
    Spinner,
    mdbIcon,
  },
  data() {
    return {
      apuestasCliente: [],
      cargando: false,
    };
  },
  created() {
    this.obtenerApuestaCliente();
    this.obtenerCoins();
  },
  methods: {
    formatearFecha(fecha) {
      const newFecha = new Date(fecha);
      return newFecha.toLocaleDateString();
    },
    async obtenerCoins() {
      const clienteID = this.$store.getters.idCliente;
      const { data } = await this.axios.get(
        `/cliente/obtener-coins/${clienteID}`
      );
      this.$store.dispatch(MODIFICAR_COINS, data);
    },
    async obtenerApuestaCliente() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get(
          "/cliente/obtener-apuestasDelCliente"
        );
        this.apuestasCliente = data;
        this.cargando = false;
      } catch (error) {
        this.mostrarMensaje("error", error.response.data.msg);
        this.cargando = false;
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

<style scoped>
@media only screen and (max-width: 500px),
  (min-device-width: 768px) and (max-device-width: 1024px) {
  table,
  thead,
  tbody,
  th,
  td,
  tr {
    display: block;
  }

  thead tr {
    position: absolute;
    top: -9999px;
    left: -9999px;
  }

  tr {
    margin: 0 0 1rem 0;
    margin-top: 2em;
  }

  tr:nth-child(odd) {
    background: #ccc;
  }

  td {
    border: none;
    border-bottom: 1px solid #eee;
    position: relative;
    padding-left: 50%;
  }

  td:before {
    position: absolute;
    top: 0;
    left: 6px;
    width: 45%;
    padding-right: 10px;
    white-space: nowrap;
    font-weight: bold;
  }

  td:nth-of-type(1):before {
    content: "Apostaste por:";
  }
  td:nth-of-type(2):before {
    content: "Apuesta:";
  }
  td:nth-of-type(3):before {
    content: "Fecha de la apuesta:";
  }
  td:nth-of-type(4):before {
    content: "Estado:";
  }
  td:nth-of-type(5):before {
    content: "Resúltado:";
  }
}
.bg-table {
  background: #3c59a9;
  color: white;
}
.definir,
.apuesta-icon {
  color: #ffc400;
}
.apuesta-td {
  font-weight: bold;
}
.circle {
  color: #1add1a;
}
.error {
  color: #e74f4f;
}
</style>