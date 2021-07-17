<template>
  <section>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
      <template v-if="!seguimientos.length">
        <h3 class="mt-5 text-center font-weight-bold">
          No tienes seguimientos registrados
        </h3>
      </template>
      <template v-else>
        <mdb-container>
          <h3 class="mt-5 text-center font-weight-bold titulo">
            Tus Seguimientos 
          </h3>
          <p class="text-center w-responsive mx-auto pb-5">
         Registro de los equipos favoritos que has seguido durante tu visita por la Quiniela
        </p>
          <table class="table my-5">
            <thead>
              <tr class="table-striped table-active">
                <th>Equipo</th>
                <th>Categoría</th>
                <th>Logo</th>
                <th>Fecha del seguimiento</th>
                <th>Acción</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="seguimiento in seguimientos" :key="seguimiento.id">
                <td>{{ seguimiento.id_equipo.nombre }}</td>
                <td>{{ seguimiento.id_equipo.categoria }} <mdb-icon :icon="iconoCategoria(seguimiento.id_equipo.categoria)" /></td>
                <td>
                  <img
                    :src="seguimiento.id_equipo.logo"
                    width="50"
                    height="50"
                    :alt="seguimiento.id_equipo.nombre"
                  />
                </td>
                <td>{{ formatearFecha(seguimiento.fecha) }}</td>
                <td>
                  <mdb-btn
                    size="sm"
                    color="danger"
                    title="Eliminar seguiminento"
                    :icon="deshabilitado ? 'circle-notch' : 'ban'"
                    :icon-class="deshabilitado ? 'fa-spin' : ''"
                    @click="eliminarEquipoSeguimiento(seguimiento)"
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
import Swal from "sweetalert2";
import { mdbBtn, mdbContainer,mdbIcon  } from "mdbvue";
import Spinner from "@/components/Spinner";
export default {
  name: "Seguimientos",
  components: {
    Spinner,
    mdbBtn,
    mdbIcon,
    mdbContainer,
  },
  data() {
    return {
      seguimientos: [],
      cargando: false,
      deshabilitado:false
    };
  },
  created() {
    this.obtenerSeguimientosDelCliente();
  },
  methods: {
    formatearFecha(fecha) {
      const newFecha = new Date(fecha);
      return newFecha.toLocaleString();
    },
    eliminarEquipoSeguimiento(seguimiento){
      Swal.fire({
        title: "Eliminar seguimiento",
        text: `¿Estas seguro en eliminar el seguimiento del equipo: ${seguimiento.id_equipo.nombre}?`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#26316d",
        cancelButtonText: "No, cancelar",
        confirmButtonText: "Si, eliminar seguimiento",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-seguimiento/${seguimiento.id}`
            );
            this.mostrarMensaje("success", data.msg);
            this.seguimientos = this.seguimientos.filter(
              (seguimientoActuales) => seguimientoActuales.id !== seguimiento.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarMensaje("error", error.response.data.msg);
        });
    },
     iconoCategoria(categoria) {
      if (categoria === "Fútbol") {
        return "futbol";
      } else if (categoria === "Beisbol") {
        return "baseball-ball";
      } else {
        return "basketball-ball";
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
    async obtenerSeguimientosDelCliente() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get(
          "/cliente/obtener-seguimientosCliente"
        );
        this.seguimientos = data;
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
  },
};
</script>

<style >
.table-active {
  --bs-table-accent-bg: #3f51b5;
  color: white;
}
</style>