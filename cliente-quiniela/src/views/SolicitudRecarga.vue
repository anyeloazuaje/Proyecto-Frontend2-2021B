<template>
  <section>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
      <template v-if="!solicitudes.length || esEditar">
        <section class="my-5">
          <template v-if="!esEditar">
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
              Solicita recargar tus Coins
            </h2>
            <p class="text-center w-responsive mx-auto mb-5 gray-text">
              Completa los siguientes datos para solicitar una recarga de tus
              coins por parte de los administradores de La Quiniela. Ten en
              cuenta que la solicitud se creara solo
              <strong> cuando tu saldo sea inferior a 50 coins </strong>.
              Actualemente cuentas con
              <strong
                >{{ coinsCliente }} coins
                <mdb-icon icon="dollar-sign" /> </strong
              >.
              <template v-if="coinsCliente > 50">
                <p class="texto-accion-dinamico">
                  El formulario permanecera deshabilitado hasta que llegues al
                  rango de coins especificado.
                </p>
              </template>
              <template v-else>
                <p class="texto-accion-dinamico">
                  Puedes solicitar una recarga.
                </p>
              </template>
            </p>
          </template>
          <template v-else>
            <div class="contenedor-boton mb-3">
              <mdb-btn
                class="boton"
                title="Cancelar edición"
                color="danger"
                icon="ban"
                @click="limpiarDatosEdicion"
              />
            </div>
            <h2 class="h1-responsive font-weight-bold text-center my-5 titulo margin-top">
              Actualizar datos de la Solicitud
            </h2>
            <p class="text-center w-responsive mx-auto mb-5 gray-text">
              Completa los datos para actualizar la solicitud de recarga en
              espera, recuerda que el número de tarjeta debe ser de 16 digítos.
            </p>
          </template>
          <section>
            <mdb-container>
              <mdb-row class="justify-content-center">
                <mdb-col lg="8" md="12" class="lg-0 mb-4">
                  <mdb-card>
                    <mdb-card-body>
                      <template v-if="!esEditar">
                        <div class="form-header titulo">
                          <h3 class="mt-2">
                            <mdb-icon icon="dollar-sign" /> Llena los datos para
                            solicitar una recarga
                          </h3>
                        </div>
                        <p class="dark-grey-text text-center">
                          Ten en cuenta que el número de tarjeta debe ser de 16
                          digítos y que solo puedes realizar una solicitud.
                        </p>
                      </template>
                      <div class="md-form">
                        <mdb-input
                          icon="user"
                          label="Nombre del titular"
                          iconClass="grey-text"
                          type="text"
                          v-model.trim="recarga.nombre"
                        />
                      </div>
                      <div class="md-form">
                        <mdb-input
                          icon="pen"
                          label="Apellido del titular"
                          iconClass="grey-text"
                          type="text"
                          v-model.trim="recarga.apellido"
                        />
                      </div>
                      <div class="md-form">
                        <div>
                          <select
                            v-model.trim="recarga.tarjeta"
                            class="custom-select"
                          >
                            <option class="d-none" disabled value="">
                              Seleccionar Tarjeta
                            </option>
                            <option
                              v-for="(tarjeta, indice) in tarjetasSelect"
                              :value="tarjeta"
                              :key="indice"
                            >
                              {{ tarjeta }}
                            </option>
                          </select>
                        </div>
                      </div>
                      <div class="md-form">
                        <mdb-input
                          v-model.trim="recarga.numero_tarjeta"
                          icon="money-check"
                          label="N° de tarjeta"
                          counter
                          iconClass="grey-text"
                          :small="`${recarga.numero_tarjeta.length} digítos`"
                          type="text"
                        />
                      </div>
                      <template v-if="!esEditar">
                        <div class="text-center">
                          <mdb-btn
                            @click="enviarFormulario"
                            class="btn-block"
                            :disabled="coinsCliente < 50 ? false : true"
                            title="Solicitar recarga"
                            color="danger"
                            :icon="
                              deshabilitado
                                ? 'circle-notch'
                                : 'hand-holding-usd'
                            "
                            :icon-class="deshabilitado ? 'fa-spin' : ''"
                            >Solicitar recarga
                          </mdb-btn>
                        </div>
                      </template>
                      <template v-else>
                        <div class="text-center">
                          <mdb-btn
                            @click="actualizarSolicitud"
                            class="btn-block"
                            title="Actualizar datos de la solicitud de recarga"
                            color="primary"
                            :disabled="deshabilitado"
                            :icon="
                              deshabilitado ? 'circle-notch' : 'check-circle'
                            "
                            :icon-class="deshabilitado ? 'fa-spin' : ''"
                            >Actualizar datos de la solicitud
                          </mdb-btn>
                        </div>
                      </template>
                    </mdb-card-body>
                  </mdb-card>
                </mdb-col>
              </mdb-row>
            </mdb-container>
          </section>
        </section>
      </template>
      <template v-else>
        <mdb-container>
          <h3 class="mt-5 text-center font-weight-bold titulo">
            Solicitud de recarga abierta
          </h3>
          <p class="dark-grey-text text-center w-responsive mx-auto pb-5">
            Solicitud de recarga en espera de confirmación del administrador. Al
            aprobar correctamente la solicitud se eliminar automaticamente del
            listado pendiente.
          </p>
          <table class="table my-5 justify-content-center">
            <thead>
              <tr class="table-striped table-active">
                <th>Usuario</th>
                <th>Nombre del titular</th>
                <th>Apellido del titular</th>
                <th>Tarjeta</th>
                <th>N° Tarjeta</th>
                <th>Tiempo transcurrido</th>
                <th>Acción</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="solicitud in solicitudes" :key="solicitud.id">
                <td class="cliente">{{ nombreCliente }}</td>
                <td>{{ solicitud.nombre }}</td>
                <td>{{ solicitud.apellido }}</td>
                <td>{{ solicitud.tarjeta }}</td>
                <td>{{ solicitud.numero_tarjeta }}</td>
                <td>{{ formatearFecha(solicitud.fecha) }}</td>
                <td>
                  <mdb-btn
                    color="danger"
                    title="Cancelar solicitud"
                   :disabled="deshabilitado"
                    :icon="deshabilitado ? 'circle-notch' : ''"
                    :icon-class="deshabilitado ? 'fa-spin' : ''"
                    @click="cancelarSolicitud(solicitud)"
                    ><mdb-icon
                      v-if="!deshabilitado"
                      size="lg"
                      fab
                      icon="creative-commons-nc"
                  /></mdb-btn>
                  <mdb-btn
                   :disabled="deshabilitado"
                    :icon="deshabilitado ? 'circle-notch' : 'id-card'"
                    :icon-class="deshabilitado ? 'fa-spin' : ''"
                    @click="editarSolicitud(solicitud)"
                    title="Editar solicitud"
                    class="white-text"
                  />
                </td>
              </tr>
            </tbody>
          </table>
        </mdb-container>
      </template>
    </template>
  </section>
