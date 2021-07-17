<template>
  <section>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
      <template v-if="!noticias.length">
        <h3 class="mt-5 text-center font-weight-bold">
          No existen noticias registradas
        </h3>
      </template>
      <template v-else>
        <h2 class="h1-responsive font-weight-bold text-center my-5 titulo">
          Noticias publicadas en La Quiniela
        </h2>
        <p class="text-center w-responsive mx-auto mb-5 gray-text">
          Nos gusta mantener informado a nuestros clientes, es por ello que
          publicamos las últimas noticias del deporte en nuestro sitio web.
        </p>
        <div class="text-center">
          <select
            class="select"
            id="estatus-select"
            v-model="categoria"
            @change="filtrarNoticiaCategoria"
          >
            <option class="d-none" disabled :value="{}">
              Seleccionar Categoría
            </option>
            <option
              v-for="categoria in categorias"
              :key="`categoria-${categoria.id}`"
              :value="categoria.nombre"
            >
              Noticias de {{ categoria.nombre }}
            </option>
          </select>

          <mdb-btn
            flat
            title="Actualizar noticias"
            dark-waves
            icon="list"
            :disabled="cargando"
            class="btn-bordeado"
            @click="actualizarNoticia()"
          >
            Todas las noticias
          </mdb-btn>
        </div>

        <mdb-container class="my-5">
          <template v-for="noticia in noticias">
            <mdb-row :key="noticia.id">
              <mdb-col lg="5">
                <mdb-view class="rounded z-depth-2 mb-lg-0 mb-4" hover>
                  <img
                    class="img-fluid"
                    :src="noticia.url_imagen"
                    :alt="noticia.titulo"
                  />
                  <a>
                    <mdb-mask overlay="white-slight" waves />
                  </a>
                </mdb-view>
              </mdb-col>
              <mdb-col lg="7">
                <a class="green-text">
                  <h6 class="font-weight-bold mb-3">
                    <mdb-icon
                      :icon="iconoCategoria(noticia.id_categoria)"
                      class="pr-2"
                    />Categoría: {{ noticia.id_categoria }}
                  </h6>
                </a>
                <h3 class="font-weight-bold mb-3 p-0">
                  <strong>{{ noticia.titulo }}</strong>
                </h3>
                <p>{{ noticia.descripcion.substring(0, 255) }}...</p>
                <p>
                  <mdb-icon icon="user" />
                  Escrito por:
                  <a>
                    <strong>{{ noticia.id_autor }}</strong> </a
                  >, {{ formatearFecha(noticia.fecha) }}
                  <mdb-icon icon="calendar-alt" />
                </p>
                <mdb-btn
                  title="Leer noticia completa"
                  color="primary"
                  @click="$router.push(`/noticia/${noticia.id}`)"
                  size="md"
                  class="waves-light"
                  >Leer Más <i class="fas fa-newspaper"></i
                ></mdb-btn>
              </mdb-col>
              <hr class="my-5" />
            </mdb-row>
          </template>
        </mdb-container>
        <template> </template></template
    ></template>
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
  mdbCardAvatar,
  mdbCardGroup,
  mdbBtn,
  mdbView,
  mdbMask,
  mdbIcon,
} from "mdbvue";
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner";
export default {
  name: "Noticias",
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
    mdbCardAvatar,
    mdbCardGroup,
    mdbBtn,
    mdbView,
    mdbMask,
    mdbIcon,
  },
  data() {
    return {
      categoria: {},
      noticias: [],
      categorias: [],
      cargando: false,
    };
  },
  created() {
    this.obtenerNoticias();
    this.obtenerCategorias();
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
    formatearFecha(fecha) {
      const fechaFormato = new Date(fecha);
      return fechaFormato.toLocaleDateString();
    },

    async filtrarNoticiaCategoria() {
      if (!this.categoria.length) {
        return;
      }
      try {
        this.cargando = true;
        const { data } = await this.axios.get(
          `/obtener-noticias/${this.categoria}`
        );
        this.noticias = data;
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
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
    actualizarNoticia() {
      this.obtenerNoticias();
      this.categoria = {};
    },
    async obtenerNoticias() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get("/obtener-noticias");
        this.noticias = data;
        this.cargando = false;
      } catch (error) {
        this.mostrarMensaje("error", error.response.data.msg);
        this.cargando = false;
      }
    },
    async obtenerCategorias() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get("/obtener-categorias");
        this.categorias = data;
        this.cargando = false;
      } catch (error) {
        this.mostrarMensaje("error", error.response.data.msg);
        this.cargando = false;
      }
    },
  },
};
</script>

<style>
.select {
  font-size: 16px;
  font-family: "Arial", sans-serif;
  font-weight: 400;
  color: #444;
  line-height: 1.3;
  padding: 0.4em 1.4em 0.3em 0.8em;
  width: 330px;
  max-width: 100%;
  box-sizing: border-box;
  margin: 0;
  border: 1px solid #aaa;
  box-shadow: 0 1px 0 1px rgba(0, 0, 0, 0.03);
  border-radius: 0.3em;
  -moz-appearance: none;
  -webkit-appearance: none;
  appearance: none;
  background-color: #fff;
  background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23007CB2%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E"),
    linear-gradient(to bottom, #ffffff 0%, #f7f7f7 100%);
  background-repeat: no-repeat, repeat;
  background-position: right 0.7em top 50%, 0 0;
  background-size: 0.65em auto, 100%;
}
.select::-ms-expand {
  display: none;
}
.select:hover {
  border-color: #888;
}
.select:focus {
  border-color: #aaa;
  box-shadow: 0 0 1px 3px rgba(59, 153, 252, 0.7);
  box-shadow: 0 0 0 3px -moz-mac-focusring;
  color: #222;
  outline: none;
}
.select option {
  font-weight: normal;
}
.gray-text {
  color: gray;
}
</style>