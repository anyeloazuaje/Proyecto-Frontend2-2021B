<template>
  <section>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
       <div class="text-center mt-5">
          <select
            class="select"
            v-model="categoria"
            @change="filtrarEquipos"
          >
            <option class="d-none" disabled :value="{}">
              Filtrar equipos por categoria
            </option>
            <option
              v-for="categoria in categorias"
              :key="`categoria-${categoria.id}`"
              :value="categoria.nombre"
            >
              Equipos de  {{ categoria.nombre }} 
            </option>
          </select>

          <mdb-btn
            flat
            title="Actualizar equipos"
            dark-waves
            icon="users"
            :disabled="cargando"
            class="btn-bordeado"
            @click="actualizarEquipos()"
          >
            Todos los equipos
          </mdb-btn>
        </div>
      <template v-if="!equipos.length">
        <h3 class="mt-5 text-center font-weight-bold">
          No existen equipos registrados
        </h3>
      </template>
      <template v-else>
        <h2 class="h1-responsive font-weight-bold text-center my-5 titulo">
          Equipos registrado en La Quiniela
        </h2>
        <p class="text-center w-responsive mx-auto mb-5 gray-text">
          Ultimos equipos registrados disponibles para las proximas apuestas.
          Puede agregar uno de ellos a tu lista de favoritos
        </p>
        
        <section class="mt-5">
          <mdb-container>
            <mdb-row>
              <template v-for="equipo in equipos">
                <mdb-col sm="6" :key="equipo.id">
                  <mdb-card class="mt-4">
                    <mdb-view hover>
                      <div @click="crearSeguimiento(equipo.id)">
                        <mdb-card-image
                          :src="equipo.url_imagen"
                        ></mdb-card-image>
                        <mdb-mask
                          flex-center
                          waves
                          overlay="white-slight"
                        ></mdb-mask>
                      </div>
                    </mdb-view>
                    <mdb-card-body>
                      <mdb-card-title class="text-center">{{
                        equipo.nombre
                      }}</mdb-card-title>
                      <hr />
                      <div class="d-flex justify-content-evenly">
                        <p class="text-center mb-0">
                          <strong>Director</strong>
                          <mdb-icon icon="user-tie" /> : {{ equipo.director }}
                        </p>
                        <p class="text-center mb-0">
                           Categoria: {{ equipo.id_categoria }}
                          <mdb-icon :icon="iconoCategoria(equipo.id_categoria)" />
                        </p>
                        <p class="text-center mb-0">
                          <strong>Jugadores</strong> <mdb-icon icon="users" /> :
                          N° {{ equipo.jugadores }}
                        </p>
                      </div>
                      <template v-if="estaAutenticado">
                        <mdb-btn
                          @click="crearSeguimiento(equipo.id)"
                          title="Crear seguimiento"
                          :disabled="deshabilitado"
                          :icon="deshabilitado ? 'circle-notch' : ''"
                          :icon-class="deshabilitado ? 'fa-spin' : ''"
                          color="green"
                          class="mt-2 btn-block text-white"
                          >Seguir Equipo
                          <mdb-icon v-if="!deshabilitado" icon="heart"
                        /></mdb-btn>
                      </template>
                      <template v-else>
                        <mdb-btn
                          title="Necesitas iniciar sesión"
                          :disabled="true"
                          color="green"
                          class="mt-2 btn-block text-white"
                          >Necesitas inciar sesión
                          <mdb-icon icon="window-close"
                        /></mdb-btn>
                      </template>
                    </mdb-card-body>
                  </mdb-card>
                </mdb-col>
              </template>
            </mdb-row>
          </mdb-container>
        </section>
      </template>
    </template>
  </section>
</template>

<script>
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner";
import {
  mdbCard,
  mdbRow,
  mdbCol,
  mdbContainer,
  mdbCardImage,
  mdbCardBody,
  mdbCardTitle,
  mdbCardText,
  mdbBtn,
  mdbView,
  mdbMask,
  mdbIcon,
} from "mdbvue";
export default {
  name: "Equipos",
  components: {
    Spinner,
    mdbCard,
    mdbIcon,
    mdbCol,
    mdbRow,
    mdbContainer,
    mdbCardImage,
    mdbCardBody,
    mdbCardTitle,
    mdbCardText,
    mdbBtn,
    mdbView,
    mdbMask,
  },
  data() {
    return {
      equipos: [],
      categorias:[],
      cargando: false,
      deshabilitado: false,
      categoria:{}
    };
  },
  created() {
    this.obtenerEquipos();
    this.obtenerCategorias()
  },
  computed: {
    estaAutenticado() {
      return this.$store.getters.estaAutenticado;
    },
  },
  methods: {
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
      iconoCategoria(categoria) {
      if (categoria === "Fútbol") {
        return "futbol";
      } else if (categoria === "Beisbol") {
        return "baseball-ball";
      } else {
        return "basketball-ball";
      }
    },
     actualizarEquipos() {
      this.obtenerEquipos();
      this.categoria = {};
    },
    async crearSeguimiento(id_equipo) {
      try {
        this.deshabilitado = true;
        const id_cliente = this.$store.getters.idCliente;
        const datosSeguimiento = {
          id_cliente,
          id_equipo,
        };
        const { data } = await this.axios.post(
          "/cliente/crear-seguimiento",
          datosSeguimiento
        );
        this.mostrarMensaje("success", data.msg);
        this.deshabilitado = false;
      } catch (error) {
        this.mostrarMensaje("error", error.response.data.msg);
        this.deshabilitado = false;
      }
    },
    async filtrarEquipos(){
  if (!this.categoria) {
        return;
      }
      try {
        this.cargando = true;
        const { data } = await this.axios.get(
          `/obtener-equipos/${this.categoria}`
        );
        this.equipos = data;
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
    async obtenerEquipos() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get("/obtener-equipos");
        this.equipos = data;
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
  },
};
</script>

<style>
img {
  margin: 0 auto !important;
}
</style>