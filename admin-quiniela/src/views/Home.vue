<template>
  <v-app>
    <v-container class="mt-5">
      <div v-if="loading">
        <Spinner/>
      </div>
      <template v-else>
        <template v-if="clientes.length">
          <v-simple-table>
            <template v-slot:default>
              <thead>
                <tr class="teal darken-1 text-uppercase">
                  <th class="white--text text-left">#ID</th>
                  <th class="white--text text-left">Nombre</th>
                  <th class="white--text text-left">Correo</th>
                  <th class="white--text text-left">Coins</th>
                  <template v-if="esAdmin">
                  <th class="white--text text-left">Acciones</th>
                  </template>
                </tr>
              </thead>
              <tbody>
                <tr v-for="cliente in clientes" :key="cliente.id">
                  <td>{{ cliente.id }}</td>
                  <td>{{ cliente.nombre }}</td>
                  <td>{{ cliente.correo }}</td>
                  <td>{{ cliente.coins }} <small>Coins</small></td>
                  <template v-if="esAdmin">
                  <td>
                    <v-btn
                      :loading="deshabilitado"
                      fab
                      dark
                      small
                      color="error"
                      title="Eliminar Cliente"
                    >
                      <v-icon
                        dark
                        @click="eliminarCliente(cliente.id, cliente.nombre)"
                      >
                        mdi-account-minus</v-icon
                      >
                    </v-btn>
                    <v-btn
                      :loading="deshabilitado"
                      class="ml-2"
                      fab
                      dark
                      small
                      color="info"
                      title="Cambiar Clave"
                    >
                      <v-icon dark @click="abrirModalClave(cliente.id)">
                        mdi-lock
                      </v-icon>
                    </v-btn>
                  </td>
                  </template>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
        </template>
        <template v-else>
          <h3 class="text--darken-3 text-center">
          No existen clientes registrados. <v-icon color="primary">
             mdi-account-multiple
          </v-icon>
          </h3>
        </template>
      </template>
    </v-container>
    <ModalCambiarClave
      :mostrarModal="abrirModal"
      :clienteID="cliente && cliente"
      @cerrar="cerrarModal"
    />
  </v-app>
</template>

<script>
import Swal from "sweetalert2";
import ModalCambiarClave from '@/components/ModalCambiarClave.vue'
import Spinner from '@/components/Spinner.vue';
export default {
  name: "Home",
  components:{
    ModalCambiarClave,
    Spinner
  },
  data() {
    return {
      cliente:null,
      clientes: [],
      loading: true,
      deshabilitado: false,
      abrirModal:false,
    };
  },
  computed:{
    esAdmin() {
      return this.$store.getters.esAdmin;
    },
  },
  methods: {
    cerrarModal(){
      this.abrirModal=false;
      this.cliente=null
    },
    mostrarAlerta(tipoIcono, mensaje) {
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
    abrirModalClave(clienteSeleccionado){
      this.abrirModal = true;
      this.cliente = clienteSeleccionado
    },
     eliminarCliente(clienteID, clienteNombre) {
      Swal.fire({
        title: "Eliminar cliente",
        text: `¿Estas seguro en eliminar el cliente ${clienteNombre}? Al eliminar el cliente se removeran sus apuestas, seguimientos y solicitudes de recarga.`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#009688",
        cancelButtonText: "No, cancelar",
        confirmButtonText: "Si, Eliminar",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-cliente/${clienteID}`
            );
            this.deshabilitado = false;
            this.mostrarAlerta("success", data.msg);
            this.obtenerClientes();
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
    async obtenerClientes() {
      this.loading = true;
      try {
        const { data } = await this.axios.get("/obtener-clientes");
        this.clientes = data;
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
  },
  mounted() {
    this.obtenerClientes();
  },
};
</script>
<style scoped>
@media only screen and (max-width: 497px) {
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
    background: #d4d4d4;
  }

  td {
    border: none;
    border-bottom: 1px solid #ddd;
    position: relative;
    margin-left: 5em;
  }

  td:before {
    position: absolute;
    top: 0;
    left: -65px;
    white-space: nowrap;
    font-weight: bold;
  }

  td:nth-of-type(1):before {
    content: "#ID";
  }
  td:nth-of-type(2):before {
    content: "Nombre";
  }
  td:nth-of-type(3):before {
    content: "Correo";
  }
  td:nth-of-type(4):before {
    content: "Coins";
  }
  td:nth-of-type(5):before {
    content: "Acciones";
  }
}
</style>