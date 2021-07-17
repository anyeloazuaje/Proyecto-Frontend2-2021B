<template>
  <section>
    <h1 class="text-center font-weight-bold mt-5 titulo">Últimas Noticias</h1>
    <template v-if="cargando">
      <Spinner />
    </template>
    <template v-else>
      <mdb-container class="mt-5">
        <div v-if="!ultimasNoticias.length">
          <h3 class="text-center font-weight-bold">
            No existen noticias registradas
          </h3>
        </div>
        <div v-else>
          <mdb-container>
            <mdb-row>
                <template v-for="noticia in ultimasNoticias">
                  <mdb-container :key="noticia.id">
                    <article class="tarjeta-noticia">
                      <a class="tarjeta-noticia__imagen_tarjeta" href="#">
                        <img
                          class="tarjeta-noticia__imagen"
                          :src="noticia.url_imagen"
                          :alt="noticia.titulo"
                        />
                      </a>
                      <div class="tarjeta-noticia__texto text-oscuto">
                        <h1 class="tarjeta-noticia__titulo">
                          <a @click="$router.push(`/noticia/${noticia.id}`)" class="link">{{ noticia.titulo }}</a>
                        </h1>
                        <div class="tarjeta-noticia__subtitle small">
                          <span>
                            <i class="fas fa-calendar-alt mr-2"></i
                            >{{ formatearFecha(noticia.fecha) }}
                          </span>
                        </div>
                        <div class="tarjeta-noticia__bar"></div>
                        <div class="tarjeta-noticia__preview-txt">
                          {{ noticia.descripcion.substring(0, 500) }}...
                        </div>
                        <ul class="tarjeta-noticia__categoria">
                          <li class="tag__item">
                            <i class="fas fa-tag mr-2"></i>Categoria:
                            {{ noticia.id_categoria }}
                          </li>
                          <li class="tag__item play">
                            <a @click="$router.push(`/noticia/${noticia.id}`)" class="link"
                              >Leer más <i class="fas fa-arrow-right mr-2"></i
                            ></a>
                          </li>
                        </ul>
                      </div>
                    </article>
                  </mdb-container>
                </template>
            </mdb-row>
          </mdb-container>
        </div>
      </mdb-container>
    </template>
  </section>
</template>

<script>
import {
  mdbContainer,
  mdbRow,
  mdbCol,
} from "mdbvue";
import Spinner from "@/components/Spinner.vue";
import Swal from "sweetalert2";
export default {
  name: "UltimasNoticias",
  components: {
    Spinner,
    mdbContainer,
    mdbRow,
    mdbCol,
  },
  data() {
    return {
      ultimasNoticias: [],
      cargando: false,
    };
  },
  created() {
    this.obtenerUltimasNoticias();
  },
  methods: {
    formatearFecha(fecha) {
      const fechaFormato = new Date(fecha);
      return fechaFormato.toLocaleString();
    },
    async obtenerUltimasNoticias() {
      try {
        this.cargando = true;
        const { data } = await this.axios.get("/obtener-noticias");
        this.ultimasNoticias = data.slice(0, 3);
        this.cargando = false;
      } catch (error) {
        this.cargando = false;
        Swal.fire("error", error.response.data.msg);
      }
    },
  },
};
</script>

<style>
.titulo {
  font-size: 2em;
  font-weight: normal;
  text-align: center;
  color: #3f51b5;
}

a,
a:hover {
  text-decoration: none;
  transition: color 0.3s ease-in-out;
}


.tarjeta-noticia {
  flex-wrap: wrap;
  display: flex;
  box-shadow: 0 4px 21px -12px rgba(0, 0, 0, 0.66);
  border-radius: 10px;
  margin: 0 0 2rem 0;
  overflow: hidden;
  position: relative;
  color: #fff;
}
.tarjeta-noticia.dark {
  background-color: #18151f;
}
.tarjeta-noticia.light {
  background-color: #e1e5ea;
}
.tarjeta-noticia .text-oscuto {
  color: #18151f;
}
.tarjeta-noticia a {
  color: inherit;
}
.tarjeta-noticia h1,
.tarjeta-noticia .h1 {
  margin-bottom: 0.5rem;
  font-weight: 500;
  line-height: 1.2;
}
.tarjeta-noticia .small {
  font-size: 80%;
}
.tarjeta-noticia .tarjeta-noticia__titulo {
  font-size: 1.75rem;
}

.tarjeta-noticia .tarjeta-noticia__imagen {
  max-height: 180px;
  width: 100%;
  object-fit: cover;
  position: relative;
}
.tarjeta-noticia .tarjeta-noticia__imagen_tarjeta {
  display: contents;
}
.tarjeta-noticia .tarjeta-noticia__bar {
  width: 50px;
  height: 10px;
  margin: 10px 0;
  border-radius: 5px;
  background-color: #424242;
  transition: width 0.2s ease;
}
.tarjeta-noticia .tarjeta-noticia__texto {
  padding: 1.5rem;
  position: relative;
  display: flex;
  flex-direction: column;
}
.tarjeta-noticia .tarjeta-noticia__preview-txt {
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: justify;
  height: 100%;
}
.tarjeta-noticia .tarjeta-noticia__categoria {
  display: flex;
  flex-flow: row wrap;
  font-size: 14px;
  margin: 20px 0 0 0;
  padding: 0;
  justify-content: center;
}
.tarjeta-noticia .tarjeta-noticia__categoria .tag__item {
  display: inline-block;
  background: rgba(83, 83, 83, 0.4);
  border-radius: 3px;
  padding: 2.5px 10px;
  margin: 0 5px 5px 0;
  cursor: default;
  user-select: none;
  transition: background-color 0.3s;
}
.tarjeta-noticia .tarjeta-noticia__categoria .tag__item:hover {
  background: rgba(83, 83, 83, 0.8);
}
.tarjeta-noticia:before {
  content: "";
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background-image: linear-gradient(-70deg, #a0a0a0, transparent 50%);
  opacity: 1;
  border-radius: 10px;
}
.tarjeta-noticia:hover .tarjeta-noticia__bar {
  width: 100px;
}
@media screen and (min-width: 769px) {
  .tarjeta-noticia {
    flex-wrap: inherit;
  }
  .tarjeta-noticia .tarjeta-noticia__titulo {
    font-size: 2rem;
  }
  .tarjeta-noticia .tarjeta-noticia__categoria {
    justify-content: start;
  }
  .tarjeta-noticia .tarjeta-noticia__imagen {
    max-width: 300px;
    max-height: 100%;
    transition: transform 0.3s ease;
  }
  .tarjeta-noticia .tarjeta-noticia__texto {
    padding: 3rem;
    width: 100%;
  }

  .tarjeta-noticia:hover .tarjeta-noticia__imagen {
    transform: scale(1.1);
  }

  .tarjeta-noticia {
    flex-direction: row-reverse;
  }
 
}
@media screen and (min-width: 1024px) {
  .tarjeta-noticia__texto {
    padding: 2rem 3.5rem;
  }
  .tarjeta-noticia__texto:before {
    content: "";
    position: absolute;
    display: block;
    top: -20%;
    height: 130%;
    width: 55px;
  }
}
</style>