</template>

<script>
import {
  mdbIcon,
  mdbContainer,
  mdbRow,
  mdbCol,
  mdbInput,
  mdbTextarea,
  mdbBtn,
  mdbCard,
  mdbCardHeader,
  mdbCardTitle,
  mdbCardFooter,
  mdbCardBody,
} from "mdbvue";
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner";
export default {
  name: "SolicitudRecarga",
  components: {
    Spinner,
    mdbIcon,
    mdbContainer,
    mdbRow,
    mdbCol,
    mdbInput,
    mdbTextarea,
    mdbBtn,
    mdbCard,
    mdbCardHeader,
    mdbCardTitle,
    mdbCardFooter,
    mdbCardBody,
  },
  data() {
    return {
      cargando: false,
      deshabilitado: false,
      solicitudes: [],
      esEditar: false,
      recarga: {
        tarjeta: "",
        nombre: "",
        apellido: "",
        id_cliente: "",
        numero_tarjeta: "",
      },
      tarjetasSelect: [
        "VISA",
        "MASTERCARD",
        "Paypal",
        "Amazon",
        "Skrill",
        "Airtm",
        "Otro",
      ],
    };
  },
  computed: {
    coinsCliente() {
      return this.$store.getters.coinsCliente;
    },
    nombreCliente() {
      return this.$store.getters.nombreCliente;
    },
  },
  created() {
    this.obtenerSolicitudes();
  },
  methods: {
    async obtenerSolicitudes() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get(
          "/cliente/obtener-solicitudRecargaCliente"
        );
        this.solicitudes = data;
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
    limpiarDatosEdicion() {
      this.esEditar = false;
      this.recarga = {
        tarjeta: "",
        nombre: "",
        apellido: "",
        id_cliente: "",
        numero_tarjeta: "",
      };
    },
    cancelarSolicitud(solicitud) {
      Swal.fire({
        title: "Cancelar solicitud de recarga",
        text: `¿Estas seguro en cancelar la solicitud de recarga pertenenciente al titular: ${solicitud.nombre}?`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#26316d",
        cancelButtonText: "No, cerrar confirmación",
        confirmButtonText: "Si, cancelar solicitud de recarga",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-solicitudRecarga/${solicitud.id}`
            );
            this.mostrarMensaje("success", data.msg);
            this.obtenerSolicitudes();
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarMensaje("error", error.response.data.msg);
        });
    },
    editarSolicitud(datosSolicitud) {
      this.esEditar = true;
      const { id, nombre, apellido, tarjeta, numero_tarjeta } = datosSolicitud;
      this.recarga = {
        id,
        nombre,
        apellido,
        tarjeta,
        numero_tarjeta: JSON.stringify(numero_tarjeta),
      };
    },
    formatearFecha(fechaFormatear) {
      const tiempoReferencia = new Date(fechaFormatear);
      return this.tiempoTranscurrido(tiempoReferencia);
    },
    tiempoTranscurrido(tiempoReferencia) {
      const segundosObtenidos = Math.floor(
        (new Date() - tiempoReferencia) / 1000
      );
      let intervaloReferencia = segundosObtenidos / 31536000;
      if (intervaloReferencia > 1) {
        return Math.floor(intervaloReferencia) + " Años";
      }
      intervaloReferencia = segundosObtenidos / 2592000;
      if (intervaloReferencia > 1) {
        return Math.floor(intervaloReferencia) + " Meses";
      }
      intervaloReferencia = segundosObtenidos / 86400;
      if (intervaloReferencia > 1) {
        return Math.floor(intervaloReferencia) + " Días";
      }
      intervaloReferencia = segundosObtenidos / 3600;
      if (intervaloReferencia > 1) {
        return Math.floor(intervaloReferencia) + " Horas";
      }
      intervaloReferencia = segundosObtenidos / 60;
      if (intervaloReferencia > 1) {
        return Math.floor(intervaloReferencia) + " Minutos";
      }
      return Math.floor(segundosObtenidos) + " Segundos";
    },
    async enviarFormulario() {
      if (
        !this.recarga.nombre ||
        !this.recarga.apellido ||
        !this.recarga.tarjeta ||
        !this.recarga.numero_tarjeta
      ) {
        this.mostrarMensaje(
          "error",
          "Todos los campos son obligatorios para solicitar una recarga."
        );
        return;
      }
      if (this.recarga.numero_tarjeta.length !== 16) {
        this.mostrarMensaje(
          "error",
          "El numero de tarjeta debe ser de  16 digítos."
        );
        return;
      }

      try {
        this.deshabilitado = true;
        const recargaCrear = JSON.parse(JSON.stringify(this.recarga));
        recargaCrear.id_cliente = this.$store.getters.idCliente;
        const { data } = await this.axios.post(
          "/cliente/solicitar-recarga",
          recargaCrear
        );
        this.mostrarMensaje("success", data.msg);
        this.obtenerSolicitudes();
        this.deshabilitado = false;
        this.recarga = {
          tarjeta: "",
          nombre: "",
          apellido: "",
          id_cliente: "",
          numero_tarjeta: "",
        };
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
    async actualizarSolicitud() {
      if (
        !this.recarga.nombre ||
        !this.recarga.apellido ||
        !this.recarga.tarjeta ||
        !this.recarga.numero_tarjeta
      ) {
        this.mostrarMensaje(
          "error",
          "Todos los campos son obligatorios para solicitar una recarga."
        );
        return;
      }
      if (this.recarga.numero_tarjeta.length !== 16) {
        this.mostrarMensaje(
          "error",
          "El numero de tarjeta debe ser de  16 digítos."
        );
        return;
      }
      try {
        this.deshabilitado = true;
        this.recarga.id_cliente = this.$store.getters.idCliente;
        const { data } = await this.axios.put(
          `cliente/actualizar-recarga/${this.recarga.id}`,
          this.recarga
        );
        this.mostrarMensaje("success", data.msg);
        this.obtenerSolicitudes();
        this.limpiarDatosEdicion();
        this.deshabilitado = false;
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarMensaje("error", error.response.data.msg);
        this.limpiarDatosEdicion();
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
.cliente {
  text-transform: capitalize;
}
.texto-accion-dinamico {
  color: #3c3c3c;
  font-weight: bold;
}
</style>
<style scoped>
.margin-top{
  margin-top:3em !important;
}
@media only screen and (max-width: 830px),
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
    content: "Usuario:";
  }
  td:nth-of-type(2):before {
    content: "Nombre del titular:";
  }
  td:nth-of-type(3):before {
    content: "Apellido del titular:";
  }
  td:nth-of-type(4):before {
    content: "Tarjeta:";
  }
  td:nth-of-type(5):before {
    content: "N° Tarjeta:";
  }
  td:nth-of-type(6):before {
    content: "Tiempo Transcurrido:";
  }
  td:nth-of-type(7):before {
    content: "Acción";
  }
}
.bg-table {
  background: #3c59a9;
  color: white;
}

</style>