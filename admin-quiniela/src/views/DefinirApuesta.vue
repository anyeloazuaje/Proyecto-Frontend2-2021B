<template>
  <v-app>
    <v-container>
      <div v-if="loading">
        <Spinner />
      </div>
      <template v-else>
        <v-container>
          <v-row class="flex align-center justify-space-between">
            <v-col class="justify-end" cols="12 text-center" sm="4">
              <v-btn fab @click="$router.go(-1)" color="info darken-1 " medium>
                <v-icon dark medium> mdi-arrow-left-circle </v-icon>
              </v-btn>
            </v-col>
            <v-col class="justify-start" cols="12 text-center" sm="4"> </v-col>
          </v-row>
        </v-container>
        <template
          v-if="
            apuestaCliente.id_cliente.nombre &&
            apuestaCliente.id_cliente.nombre.length
          "
        >
          <v-container>
            <h1 class="text-center green--text darken-3">
              Apuesta del cliente:
            </h1>
            <v-row class="flex align-center justify-space-between my-5">
              <v-col class="justify-end" cols="12 text-center" sm="4">
                <h2>
                  <span class="primary--text">Nombre del cliente:</span>
                  {{ apuestaCliente.id_cliente.nombre
                  }}<v-icon>mdi-account</v-icon>
                </h2>
              </v-col>
              <v-col class="justify-start" cols="12 text-center" sm="4">
                <h2>
                  <span class="info--text">Apostó por: </span
                  >{{ apuestaCliente.id_equipo.nombre }}
                  <v-icon>mdi-medal-outline</v-icon>
                </h2>
              </v-col>
            </v-row>
            <div class="text-center">
              <img class="logo-apuesta" :src="apuestaCliente.id_equipo.url_imagen" alt="" />
              <h5>
                Logo del equipo que apostó
                {{ apuestaCliente.id_cliente.nombre }}.
                <v-icon>mdi-target</v-icon>
              </h5>
            </div>
          </v-container>

          <v-container>
            <div class="text-center">
              <v-row class="flex align-center justify-space-between">
                <v-col class="justify-end text-center" cols="12 " sm="4">
                  <span>{{ apuestaCliente.id_apuesta.equipo1.nombre }} </span>
                  <img
                    class="imagen"
                    :src="apuestaCliente.id_apuesta.equipo1.url_imagen"
                    alt=""
                  />
                  <v-icon>mdi-trophy-award</v-icon>
                </v-col>

                <v-col class="justify-center text-center" cols="12 " sm="4">
                  <small class="fecha"
                    >Fecha: {{ apuestaCliente.id_apuesta.fecha_resultado }}
                    <v-icon>mdi-calendar-outline</v-icon>
                  </small>
                </v-col>
                <v-col class="justify-start text-center" cols="12 " sm="4">
                  <v-icon>mdi-trophy-award</v-icon>

                  <img
                    class="imagen"
                    :src="apuestaCliente.id_apuesta.equipo2.url_imagen"
                    alt=""
                  />
                  <span>
                    {{ apuestaCliente.id_apuesta.equipo2.nombre }}
                  </span>
                </v-col>
              </v-row>
            </div>
          </v-container>
          <v-container class="mt-4">
            <h1 class="info--text darken-3 text-center">Definir Apuesta</h1>
            <v-container fluid>
              <v-row align="center" justify="center">
                <v-col cols="10">
                  <v-row justify="center">
                    <v-col cols="12" sm="12" md="9">
                      <v-card class="padding">
                        <h5 class="text-center">
                          Ganacia de la apuesta:
                          {{ apuestaCliente.id_apuesta.ganancia }}
                          coins
                          <v-icon color="yellow" class="warning-color icono"
                            >mdi-currency-usd-circle-outline</v-icon
                          >
                        </h5>

                        <v-form class="p-5" ref="form" @submit.prevent="enviarApuesta">
                          <v-text-field
                            clas="my-2"
                            :loading="deshabilitado"
                            :rules="reglaResultado"
                            v-model.trim="definirApuesta.resultado"
                            append-icon="mdi-medal-outline"
                            label="Resultado de la apuesta"
                            hint="Indica que equipo gano y el resultado final"
                            required
                          ></v-text-field>
                          <v-radio-group :rules="regla"
                            v-model.trim="definirApuesta.resultadoApuesta"
                          >
                            <template v-slot:label>
                              <div>
                                Definir apuesta del cliente
                                <strong
                                  >seleccionando el resultado
                                  <v-icon
                                    >mdi-arrow-down-bold-circle-outline</v-icon
                                  ></strong
                                >
                              </div>
                            </template>
                            <v-radio value="gano">
                              <template v-slot:label>
                                <div>
                                  <strong class="success--text">Ganó</strong>
                                  la apuesta
                                </div>
                              </template>
                            </v-radio>
                            <v-radio value="perdio">
                              <template v-slot:label>
                                <div>
                                  <strong class="error--text">Perdió</strong>
                                  la apuesta
                                </div>
                              </template>
                            </v-radio>
                          </v-radio-group>
                          <v-btn
                            :loading="deshabilitado"
                            type="submit"
                            rounded
                            block
                            dark
                            class="mt-3"
                            color="green"
                          >
                            Guardar resultado<v-icon
                              >mdi-check-underline-circle-outline</v-icon
                            >
                          </v-btn>
                        </v-form>
                      </v-card>
                    </v-col>
                  </v-row>
                </v-col>
              </v-row>
            </v-container>
          </v-container>
        </template>
        <template v-else>
          <h3 class="text--darken-3 mt-5 text-center">
           Esta apuesta no corresponde a ningún cliente.
            <v-icon class="error--text">mdi-close-circle</v-icon>
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
  name: "DefinirApuesta",
  components: {
    Spinner,
  },
  data() {
    return {
      reglaResultado: [
        (value) => !!value || "El campo es obligatorio.",
        (value) =>
          value.length <= 50 ||
          "La descripción no debe ser mayor a 50 carácteres.",
      ],
      regla: [(value) => !!value || "El campo es obligatorio."],
      definirApuesta: {
        resultadoApuesta: "",
        resultado: "",
      },
      loading: false,
      deshabilitado: false,
      apuestaCliente: {
        id_equipo: {},
        id_apuesta: {},
        id_cliente: "",
      },
    };
  },
  created() {
    this.obtenerApuestaCliente();
  },
  methods: {
    async obtenerApuestaCliente() {
      try {
        this.loading = true;
        const { data } = await this.axios.get(
          `/obtener-apuestaCliente/${this.$route.params.apuestaID}`
        );
        this.apuestaCliente = data[0];
        this.loading = false;
      } catch (error) {
        this.loading = false;
        setTimeout(() => {
          this.$router.push("/apuestas-cliente");
        }, 2500);
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    validarCampos() {
      if (
        !this.definirApuesta.resultado ||
        !this.definirApuesta.resultadoApuesta ||
        !this.definirApuesta.resultadoApuesta.length ||
        !this.definirApuesta.resultado.length ||
        this.definirApuesta.resultado.length > 50
      ) {
        return false;
      }
      return true;
    },
    verificarResultadoRadio(resultadoComprobar){
    let resultadoApuesta = null
    if(resultadoComprobar === "perdio"){
        resultadoApuesta = 0
      }else{
        resultadoApuesta = 1
      }
      return resultadoApuesta;
    },
    async enviarApuesta() {
      const esCorrecto = this.validarCampos();
      if(!esCorrecto){
        this.$refs.form.validate();
        return this.mostrarAlerta('error', 'Debes completar todos los campos para definir la apuesta.')
      }
      const apuestaDefinida = JSON.parse(JSON.stringify(this.definirApuesta))
      const resultadoApuestaNumero = this.verificarResultadoRadio(apuestaDefinida.resultadoApuesta);
      const apuestaADefinir = {
        resultado:apuestaDefinida.resultado,
        resultadoApuesta:resultadoApuestaNumero
      }
      try {
        this.deshabilitado = true;
        const {data} = await this.axios.put(`/definir-apuestaCliente/${this.$route.params.apuestaID}`,apuestaADefinir);
        this.mostrarAlerta('success', data.msg)
          this.$refs.form.resetValidation();
        this.definirApuesta = {
          resultadoApuesta: "",
        resultado: "",
        };
        this.deshabilitado = false
        setTimeout(()=>{
          this.$router.push('/apuesta-cliente')
        }, 2000)
      } catch (error) {
        this.deshabilitado = false
        this.mostrarAlerta('error', error.response.data.msg);
           setTimeout(()=>{
          this.$router.push('/apuesta-cliente')
        }, 2500)
      }
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
  },
};
</script>

<style scoped>
.logo-apuesta{
  max-width: 492px;
}

.imagen {
  width: 55px;
}
.fecha {
  background: #eee;
  padding: 1em;
  border-radius: 2em;
  font-weight: bold;
}
.icono {
  color: #cab500;
  font-size: xx-large;
}
</style>
