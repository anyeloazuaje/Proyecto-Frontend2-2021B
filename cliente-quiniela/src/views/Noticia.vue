<template>
  <section>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>

        <div class="contenedor-boton">
            <mdb-btn 
            class="boton"
            title="Volver"
            color="primary"
            icon="arrow-alt-circle-left"
            @click="$router.go(-1)"
            />
        </div>
      <mdb-container class="mt-5">
        <mdb-row class="mt-5">
          <mdb-col md="12">
            <mdb-card class="mt-4" reverse>
              <mdb-view hover cascade>
                <img :src="noticia.url_imagen" class="img-fluid" />
                <mdb-mask overlay="white-slight" class="waves-light" waves />
              </mdb-view>
              <mdb-card-body class="text-center cascade">
                <h2 class="font-weight-bold">
                  <a>{{ noticia.titulo }}</a>
                </h2>
                <p>
                     <mdb-icon
                      icon="user-edit"
                      class="pr-2"
                    />
                 Autor
                  <strong>{{ noticia.id_autor }}</strong>
                   .  {{ formatearFecha(noticia.fecha) }}  <mdb-icon
                      icon="calendar"
                    />
                </p>
                <p>
                  <strong>La Quiniela Informativa</strong>
                </p>
                <mdb-btn title="Compartir en Facebook" class="btn-fb waves-light text-white">
                  <mdb-icon fab icon="facebook" class="pr-2" />
                  <a
                    class="text-white enlace"
                    target="_blank"
                    href="https://www.facebook.com/sharer/sharer.php?u=laquiniela.com"
                    >Compartir en Facebook</a
                  >
                </mdb-btn>

                <mdb-btn title="Compartir en Twitter" class="btn-tw waves-light text-white">
                  <mdb-icon fab icon="twitter" class="pr-2" />
                  <a
                    class="text-white enlace"
                    target="_blank"
                    href="https://twitter.com/intent/tweet?text=La%20quiniela"
                    >Compartir en Twitter</a
                  >
                </mdb-btn>
              </mdb-card-body>
            </mdb-card>
            <mdb-container class="mt-5">
              <p>{{ noticia.descripcion }}</p>
            </mdb-container>
          </mdb-col>
        </mdb-row>
        <hr class="mb-5 mt-4" />
        <template v-if="!noticiasRelacionadas.length">
          <h2 class="h1-responsive font-weight-bold text-center my-5">
            No existen noticias relacionadas con la categoría.
          </h2>
        </template>

        <template v-else>
          <h2 class="h1-responsive font-weight-bold text-center my-5">
            Noticias que te pueden interesar
          </h2>
          <mdb-row>
            <template v-for="noticia in noticiasRelacionadas">
              <mdb-col lg="4" md="12" class="mb-lg-0 mb-4" :key="noticia.id">
                <mdb-view hover class="rounded z-depth-2 mb-4">
                  <img
                    class="img-fluid"
                    :src="noticia.url_imagen"
                    :alt="noticia.titulo"
                  />
                  <mdb-mask overlay="white-slight" waves />
                </mdb-view>
                <a class="green-text">
                  <h6 class="font-weight-bold mb-3">
                    <mdb-icon :icon="iconoCategoria(noticia.id_categoria)" class="pr-2" />{{noticia.id_categoria}}
                  </h6>
                </a>
                <h4 class="font-weight-bold mb-3">
                  <strong>{{noticia.titulo}}</strong>
                </h4>
                <p>
                 <mdb-icon 
                icon="user-circle"
                 /> Escrito por <a class="font-weight-bold">{{noticia.id_autor}}</a>, {{formatearFecha(noticia.fecha)}} <mdb-icon icon="clock" />
                </p>
                <p class="dark-grey-text">
                  {{noticia.descripcion.substring(0,100)}}
                </p>
                <mdb-btn title="Leer más" class="text-white btn btn-block"  color="primary" @click="$router.push(`/noticia/${noticia.id}`)"  size="md">Leer más <i class="fas fa-chevron-circle-right"></i></mdb-btn>
              </mdb-col>
            </template>
          </mdb-row>
        </template>
      </mdb-container>
    </template>
  </section>
</template>

<script>
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner";
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
export default {
  name: "Noticia",
  components: {
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
    Spinner,
  },
  data() {
    return {
      noticia: {},
      cargando: false,
      noticiasRelacionadas: [],
    };
  },
  created() {
    this.obtenerNoticia();
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
      iconoCategoria(categoria) {
      if (categoria === "Fútbol") {
        return "futbol";
      } else if (categoria === "Beisbol") {
        return "baseball-ball";
      } else {
        return "basketball-ball";
      }
    },
    formatearFecha(fecha) {
      const fechaFormato = new Date(fecha);
      return fechaFormato.toLocaleDateString();
    },
    async obtenerNoticiaRelacionada(categoria, noticiaID) {
      try {
        this.cargando = true;
        const { data } = await this.axios.get(`/obtener-noticias/${categoria}`);
        this.noticiasRelacionadas = data.filter(
          (noticia) => noticia.id !== noticiaID
        );
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
    async obtenerNoticia() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get(
          `/obtener-noticia/${this.$route.params.noticiaID}`
        );
        this.noticia = data[0];
        await this.obtenerNoticiaRelacionada(
          this.noticia.id_categoria,
          this.noticia.id
        );
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
        this.$router.push("/noticias")
      }
    },
  },
};
</script>

<style>

.contenedor-boton{
        position: absolute;
    top: 5em;
    left: 9em;
}
.boton{
    border-radius: 1.5em;
}
.enlace {
  text-decoration: none;
  font-weight: bold;
}
</style>