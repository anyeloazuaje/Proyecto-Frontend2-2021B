<template>
  <v-app>
    <v-container>
      <div v-if="loading">
        <Spinner />
      </div>
      <template v-else>
      <template v-if="esAdmin">
        <v-container class="my-5">
          <v-row class="flex align-center justify-space-between">
            <v-col class="justify-start" cols="12 text-center" sm="4"> </v-col>
            <v-col class="justify-end" cols="12 text-center" sm="4">
              <v-btn
                @click="$router.push('/crear-noticia')"
                color="primary darken-1 "
                elevation="2"
                fab
                medium
              >
                <v-icon dark medium> mdi-earth-plus </v-icon>
              </v-btn>
            </v-col>
          </v-row>
        </v-container>
      </template>
        <template v-if="noticias.length">
          <v-simple-table class="mb-5">
            <template v-slot:default>
              <thead>
                <tr class="primary darken-1">
                  <th class="white--text text-left">Titulo</th>
                  <th class="white--text text-left">Autor</th>
                  <th class="white--text text-left">Categoria</th>
                  <th class="white--text text-left">Descripción</th>
                  <th class="white--text text-left">Fecha</th>
                  <th class="white--text text-left">Imagen</th>
                  <template v-if="esAdmin">
                  <th class="white--text text-left">Acciones</th>
                  </template>
                </tr>
              </thead>
              <tbody>
                <tr v-for="noticia in noticias" :key="noticia.id">
                  <td>{{ noticia.titulo.substring(0,13) }}...</td>
                  <td>{{ noticia.id_autor }}</td>
                  <td>{{ noticia.id_categoria }}</td>
                  <td>
                    {{ noticia.descripcion.substring(0, 10) }}
                    <small>...</small>
                  </td>
                  <td>{{ fechaConFormato(noticia.fecha) }}</td>
                  <td class="ocultar-noticia">
                    <img
                      class="imagen-noticia"
                      :src="noticia.url_imagen"
                      alt="imagen-noticia"
                    />
                  </td>
                  <template v-if="esAdmin">
                  <td>
                    <v-btn
                      :loading="deshabilitado"
                      fab
                      dark
                      small
                      color="error"
                      title="Eliminar Noticia"
                      @click="eliminarNoticia(noticia)"
                    >
                      <v-icon dark> mdi-earth-minus</v-icon>
                    </v-btn>
                    <v-btn
                      :loading="deshabilitado"
                      class="ml-2"
                      fab
                      dark
                      small
                      color="info"
                      title="Editar Noticia"
                      @click="$router.push(`/editar-noticia/${noticia.id}`)"
                    >
                      <v-icon dark> mdi-earth-arrow-right </v-icon>
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
            No existen noticias registradas.
            <v-icon color="teal"> mdi-earth </v-icon>
          </h3>
        </template>
      </template>
    </v-container>
  </v-app>
</template>

<script>
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner.vue";
export default {
  name: "Noticias",
  components: {
    Spinner,
  },
  data() {
    return {
      loading: false,
      deshabilitado: false,
      noticias: [],
    };
  },
  computed:{
    esAdmin() {
      return this.$store.getters.esAdmin;
  },
  },
  methods: {
    eliminarNoticia(noticiaInfo) {
      Swal.fire({
        title: "Eliminar noticia",
        text: `¿Estas seguro en eliminar la noticia con titulo: ${noticiaInfo.titulo}?`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#2196F3",
        cancelButtonText: "No, Cerrar modal",
        confirmButtonText: "Si, Eliminar",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-noticia/${noticiaInfo.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.obtenerNoticias();
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
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
    fechaConFormato(noticia) {
      const newNoticia = new Date(noticia);
      return newNoticia.toLocaleDateString();
    },
    async obtenerNoticias() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-noticias");
        this.noticias = data;
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.error("error", error.response.data.msg);
      }
    },
  },
  created() {
    this.obtenerNoticias();
  },
};
</script>



<style scoped>
.imagen-noticia {
  margin-top: 1em;
  border-radius: 3em;
  width: 50px;
  height: 50px;
}
@media only screen and (max-width: 680px) {
  .ocultar-noticia{
    display: none;
  }
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
    content: "Titulo";
  }
  td:nth-of-type(2):before {
    content: "Autor";
  }
  td:nth-of-type(3):before {
    content: "Categoría";
  }
  td:nth-of-type(4):before {
    content: "Descripción";
  }
  td:nth-of-type(5):before {
    content: "Fecha";
  }
 
  td:nth-of-type(7):before {
    content: "Acciones";
  }
}
</style>
