-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 19-07-2021 a las 00:38:56
-- Versión del servidor: 5.7.31-0
-- Versión de PHP: 7.2.24-0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `quiniela-bd`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apuestas`
--

CREATE TABLE `apuestas` (
  `id` int(11) NOT NULL,
  `id_equipo1` int(11) NOT NULL,
  `id_equipo2` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `costo` int(255) NOT NULL,
  `ganancia` int(255) NOT NULL,
  `fecha_resultado` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `apuestas`
--

INSERT INTO `apuestas` (`id`, `id_equipo1`, `id_equipo2`, `fecha`, `costo`, `ganancia`, `fecha_resultado`) VALUES
(3, 1, 3, '2021-07-04 03:13:12', 40, 50, '2021-07-22'),
(4, 2, 3, '2021-07-04 03:10:50', 30, 35, '2021-07-31'),
(5, 8, 2, '2021-07-18 17:24:24', 30, 60, '2021-07-31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apuestas_clientes`
--

CREATE TABLE `apuestas_clientes` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_equipo` int(11) NOT NULL,
  `id_apuesta` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `apuesta_acertada` tinyint(1) NOT NULL DEFAULT '0',
  `resultado` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `apuestas_clientes`
--

INSERT INTO `apuestas_clientes` (`id`, `id_cliente`, `id_equipo`, `id_apuesta`, `fecha`, `apuesta_acertada`, `resultado`) VALUES
(5, 9, 2, 4, '2021-07-08 18:30:03', 1, 'Gano Barcelona 2 a 1'),
(7, 8, 1, 3, '2021-07-17 21:36:47', 0, 'Gano Madrid 3 a 2 en Penales'),
(8, 8, 2, 4, '2021-07-17 21:37:57', 1, 'Gano 2 a1'),
(9, 8, 8, 5, '2021-07-18 17:26:22', 1, 'Gano 4 goles contra 3 a favor de Mancheste'),
(10, 10, 8, 5, '2021-07-19 00:48:17', 1, 'Gano 2 goles a favor de Mancheste');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autores`
--

CREATE TABLE `autores` (
  `id` int(11) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pais` varchar(30) NOT NULL DEFAULT 'Venezuela'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `autores`
--

INSERT INTO `autores` (`id`, `nombre`, `fecha`, `pais`) VALUES
(1, 'Luis', '2021-07-06 18:51:21', 'Venezuela'),
(2, 'Julio', '2021-07-01 16:52:11', 'España'),
(3, 'Jose', '2021-07-03 03:45:20', 'España'),
(4, 'Anyelo', '2021-07-06 18:51:13', 'Mexico');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `fecha`) VALUES
(1, 'Fútbol', '2021-07-02 22:31:46'),
(2, 'Beisbol', '2021-07-07 20:35:37'),
(3, 'Baloncesto', '2021-07-07 20:35:47');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `correo` varchar(30) NOT NULL,
  `clave` varchar(90) NOT NULL,
  `coins` int(255) NOT NULL DEFAULT '50'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `correo`, `clave`, `coins`) VALUES
(1, 'Julio', 'julio@email.com', '$2b$10$UJjPioUvz2M63y2shHytL.CaXGuzjsfUd6B.VOBnXtilu/NxQQwGi', 255),
(8, 'Jose', 'jose@correo.com', '$2b$10$VwaaK.zaw8GGiu/kr3H5xeyGHHel6CJQW/HhaU6xZKKaDLSr/0wD.', 432),
(9, 'Carlos', 'carlos@gmail.com', '$2b$10$jZLCih6La7ItfiA8cVjdL.lg24DlmwNGbYvMWz3wB.lduSuKrBIiq', 284),
(10, 'Luis', 'luis@correo.com', '$2b$10$eFHrzROmoG1vBwaoQcm1buFMLwh.VcZWjSAPjZY8tVfz.lbKyQ/6C', 285);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contactos`
--

CREATE TABLE `contactos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `correo` varchar(255) NOT NULL,
  `mensaje` text NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `contactos`
--

INSERT INTO `contactos` (`id`, `nombre`, `correo`, `mensaje`, `fecha`) VALUES
(1, 'Pedro', 'pedro@mail.com', 'Me gusta mucho su pagina', '2021-07-03 01:50:46'),
(5, 'Jose Ramirez', 'joseramirex12@gmail.com', 'El mejor centro', '2021-07-08 18:35:36'),
(6, 'Maria', 'maria@email.com', 'Excelente atención', '2021-07-08 18:36:30'),
(7, 'Luis Peña', 'luispena@hotmail.com', 'Gracias por la seguridad', '2021-07-08 18:38:04'),
(8, 'luis', 'ejemplo@email.com', 'ejemplo', '2021-07-13 03:36:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipos`
--

CREATE TABLE `equipos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `jugadores` int(255) NOT NULL,
  `director` varchar(30) NOT NULL,
  `url_imagen` text NOT NULL,
  `id_categoria` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `equipos`
--

INSERT INTO `equipos` (`id`, `nombre`, `jugadores`, `director`, `url_imagen`, `id_categoria`) VALUES
(1, 'Paris Saint Germain', 23, 'Mauricio Pochettino', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAACoCAMAAABt9SM9AAAA81BMVEX///8pVIHVPEIAQXYmUoAAQ3cAP3UjUX8gT34VSnscTX0ARHcQSHrTKDD129wRSXrww8T29/m+olrp7PCgrb/v8fT4+frf4+mKm7IxWYTT2eGwu8q4ws/j5+zJ0Npgepp8kKrEzNc/YoqVpLnUMzqBlK1ziaVXc5ZJaY/SHiemssNpgZ+0vsybqb1GZ41Sb5P45ubIqFbrsrTpqKoANG8AMG334+TaYGTkk5Xdb3PXSk/y0NHmnJ7ZV1vQBhf88/NFYH6ym2B1eHOlk2Tgg4baXWLwyMnfeHyXi2tfbXmJg21xdnScjmivmWFTZnoARYcAJmiTVD1LAAAcIklEQVR4nO1daWPbNtImDYInHFWRJYrUSck6LFlWnLhNm6NpN91eb7vb//9rXswMSIEUSafdNKbcTD801kXi4RzPDAaAYXyWz/JZPosm7VGcDAeDjZTBdRKH3Ye+oUZKOx70JxHjXEjxUFoiCDizVovNuPPQt9ccCTdLkwXCdyyzRFzXE0xMduPeQ9/ng0tnsOXcc8tQ0sVyvMDe7+KHvt0HlHAXMQ0oy/F9T4iABxwkCKRBuhqOjse9xfihb/pBpLuZcS81PMsXgnn75XwwHMdhp9PtdkZhnAx2iwlaaAaZL1r98KFv/VPLeGunSDl+wGaLQdyu+mw4nK94kKmgz2eDT3mrDy2DKFBDdwVbf5DvDjdbFvhKD1u8/w8hFb2daFkKKb4clilUr1cK37jvct8is7WXo7/5PpsgO+WpLM/eJrl3wmTT3+4jwUgC62ay2A3z5hn3W4KUUsL12OnXRhBULo82mvbEm2VkB8LzXcc6sC3HcSU1Zd5kl2iIJSvbV3BNK/3cI5CxKcj+7MmBMoUXK1tyhFJGmoYAwaL+gTR0+twjuNjFQwzjU0h3wkmrNH8zXnhFTuoKTfyMhEnAttepMkq/Rxraih4nUd0wV0GVRrIwc0A6Vot4nEnSdz3trZbm5i4CfMdiy8eXB3VuBI1tkmrV9Yz7RaSkeAXLumC6gbqBN0+xnhP6fuuxsfoBDUykVtOeC+GgPyqqVhEsI2b5D8gwqDh8d0tAsumnHMrfLluOwLAN/dnuM+RLlsf2/aAErE5IgtFuIA7vIsAumyi4xibaoh89HtI1MtHeghUZUE9CRU47upBUaR4cgzW3AxR7B1+YZYbo7plHsKfW3LcRdfv6oQb3kWWI43GYyug2adZiCvLWU3EE1i516zZ85CJz8sJoX5gqpCqSFUb4Lp8+yNg+tvTR53g3pFZxJDI9Ecozb71KsNyl/CtJ0fTn8HGliX6gjHqKnkvsH2BsH1u2MFKL9emvpR7bRMqRVn4VWP5C/jVspXoGgA/S9ywxI1tMOLgy1zz55HrvIVZkcGM/Rxa4dNMJvjM7xMQcWI4NnryvvuVO4LORlg+RTzM6EXzCEadd6eohCq5JGrAokAAuVSH5Et7rRRla5ODvGJf/sRkaaopwAH/FuXgglHVPWvhMTpnOtxEDb40cuxPprgmEydeHgQeOuu2n+nLEs4xFWsaK4K9tITnipLR9JCf26aLVQ1oktvhHwhzLDxjjrcyMuHz5uuUiBp2gCqxd9g449K5dQNxiC/zYBt6w7FNl8+0IsZriHzImusFcOpXO9UxpmOUZ6K5djGOhbZWBNZpkZgeKeHD9jpCGillAa4+amxBaJ6pb6K84hcGJMP1VmvEuiApYMwM5lGuj4x7bB7CSuRQY9vBLJzO4KXwqC5Prcc/oDieQRvlmh37AAkU7SS+/P2DVu/FNX+NBS/Q7Drwyt/lUmc7QzsDaMd/3THhxlbkoRCGlXO5W/dRoLzXPCRChGH8gOMECKjJNgViBn3dn+GpMI0FiigPeaHnKhps6dfCAgnbTCOqs4SN7pWiB9i2AiHwVouW4J1ez6YvMX3UdV3p6GEEsAjK5hZvZFUmIqgFposazbGAVF0qXxBA+pqBDYm+oaY2Yg6/CoIh+y735RGP8WDKEUXloK13Xkb4c6FAI9B2V7RoQ8BWrN+K+yREYSBM1sBwc9YyUCaJBxiLwq+GdvUd3HkIFltAa4HWXn3Ss/6uM8Amj4bQdOVgOUHSo/AeuCF2Ph/S7uzMDSbIITmPrI0FQqbOAf4foiTAt7PHU2YN+jrmMDcgb4oMlYg2Dbz79kP+6QGXAstBKgJdiPG/TnIQDzgvzO4Sln85MI93qxpa7mm4naVGGAWFFdcK0cJPRWg6/DTrXWsFF0FaJNWx987TIKd4wQ8OScVA9c5XRMPDoGA5b4IX2WbRz15OAS8/vuO6h+cif7MZGlEa/Q1qIWgkGrqLsGmyVY/RAxuKfjJMfgClQ7gywITyIGoQx8DZtNCes0NxkPOq4wmxiZ00QSIwCUJWYrNDDRwHAdCCqelND1Z4tjIPdILXTU5AOOll0JnOhrM3YEeVsoe+l/A4rNLPcfKHrtwJOE9IcOo7UZL38kev0a5a9gZhoYXgd8fSxrJwsDiK75SfSPLJ2lWeiSO5TGWXO0Krwn8QGoEJjHBTLFdzfzofxqIsm1O7EycUyYoIAE7yPimVF8lsTV/k4cu2uvBJNZFMc7EMJgp1EdWsjMiuhSdVgiq8PbBUfNyqmQYUmVi7b5/5iWDa83ng+YxgDfIQY7QuZqo9qdC1/rHXdT2uKpFDg+d3VJxnt/yY4EJHdM9oeOZDERnUbpnUDZoxWnHTK69eFr85mxvNZzwb8Erl2sE3vUFNEvoaOgA//3oF+DAETwazPWGSB3kONMsagOuOsxuL3bXQ0bJXrpuk9e/L69esnX73TXwynTFW8KO2ZADxIettBzus5aJ2o3aLxEXHMU38x1ipPbpT2u4RaER60xbG3WZmgF19sB8bzb89Brl5KxZsnmWm252oCm+YpZvBHAAo8z89re5gXQJD1F59w3H9JgAq1sCSVIwKOQxn0iOdGZvFVOj06utjbgSd9zvPLM5DLl0bHxvaZ1EJ7pIlE4HqEFnyxMEuLhBRTCLvhU68we0zl30X+gasqSnemv+yZqjrT20gvjoW8ofGCwDp7aXQx/PmBP1ej7qzA5og1GBPumDY8ggJYmE/h5Z2G+3jwFRznFYrlX5MRMKvMk1m2yqQ7C0LKxHnXNwqst4aRlmd8e6XUawjNqKrcM5zdIVNwChfC0g7dSaOzHqgW0POcFYcgsaHwtE3rdy4Npbu0D9omierXCqwzwzjYrMPX9On2SgBamu/useKVUN9AxykYNFWwVgI2MxDFEcAgqBhA04BC2cjc1p1bMDJ+UGCd56YIob2hq74A+eOheHxRnDRSuQ4Q/6DB8xegWD6axtEAUGheGsiF+qcRW/lPsrbxjQLrSq8pIwY2zWUkMqBmJnzUkYS/guX7oNmqJVIbmJeDZQYSyT3WUCh1W9iFVlIZ3t4qKzx/Z0wLqbVYo3KNwMP5vD/utsN+CVaqagh62VyvBbaHBd9jN5INd0v1JqSh3VkRU9CE1GWdPznMe2XvY/AwupaDXaY8W0dQEJx5HYomVx/gUWI2UqVYUqAEpbCKg6OaDNjwVQrWjzjcvFjU3dC2juJH/mMYL0Fr7YbO9UBVgNJXXtOnDQPAsDg8Ihc4W/HsXIF1+dwIg+OPUCNW16u/BHp2KKxmhf6GCaS0WNA7jk/54WJQHJRgBTTrdQbW1weilfsMFk1HrBYt8uxQ9wpq7vjhpI3T5/Cv+rWWVBa8LsMKCsPPU591+U2xNKikhWiNS38gE3QHQONFI4sPoPQ0917GsTKhmlZSPlTPOHBSYKXFcEhC05G7+stAoAl5U108JPo4B7Oq1SwB9YewHCuYlvgmA+sKemxKP8fRy9dfh6XzP3YDS6ZQcEP33qnkDTgGCITtCvcM5frzTLEkdygUKTLB+aJ2rWp5wORQ2xtYjYf7asG0wq6c+pAQv99X6AQPjXdXB7CeH5r+CmJBSdpIKqBEwVkA6OZyG9iZCzN3NpiYWRemsHpZ5W0gcv140KzLHwxjWYGWqpfWGSKWvfbpXTVK8BmCLw3rHjfW5iscFjnlNwf/fvZKa1Q++qULo6QNUBech0V9b1w8BLLtlVR5c0LE+rh6owRG9e8DVmdX74iPlAr67f59F0NP2rg+EQjyOH0e1VghZnaDElquxt87JDsq4ckaso6EKEFdrsDU7VjiQZEpEVfVc+tiIRUDKuk9xNLX5xpYwOE3lR/HOsxRqq0JKjroXtCwzskOV7Mp1zXxPADaUD08iKW6y0KnVe2WEPrq+oZqJhlnDQTNEXDEmFgsqwMUzSQElYYDNPKVjtXZ1bM66olGvajxWtA63m6g0wJtRx9Rc++YC20qNQ+G9OwqB9blc6OkTJN9AShwXfDFZgpIL52HBacowLKgkbHOZWH8qvb/UFV5fpkH66VRq4rApG6qK1votKB9tWFNIrZyEdV6QIoQVyoCGum/z/IiyUMNPcDWyeoIQB2+UL4VjZq3gFlhbC2qYVlISMvLCCDghd9dFcACOxxVM0/f0Hq/jwVne2FhVLM8PFRlcF3qpNoo0BaqbQq6RF9cFsA6+3ftb2I/YCXHlYZvULzUm8gfXqA2iu60WrGQUMeVVorl31dFrDAeVpsufqlGmZFguU2bx0cv2qNA/dcGBt7/yfkRWJdvjBofjnY2rnaTSGZktt0sDg/pPziQshmG9MbBStdVw0ZC+8ORFUq0DNXGVCpg2r1qn4ZkBZgYa1KrliQE2MBWU1HGxLE2LT5y7yDnXxg1bgmfQDUbceERgIsImtR8xBVNHlTHcWYUl+xqgjZ67N5B3ho1qoURuKrmJX0VJNuQXAQNmpiGiHOPT8JqXUVJ3bQ41OdKsTq7emJU5zzI7apn3jCojNNI3RCBNBprbYtKGoX15CossVXw+bF7R6f1jVHNtRCNaiKMa2XBj4oG1eEhQcPcYlsNFrDtiiybMuxSqEC1vpJvTitgrjVuervTMFYK9KmlwnSF4O2uyh01lg8qFEupVq9Ce8B+i02lOlg9ovi01UgzBJ4tuoXKuiZhWTrBrBYxVSmWUq3rckQgxtYkPDAJlDnUhsg4TVbL0QBBLEuhJO/+4uq8UiAgVmglpA01BUDkK6xZXd4fClbp3GqAi8a+qBNYP1CuP5jQ/HPAoomHJ7XyGj4yKCNbjxisMvfvQSby7NtqI4TVFi/gKmXRIzhBMwzuy/3IwZckJrRAt1j0O/LxuJCnZC9TyGO61ZVl1kAHn1GH6tkFpGHHwVJgTK+kDTn6UDaVDcGhU00d4G1YNtsk6gAk+T5Suit7m7oq392HlcqnaeVcTqC8dx8p5WVbJz2cZPdTXTXGYmWxnO4gdTdelmeFebTQEJeFNBALWtWlDqxjZU+yIYKafk8iDTpULErQcvl7jRAN8SVeaZ1/GlhWqJ6yyIrwjeqVZCpTrrlveMgFgyHn/qysjFWiWhgRaUuuTNAX1agzPCHIs5tUojHSG6sr/nWLVWe18OmDoDpTWY/RFXpIRI2pnjlE24cHyJtU/INcBBqVa3wt8jCdO6jtcH/6AIelLBE/P9IBT3lUhWBUwcnyJvWzgSVA5KmhPHjjWmcCp2j+ouCwLi8zKnpZgFG5rVhfOGzUPiCkMxCC+UMBUya7tM5dPS9YqNErrF7nHNbl+dXLN188eQby5McXP0nAcm7ra/xOnK2Owhp7zZQ0brMB8wON2iRqKO6t0WCrWjZjobDKOffLq2++KPzu6x+udLiunuOr2SpZvGRNhzdan522/TZFwnSXsJq+RRyZoqVq5eC7HBI/PcMXO8muP13Mr1UH2htdu65+pMuphj+wrroOLUu/teaIraZ3qqYkTH2b5GyP7VcHHC5fwcSE0d1FDM79gE1pxAID/rufNPXD6QsJqJ9t7VbZopu2qrSaNV9hYLkBK+k1s6wYAYwWbPiomlreHrC6QnfUXdpaFcdy1cJord377BwJhNGGDYJx5WVNdwVt0JV2jjVHpmkXVE1vGS4pmPuuo0iPjhWlfnbR/Th0QsW7s8siWsZEWOmygCpB/752GjZ7r7qg7mmjwTUP7bu1mkrXsULjWh20Mts82PRx6Xjv1TFa/TsgBnUduJBlAwtztsc3/JAS8vt7y8hs0ixNxwoqoe3DXtSm9/Ohikh72r7TGQT5LfqlmstR91zz/DsSLNScuh5PbTXbO11VkBBoWDm/3P58iKqElk4yEFyS0i0RUshxX0pf23e+KQKcAGlN3TKnbCvfrzQ6cPkTvKLvny/eP73VTsGiVXdfaF5e8S0pVt0SBbga1G4bxd9BBukimbpe67Sp7IvcOgr8uhZFre9un97+S/P1VCL8RudbP6ir1q2ig1wIlrM4jVuemS2SqektU3PPxtc5rEBLenqa5P/69OnT7/WfQa6R60g6f4vFwLprYYENWFaT5u6V4JYT8I+6AdAGSPlCA7ySi2lCYvX09jt9axXM7XK9bpcQU+u0mGpY6B2axbJAoEiK5KFupZaaoNAHjTU9nW+AFUrR7ZCc3bMik69ci4c/A7kO5EK0FK1ZEqYNbbULDk08weOrw7Bxkkv7iswEfkGwfvXNwzJP2ln4bfYtKpvWLUCjkhAu7Ns9HCiVAkOjVdx1YyBDPHh46N0+kDPfijwrArBu/8+Vf6RlUXLxWWsgBdBF7fYRuFUIVCRYk6qkqQCjacEsyqA6tTXTcsmbc90K0x4497fb29+/4+9Bs1zn59vb75XnooQl7Wa+xE6RpHbhOoZAyIWcBlqhjIfZndXvrkJbif5AAz/HmovKkfzfpE7d3v5nhtRB/gswoy9hEq5Wbl6+wsvVbxmC+6vA82vSLJgmsKae64cKVQhN6hBa51jDopIh2t+/Zu9vo19vv//v90//8x1aIyGMRXQNq14dHU2tHTdUalJX90HAm6KR1a7zzs7kQLZFTQzU8gFg3Zo+/+17cfvLr08t97+/Z+SUGtlfZjaonwFVJthEmt1QEwUcLq6Tq1mhiagIZD4vJFpXCIKa+fPeS7R+ccTvv3xv3kaWBWZICqSKLC8vz86x64F2LKsRYO/YPt/YQ5526RZMnWPVcoQ24We1MEK9Pr8kzUqjofvb0/fwvyiyJC2QTP535eDVRskvL6/e4D90rPwSe0TFgjU/zZqq0AXnUDGbPpokdtbjYaRVEmiN97u336LPyniWT8f7eu+/o62n07qpKrKcnWO9oXejY7URR2hZuHQVfGjQrIKyLpB+oGodea1gNBrTAQRKaHM24w3N5+Q/7P7r9n3ezIgr9V7SoWOm/ijcUdcrFhwDyOjx0BTzYYD4EEGMULXyG9k5TtBZ3G1zvW623jKVr3dKsH7Pf1/nSmOew8ay455ZaBfBj8PFRJNPH0XVmsK/dM1wVhNv0eNi3tEzIbE/zKkXNgbxf85nAXoTTF/fgNIVwvPuhoXYiE49CZqtWKqlGHd1HWoFKu96HLA4CWxjnT8T+oBBoX6Qd9ramEczvajhTuLk+mK+HedmWmlnAkgcgyZ1Gh1L30tDl3b7kiHOHAFsquBc+CRdFt++Oz6rXInj3WVeem7nfsGdGuF1HHbaRnJIsawAPNsm2xG7wQIPHkOQ7uPFoGuLecmaX5dlnmu45YFXAMxyfWHvN2k9apjfLtfxTG9i9O8E50xLR1Gd2pBy8UYtui8RLPTiUVV6pZiFo2iALTZukIfMax2mXuLN0mQBnIoipSUC1prMkyxbSWZ5juAsr5npr4vbUtKsCATeZu72lxOgzeTjdT8CyiZTRpetwk6BfHvBXN+jYjQeDjabzWA4DvWmqkEUFGzYmhkXARySkuSqHDi7gXu2NXU/V02wfIlFc30llyUc03PtSWiMjyatLd+e1HvieKEdTkrfMXFb+L4wHau7197D3QB78DxEg9q5KwVrcrC6vLiBfrDsGOEfg7JWSkew7aC8SNdOFv7RvsJOBAeM+itoX7b0yY4Wrg6AynvjvTsJ5L60LG6nt4l4iTGXHqazwINBjwTPKNoluu11xptpxMrCZGR04RQab1toF6BNUHG5nd2wTbMqJD4cP7XNcVPPg1PEoSA375TOAbme9OrcnO1X+5soYIHwSlaggHBjYCSuB4cl6s+DDguj47catAClVvDUTHqyxU0GvMUoAAuZOE71lJnlSKleMgX5cWcpkHX5ud+na8Ihw80sJpcKQERPuV0ooIh448kxDblkrvX7bldiFUqPJJJhd7Q0pGvXf4SOBqQN55sfCVPpAiWkzVQLq5C4sXf8haSuMn+Tg3bqt3UvCiDDYCm+Pzc2th/M8ykhWj5ugsqbnEAXBfeZpiPhwtwkjHXjmK6EyZkY4wvf2S6d+lp6HquZDHwMCrHupH0HnCOH1e5w5emDjv7PCp7KFyDTiXPnVFjSEsfcZKPdJhF2d+fdeJVZYQ4oR2JjhJEnjH7btoKjhZ5cXcw8weN+8eQzMowC3XKnETALe9qxpwYTQyPZsla9ejkej1YBVmoWd8YfMhfg7cICc0oyR3QGVJPWU3yQYByk5TlhfooPZsy6u9bM+KMtMyABTbbDmyq04LAKgbl0yGUUXRqxcbcAvpDXLLJBPHbUauQUdL3Q4b5UPR4VywlRKCxmzHE3Jx7vVuPClL+Ln/cl6xIrx9vIfMe/k3QjGCcy4jE2KnSuWnQyTZdOE2l6raFM8DEr3epGBc4ucD4WS36eEbl5M/Ss6dTxTL+fgI5A9eDLgElu5jo3hsWWkjkUsUJ8OoTVKQXCg9DO9+o4otURB20lWEz2+8Ud8oMLo9s1LrwgjvsThwFbWEo7HHLouRoWlRROvUW7G7UAK9a8zrUPE2IN5E6M/lFvgo9FZh6q3fYlK8B/+H3jhrF14onh4EusjIpE2mHShZPSVtdHrTOtPZa8aLEYb2J/0YcJoUUn5RgJL+oEoafmwSQx6F0AWry78CzO7hx/3h5h/5K7GN35NhbCnCOs1KFhdIoPO12sYHUKAEJHrhvdm7LizCQt2VjucomGZNy4M6PdXftbY7oiHYTUqHW9Pg6ZvtqvdY5Y2adqgyQdjGuuSalaYb6B0DrUOdFBm7yzEOZ2ZewlZF8GnEmKH3T6rmkdb85iBROqOm8hqUoPUDxdwRVJkvvQOPIzWeXiLoyVfbc2IkkuNuMOdBJabinJ99VUV0dd4xQ5Q0EoDirHZWzYvcmNzJJ6bZikFuPxZrFqWWbpGSJqEZRhXDM8Ydk9PS5aInQEoR9R6bK9PFr7VRSvtd364MmF8NyqwpaYUTNRD03Q9NYnl+OUyxBdlZV2N4R7fk9lxrq3dCMc5Z+SFkLPpg82uo8towgjvhepzrLx+j646rEUrmoU7U6Q0Drs1F17TqZoijJXUcYSr9g9vXuV4gRR2lN7QdStNTuduugHSUJVKzej2OGCt/6Cevn2Kg16iYmsw7FPYYLwz0lvS/mO52e91oM1u+cAzCJS3JmnShTfUAe5mJ3GnNeflLFJuUrmcSRDupix48y4VBwv8PtZN+1YBYn0uORHKOkB2y1vlwX6zqCkfSYvluMLe707aNBwRo0PDts26yiPjyrdpUp4PHup9VzHm6XFRMt3i70fEiZPcDHZjQ+t/525R/UsK5g1tW/7I0k4YYSIG0QXehBrx9fz5dq1OeeBECIIAsbEbNvHjCeT3nBlq4pOEDW3E/mjSTxRGY/lsZvNUY7S7oRhLCXsHFlYe7hNOx8kf3hU1KpawqXtpV6bR/3kgxKVeLe3W+nqMbb+B2hVKu2dn84WWr5gs8V1XfwfJfMVE2m3u9Ni00fJFmpkvGUZKbX8VmBH0j8l8eigZr1OOB7MlzMWiKz/Q5ruetDMdV5/r/SuJ7Y2G225MvKJgDM7EK4n3Tt6el9rOnI8Nrt4ZJnNn5BeMnW5OMoSraMCliU5KZsM/rlIKRkNoEe5unBluUi1Lh45p/pwaY83i71gXLQ833dBfNf3ob2bs9lyl/zjNepYeqPxcLPrL5Yg0/58c52Ejzid+Syf5bP8Bfl/IUEKJIX5pS8AAAAASUVORK5CYII=', 1),
(2, 'Barcelona', 12, 'Ronald Koeman', 'data:image/png;base64,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', 1),
(3, 'Real Madrid', 12, 'Carlo Ancelotti\n', 'data:image/png;base64,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', 1),
(6, 'Los Angeles Lakers\n', 15, 'Family Trust', 'https://img2.freepng.es/20180925/jbg/kisspng-2-1617-los-angeles-lakers-season-logo-2-1718-5ba9f86b53f8b0.430008531537865835344.jpg', 3),
(8, 'Mancheste united', 12, 'Ed Woodward', 'http://1000marcas.net/wp-content/uploads/2020/02/Manchester-United-Logo-1973.jpg', 1),
(9, 'New York Yankees', 33, 'Aaron Boone', 'https://i.pinimg.com/236x/f6/3b/2d/f63b2d754a7bcaaefa0a4cae7407855c.jpg', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `noticias`
--

CREATE TABLE `noticias` (
  `id` int(11) NOT NULL,
  `titulo` varchar(60) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `descripcion` text NOT NULL,
  `id_autor` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `url_imagen` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `noticias`
--

INSERT INTO `noticias` (`id`, `titulo`, `fecha`, `descripcion`, `id_autor`, `id_categoria`, `url_imagen`) VALUES
(5, 'Mike Trout no ira al All-Star Game', '2021-07-07 17:08:37', 'Mike Trout, el jardinero superestrella de los Angels, encabeza las votaciones en su posición para el Juego de Estrellas del 2021 en la MLB. Sin embargo, el manager Joe Maddon dijo que Trout estaría demasiado retrasado en su rehabilitación tras haber sufrido un tirón en a pantorrilla derecha, por lo que será difícil que el jardinero participe en el All-Star Game.\r\n\r\nTrout fue evaluado de nuevo este lunes luego de estar fuera de acción desde el 17 de mayo. Los resultados fueron satisfactorios para el manager, no así para el jardinero que encabeza las votaciones con 706,503 votos, pues el pronóstico es que regrese a la acción en aproximadamente un mes, días después de que se lleve a cabo el evento.\r\n\r\n“Fue examinado y todo va bastante bien. El proceso de sanar está ocurriendo”, dijo Maddon. “El cronograma es por lo menos un mes más. Eso es lo que parece. Si es más rápido, eso sería grandioso. No anticiparía eso, pero todo apunta en la dirección indicada. Creo que podrá correr pronto, pero las actividades de béisbol están en el aire. El (Juego de Estrellas) estaría en el aire. Creo que eso sería mucho pedir, por lo que estoy escuchando ahora mismo”.\r\nMike Trout ha sido seleccionado para el Juego de Estrellas en ocho ediciones consecutivas del 2012 al 2019. La temporada pasada el evento tuvo que ser cancelado por la emergencia sanitaria de la pandemia.', 1, 2, 'https://i1.wp.com/www.elatleta.net/wp-content/uploads/2020/09/Mike-Trout-1.jpg'),
(6, 'Messi se va del barcelona', '2021-07-07 17:19:23', 'Leo Messi es agente libre desde el 1 de julio de 2021, cuando terminó su contrato con el FC Barcelona. El club y Joan Laporta se encuentran cerca de poder cerrar un acuerdo de renovación y así poder atar al aún futbolista más desequilibrante del mundo.\n\nLa salida de Leo Messi del Barça no solo afectaría al FC Barcelona a nivel deportivo y económico, sino que sería también un gran golpe a Hacienda, por los impuestos que el contrato de Leo provoca a las arcas españolas, teniendo en cuenta que si decide buscar otro destino, éste sería fuera del territorio español.\n\nEl régimen fiscal español es el más duro con los futbolistas comparado con las cinco grandes ligas de Europa. Leo tiene que declarar al fisco alrededor de la mitad de todo lo que recibe en salarios, lo que supone unos 50 millones de euros al año que se dirigen directamente hacia las arcas públicas españolas del salario del jugador, convirtiéndose así en el mayor contribuyente de España.\n\nLa Agencia Tributaria, sin Messi como jugador del Barça en LaLiga, deja de recibir una gran cantidad de dinero que se usa para los bienes públicos. De hecho, Messi contribuye a la Hacienda española como 120.000 personas de clase media, teniendo en cuenta la media que pagan los ciudadanos.', 2, 1, 'https://phantom-marca.unidadeditorial.es/25220a30b89f2a9b35ab3eb16916846e/resize/1320/f/jpg/assets/multimedia/imagenes/2021/06/30/16250754690035.jpg'),
(7, 'Lebron James Pelea en el partido de su hijo', '2021-07-07 18:08:25', 'LeBron James volvió a demostrar que no es un padre al uso en los partidos que va a ver jugar a su hijo Bronny. El alero de los Lakers suele entrar en la cancha antes de los encuentros para dar los últimos consejos a su hijo, pero hasta ahora no le habíamos visto discutir como se le pudo ver en el último duelo.\r\n\r\nEl alero no dudó en saltar al parquet e interrumpir el encuentro para encararse con el speaker del pabellón, que aseguró que a Bronny sólo le pitaban las faltas por ser hijo de quien es. Una afirmación que hizo estallar a LeBron, que la entendió como una falta de respeto y fue a pedir explicaciones ante el asombro del público.', 4, 3, 'https://imgresizer.eurosport.com/unsafe/1200x0/filters:format(jpeg):focal(1224x312:1226x310)/origin-imgresizer.eurosport.com/2021/05/01/3124260-64040928-2560-1440.jpg'),
(8, 'Mbappé, portada del FIFA 22 con los colores del PSG', '2021-07-10 14:15:12', 'El fichaje de Mbappé por el Real Madrid se complica. En esta carrera de fondo por conseguir firmar al jugador francés cada detalle es relevante y el último, sin duda, es cuanto menos significativo pues el propio Mbappé ha desvelado que será la imagen de portada de la nueva edición del videojuego de EA Sports, Fifa 22.\r\n\r\nPero eso no es todo, lo relevante es que las imágenes serán con los colores y la equipación del PSG lo que refuerza la idea de que el francés seguirá en París al menos hasta el año que viene.\r\n\r\npor su parte, Mbappé sigue sin renovar y eso mantiene las esperanzas en el Real Madrid pero lo cierto es que todo este tipo de gestos no ayudan a que el conjunto blanco y el ‘10’ de Francia unan sus caminos durante este verano.\r\n\r\n“Volver a la portada de FIFA es increíble” destaca Kylian Mbappé. “Tengo una relación muy especial con el videojuego y no veo la hora de poder disfrutar de FIFA 22 con todos vosotros”, ha expresado.\r\n\r\nKylian Mbappé Lottin es un futbolista francés de ascendencia argelina y camerunesa. Juega como delantero y su equipo actual es el París Saint-Germain Football Club de la Ligue 1 de Francia. Es internacional absoluto con la selección de Francia desde 2017. ', 2, 1, 'https://media.vandal.net/i/1200x630/86863/fifa-21-20201113865367_1.jpg'),
(9, 'Gaal, La UEFA se ha equivocado con el  formato de la Euro', '2021-07-10 14:25:00', 'El técnico holandés sentencia que el nivel futbolístico del torneo ha bajado\r\n\r\n\r\nSelección Holandesa. Frank de Boer deja de ser seleccionador de Países Bajos\r\nLouis Van Gaal ha concedido una entrevista a L \'Equipe en la que realiza su propio análisis de la Eurocopa. Al siempre polémico técnico de los Países Bajos parece no haberle convencido el nivel futbolístico del torneo, a pesar de la cantidad de récords que se han batido en el torneo. \"La UEFA ha cometido un grave error con el cambio de formato, pasando de 16 equipos a 24 ha bajado el nivel del torneo. En la fase de grupos la mayor parte de los partidos no son interesantes\".\r\n\r\nEl ex seleccionador holandés también se pronunció acerca de cuestiones como Mbappé, el Paris Saint-Germain, el cuestionado 3-5-2 y su posible vuelta al banquillo de la \'Orange\'.\r\n\r\nSu conclusión sobre la Eurocopa\r\n\"No es una coincidencia que los primeros favoritos eliminados hayan sido Portugal, Alemania y Francia. Sus técnicos son los que llevan más tiempo al frente de la selección, se niegan a hacer cambios porque confían en los jugadores que le han llevado a ser campeones y acaban fracasando. Esto se debe a que el equilibrio jugador-entrenador ya está alterado\".\r\n\r\nItalia, su favorita\r\n\"Italia es el mejor equipo que he visto durante el torneo, espero que ganen. Han sabido evolucionar en su juego, dejando atrás el catenaccio para desplegar un juego colectivo en el que el equipo destaca por encima de lo individual.\"\r\n\r\nEl polémico 3-5-2 de los Países Bajos\r\n\"Yo lo probé en el Mundial de Brasil, es el sistema que más me gusta, te permite atacar y defender con mucho equilibrio. El problema en los Países Bajos es que se considera erróneamente un sistema defensivo, pero el Chelsea de Tuchel acaba de ganar la Champions con un juego parecido\".\r\n fracaso de la \'Orange\'\r\n\"He visto un equipo sin ánimo, que no ha querido luchar por la victoria. Fíjate en Suiza contra Francia o en Croacia contra España pelearon hasta el final, eso es lo que valoro de un equipo.Países Bajos tiene jugadores fantásticos pero en la Euro no han aparecido. Esto mismo se aplica a Portugal o Francia, para mí no son equipos\".\r\n\r\nSu posible vuelta al banquillo holandés\r\n\"Si vienen a verme, me lo pensaré aunque no creo que lo hagan. Sería increíble que me lo ofrecieran por tercera vez. En ese caso, tendría que pensarlo, ¡incluso si estoy jubilado!\". (La entrevista se realizó días antes de que el entrenador se reuniera con miembros de la Federación Holandesa para negociar su regreso a la selección).', 3, 1, 'https://phantom-marca.unidadeditorial.es/6118f4b9d9f0db9d5e8174e74dae5aef/resize/1320/f/jpg/assets/multimedia/imagenes/2021/07/09/16258239182814.jpg'),
(10, 'Kershaw va por una inflamación en el brazo izquierdo', '2021-07-10 14:37:41', 'Malas noticias para los campeones Dodgers de Los Angeles, quienes informaron este miércoles que su pitcher abridor estrella, Clayton Kershaw, ha sido mandado a la lista de lesionados.Los Dodgers informaron que Kershaw sufre una inflamación en el antebrazo izquierdo, por lo que ha sido puesto en la lista de lesionados por 10 días, perdiendo así a uno de sus mejores brazos.La baja de Clayton se une a la del mexicano Victor González, quien sufre una fascitis plantar en el pie izquierdo y también fue puesto en la lista de 10 días.\r\n\r\n\r\nMientras el equipo perdió los dos primeros encuentros en su visita a Miami, Los Angeles Dodgers anunciaron que su estelar lanzador, Clayton Kershaw fue enviado a la lista de lesionados de 10 días debido a una inflamación en el codo izquierdo. Al hacer este movimiento, la escuadra decidió subir al lanzador derecho Mitch White, de 25 años, que está con el equipo grande por cuarta vez esta temporada y tiene récord de 0-0 con EFE de 3.77 en 14.2 innings, con 14 ponches, en 12 juegos para los Dodgers \r\n\r\nLa escuadra angelina es actualmente el segundo lugar de la División Oeste con una marca de 53-33, pero ha perdido los dos juegos que han disputado en Miami esta semana. Kershaw, de 32 años, será colocado en la lista de lesionados por primera vez esta temporada. Tiene récord de 9-7 con EFE de 3.39 (40 CL en 106.1 IP) y 127 ponches por 19 boletos en 18 aperturas esta temporada.', 4, 2, 'https://ca-times.brightspotcdn.com/dims4/default/0072d95/2147483647/strip/true/crop/3683x2457+0+0/resize/1486x991!/quality/90/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F16%2Fc8%2F559b0b154f13b2ff155ad47437c4%2Fdodgers-astros-baseball-40145.jpg'),
(11, 'Diop se une a las filas del Herbalife Gran Canaria', '2021-07-10 15:28:59', 'Llevaba unos días gestándose y hoy se ha confirmado. Ilimane Diop pone fin a una década en Vitoria para unirse a las filas del Herbalife Gran Canaria. El hispano-senegalés ha firmado un contrato de cara a las próximas dos temporadas con los isleños.\r\n\r\nHace ya diez años que Diop aterrizó en Baskonia, donde se había convertido en una pieza importante del equipo hasta que Dusko Ivanovic le relegó al fondo del banquillo esta temporada. Este año tan solo pudo promediar 4.2 puntos y 1.7 rebotes debido a los pocos minutos.\r\n\r\nPor este motivo Diop estaba buscando una salida y Canarias parecía el destino apropiado. El Granca estaba buscando un poste al que dar minutos de calidad para seguir mejorando su plantilla y lo ha encontrado en Diop.\r\n\r\nEl poste se une a Nicolás Brussino, otro de los fichajes de este verano de los canarios, y la renovación de John Shurna, pieza vital del equipo que entrena Porfi Fisac.\r\n\r\n“Alternando posiciones de pívot y ala-pívot, exhibiendo una mejora constante en el tiro exterior, Diop defendió la elástica baskonista en un total de 451 encuentros: 258 en Liga Endesa, y 193 en la Turkish Airlines EuroLeague”, ha explicado el equipo en su web.\r\n\r\nEl jugador pone fin a su etapa en Vitoria y rumbo a las islas\r\n\r\nEl hispano-senegalés llevaba una década en el Baskonia', 2, 3, 'https://e00-marca.uecdn.es/assets/multimedia/imagenes/2020/07/08/15941965692942.jpg'),
(12, 'Dybala, en cuenta atrás', '2021-07-10 17:04:39', 'El argentino llega esta semana a Turín para esclarecer su situación, con o sin Cristiano. Pide 10 millones para renovar y protagonismo. Termina contrato en un año.\r\n\r\nDybala es uno de los temas \r\npendientes de la Juventus. Si la continuidad de Cristiano lastra muchos de los movimientos que pueda hacer el club en el mercado, la de Dybala no es menos importante institucionalmente. El argentino ha entrado en la cuenta atrás. Ya agota su último año de contrato después de meses de tiras y aflojas con el club. Su situación recuerda a la de Sergio Ramos, porque aquí también se filtró una oferta que después caducó y ahora hay que retomar las conversaciones.\r\n\r\nEl argentino apura sus últimos días de vacaciones antes de reincorporarse a la Juventus. Se le espera ya en Turín en las próximas horas. Para el equipo piamontés su situación es extrema y urge una solución. Termina contrato en 2022 y todavía no ha renovado después de meses de conversaciones. Ha entrado en su último año de vínculo y para la Juventus ya es un todo o nada. Dybala pide un sueldo base de 10 millones netos para firmar, la misma propuesta que se le hizo hace meses con Paratici a los mandos de las operaciones turinesas y que después se aparcó, pero sobre todo quiere oír de boca de Allegri que tendrá un papel importante, con o sin Cristiano Ronaldo en el equipo. Para la Juventus será un tema capital en los próximos días.\r\n\r\nDybala se marchó de vacaciones y su intención era seguir en la Juventus, un club que acudió a un rescate financiero con una ampliación de capital de 400 millones y que ha llevado a cabo varios cambios en sus puestos de gestión deportiva en las últimas semanas. Allegri ha recuperado los mandos del equipo y Dybala también está pendiente en conocer de boca del entrenador sus intenciones con él antes de decidirse. Su nombre estará muy de actualidad durante los próximos días. Equipos como el Atlético se interesaron por é', 3, 1, 'https://images.daznservices.com/di/library/GOAL/e1/1f/paulo-dybala-genoa-juventus_lvn3i039h4do1ax2n3ud3i4fe.jpg?t=1643852934&quality=100'),
(13, 'Juego de Estrellas 2021: Lo que debes saber', '2021-07-10 17:27:56', 'Lo que normalmente sirve como una distracción a mediados de temporada tiene un significado mayor: El Juego de Estrellas. En el 2021, juntar a los mejores jugadores de béisbol en el Coors Field de Colorado no sólo será un evento de entretenimiento, sino un símbolo del resurgir. Luego de que el coronavirus nos arrebatara tanta vida y libertad, llega un evento al centro de Denver que ejemplifica la reapertura oficial de las Mayores.\r\n\r\nComo mucho de lo ocurrido en el último año y medio, el Juego de Estrellas sufrió una alteración a último momento. Luego de un cambio en la planificación, el Coors Field está listo para recibir el Clásico de Media Temporada por primera vez desde 1998.\r\n\r\n\r\nY  si el Coors es lo que conocemos del Coors, entonces será un evento bien emocionante. (El Juego de Estrellas de 1998 lo ganó la Liga Americana por 13-8, el marcador más abultado en la historia del evento).\r\n\r\nYa tenemos garantizado presenciar historia, con Shohei Ohtani convirtiéndose en el primer jugador en la historia en batear y lanzar en el evento que tuvo sus inicios en 1933.\r\n\r\nPero con tanto talento en el terreno – desde jóvenes talentosos como los dominicanos Vladimir Guerrero Jr., Fernando Tatis Jr. y el venezolano Ronald Acuña Jr., hasta veteranos establecidos como Mookie Betts y Buster Posey – cualquier cosa puede suceder.\r\n\r\nMientras las estrellas se preparan para subirse al escenario, aquí responderemos algunas de tus preguntas sobre la edición 91 del Juego de Estrellas.\r\n\r\n¿Cómo puedo ver el juego?\r\n\r\nLa transmisión nacional en EE.UU. por FOX empezará a las 7:30 p.m. ET.\r\n\r\nEl juego también será transmitido en Canadá por Rogers Sportsnet y RDS. FOX Deportes transmitirá el partido en español en EE.UU., mientras que ESPN Deportes se encargará de la cobertura por audio\r\n\r\nQuiénes serán los lanzadores abridores?\r\n\r\nSerán anunciados por el manager de la Liga Americana (y Rays) Kevin Cash y el de la Liga Nacional (y Dodgers) Dave Roberts el lunes.\r\n\r\n¿Cuáles serán las alineaciones?\r\n\r\nEl orden específico también será anunciado por cada uno de los managers el lunes. Pero aquí están los jugadores elegidos por los aficionados.\r\n\r\n*denota a un jugador inactivo por lesión\r\n\r\n+Se decantó por no participar en el Juego de Estrellas', 4, 2, 'https://img.mlbstatic.com/mlb-images/image/private/t_16x9/t_w1024/mlb/wz2ooqdnlrlkcxsiz6fv'),
(14, 'Argentina Campeón de la Copa América 2021', '2021-07-11 02:23:41', 'Argentina luego de 28 años se volvió a proclamar campeón de la Copa América, tras vencer a Brasil en el mítico Maracaná 1-0 con anotación de Ángel Di María, en la gran final del torneo más antiguo de selecciones. Lionel Messi su capitán luego de 5 finales disputadas con la “Albiceleste”, al fin levantó un trofeo de campeón con su selección.\r\n\r\nEn los primeros minutos Brasil manejó la posesión del balón, teniendo llegadas imprecisas al área de Emiliano Martínez con Neymar, pero los dirigidos por Scaloni mantuvieron sus líneas y presionaron la salida de los brasileños.\r\n\r\nPaulatinamente equipararon las acciones y al minuto 21 un pase medido del volante Rodrigo De Paúl encontró habilitado a Ángel Di María, quien con un “sombrerito” sorprendió al golero Ederson y convirtió el único tanto del compromiso, pero la verdeamarela, buscó igualar las acciones del encuentro. Pero con el 1-0 se fueron al descanso del primer tiempo.\r\n\r\nPara la segunda etapa la “canarinha” tomó la iniciativa nuevamente, pero la zaga de Argentina liderada por Nicolás Otamendi aguantó las llegadas de Richarlison junto a Neymar, pasando más de un susto que no engordaron la portería del golero Martínez.\r\n\r\nArgentina se consagró campeón de Copa América, la cual se hizo esquiva desde 1993, que ganaron en Ecuador, desde entonces perdieron 4 finales y en este 2021 con Messi como capitán consiguen el título para la albiceleste que comanda Scaloni.', 3, 1, 'https://i1.wp.com/copaamericacom.wpcomstaging.com/wp-content/uploads/Copia-de-Header-Thumb-Site-Copa-Ame%CC%81rica-49.png?fit=1744%2C778&ssl=1'),
(15, 'Yankees apagan a Astros con joya de Cole', '2021-07-11 02:31:56', 'El abridor Gerrit Cole pidió al piloto Aaron Boone le dejara aplicar el último out, ponchó al cubano Yordan Álvarez con una bola rápida de 99 mph en su 129no lanzamiento -la cifra más alta de su carrera- y los Yanquis de Nueva York doblegaron el sábado 1-0 a los Astros de Houston.\r\n\r\nAaron Judge conectó un jonrón solitario y Cole hizo el resto, terminar el quinto partido completo y tercera blanqueada de su trayectoria. Sólo concedió tres hits. Su anterior blanqueada a nueve entradas fue contra Arizona el 4 de mayo de 2018, cuando era lanzador de Houston.\r\n\r\nLos Astros, líderes de la Liga Americana, que antes de esta serie habían sido blanqueados sólo una vez en toda la campaña, ahora fueron dejados en blanco por segundo partido consecutivo tras perder 4-0 en el primer encuentro el viernes en la noche.\r\n\r\nCole (9-4), lanzador de los Astros de 2018 a 2019, empató su cifra más baja de hits en la temporada y ponchó a 12. Efectuó 129 lanzamientos, la cifra más alta esta campaña en las mayores porque rebasaron los 126 de Trevor Bauer.\r\n\r\nZack Greinke (8-3) cargó con la derrota. Trabajó cuatro entradas en las que le anotaron tres hits y una carrera.\r\n\r\nPor los Yanquis, el venezolano Gleyber Torres de 4-1. El colombiano Gio Urshela de 4-1.\r\n\r\nPor los Astros, el venezolano José Altuve de 3-1. Los cubano Yuli Gurriel de 4-1 y Yordan Alvarez de 4-0. El puertorriqueño Martín Maldonado de 3-0. El dominicano Robel García de 3-0.', 1, 2, 'https://st1.uvnimg.com/34/19/b384e70f48bdba0cd21bb0cf9623/yankees.jpg'),
(16, 'Los Bucks son el equipo más tonto en la historia en la NBA', '2021-07-11 02:41:07', 'Los dos primeros partidos de las Finales de la NBA han dejado un panorama despejado para que los Phoenix Suns se apunten el primer título de su historia. El equipo que dirige Monty Williams ganó los dos y se han colocado al borde del anillo después de una temporada sublime.\r\n\r\nPero igual que los Suns celebran sus dos victorias, los Milwaukee Bucks capean, como pueden, el temporal. Y es que tras su dubitativa puesta en escena en las Finales arrecian las críticas contra el equipo de Wisconsin que ahora tienen el tremendo reto de tratar de remontar un 2-0 en las Finales.\r\n\r\nEntre los más críticos de los Bucks está el ex de la NBA y ahora analista Kendrick Perkins, conocido por no morderse la lengua ante nada ni nadie. Perkins ha catalogado a los Bucks como \"el equipo más tonto de la historia de las Finales\", y lo argumenta con un vídeo en el que habla de lo \"perturbador que es ver cómo juegan, de su falta de liderazgo y de lo ridículo que resulta la poca ventaja que sacan de los desajustes desfensivos\".\r\n\r\n\r\nKendrick Perkins tira con bala a Milwaukee tras los dos primeros partidos de la serie\r\n\r\nEnviar por email\r\n\r\n41\r\nMostrar comentarios\r\nSegundo partido. Devin Booker y los Suns neutralizan a Antetokounmpo\r\nContracrónica. Si Giannis es todo lo que tienen los Bucks... \"Suns in four\"\r\nLos dos primeros partidos de las Finales de la NBA han dejado un panorama despejado para que los Phoenix Suns se apunten el primer título de su historia. El equipo que dirige Monty Williams ganó los dos y se han colocado al borde del anillo después de una temporada sublime.\r\n\r\nPero igual que los Suns celebran sus dos victorias, los Milwaukee Bucks capean, como pueden, el temporal. Y es que tras su dubitativa puesta en escena en las Finales arrecian las críticas contra el equipo de Wisconsin que ahora tienen el tremendo reto de tratar de remontar un 2-0 en las Finales.\r\n\r\nEntre los más críticos de los Bucks está el ex de la NBA y ahora analista Kendrick Perkins, conocido por no morderse la lengua ante nada ni nadie. Perkins ha catalogado a los Bucks como \"el equipo más tonto de la historia de las Finales\", y lo argumenta con un vídeo en el que habla de lo \"perturbador que es ver cómo juegan, de su falta de liderazgo y de lo ridículo que resulta la poca ventaja que sacan de los desajustes desfensivos\".\r\n\r\n\r\nPerkins añade que los Bucks no están mostrando el nivel de equipo campeón que se les suponía, cometiendo errores infantiles y permitiendo situaciones que un equipo finalista de la NBA se supone que debe cuidar. Excesivas pérdidas de balón muy evitables, malas decisiones en los tiros, ataques precipitados cuando llegaban con ventaja... Todo ello ha redundado en el 2-0 que ahora lucen y tienen que remontar.\r\n\r\nY no se trata de cargar las tintas contra Giannis Antetokounmpo, porque el esfuerzo del griego volviendo tras su lesión y el rendimiento en el segundo partido fueron dignos de elogio: 42 puntos y 12 rebotes. Pero está muy solo.', 1, 3, 'https://phantom-marca.unidadeditorial.es/09a1b91bc8437e047f835c82caed41b1/resize/1320/f/jpg/assets/multimedia/imagenes/2021/07/05/16255128738677.jpg'),
(17, '¡Italia, campeón de la Eurocopa!', '2021-07-19 00:15:22', 'alia se coronó este domingo en la Eurocopa 2020 luego de la tanda de penales frente a Inglaterra. Esta es la segunda vez que los italianos se llevan a casa el máximo torneo de selecciones en Europa y la primera vez en 15 años que ganan un torneo de selección mayor.\n\n\nEl gol de Luke Shaw en los dos primeros minutos de la final dio a Inglaterra una ventaja que parecía que iba a mantener toda la noche, antes de que una serie de rebotes a mediados de la segunda parte permitiera a Leonardo Bonucci marcar el empate para Italia.\n\nDurante el resto del partido pareció que la prórroga y los penaltis eran inevitables, ya que ninguno de los dos equipos parecía estar dispuesto o ser lo suficientemente atrevido para comprometer a suficientes jugadores en la delantera como para poner en apuros a los defensores contrarios.', 3, 1, 'https://i.ytimg.com/vi/q0IOISxOMxs/maxresdefault.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recargas`
--

CREATE TABLE `recargas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `apellido` varchar(30) NOT NULL,
  `tarjeta` varchar(30) NOT NULL,
  `numero_tarjeta` bigint(255) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `recargas`
--

INSERT INTO `recargas` (`id`, `nombre`, `apellido`, `tarjeta`, `numero_tarjeta`, `id_cliente`, `fecha`) VALUES
(1, 'Jose ', 'Rodriguez', 'VISA', 4020342213, 1, '2021-07-08 22:32:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `rol` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `rol`) VALUES
(1, 'Administrador'),
(2, 'Observador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seguimientos`
--

CREATE TABLE `seguimientos` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_equipo` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `seguimientos`
--

INSERT INTO `seguimientos` (`id`, `id_cliente`, `id_equipo`, `fecha`) VALUES
(4, 1, 1, '2021-07-08 22:27:14'),
(5, 1, 3, '2021-07-08 22:27:26'),
(6, 8, 2, '2021-07-08 22:27:26'),
(7, 9, 3, '2021-07-08 22:28:22'),
(18, 8, 1, '2021-07-16 05:04:16'),
(19, 8, 6, '2021-07-16 05:04:18'),
(20, 8, 3, '2021-07-16 05:04:18'),
(21, 8, 8, '2021-07-16 05:04:19'),
(22, 8, 9, '2021-07-16 05:04:20'),
(23, 10, 2, '2021-07-19 00:53:40');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `clave` varchar(70) NOT NULL,
  `id_rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `usuario`, `clave`, `id_rol`) VALUES
(1, 'Administrador', 'admin', '$2b$10$NjUeoXRAnfrVVnRoGqscM.UvMt5/73tMyX1Msy8xukHEJ5N72ZoWC', 1),
(2, 'Anyelo', 'anyelo', '$2b$10$S8xqSO6R7SFFnvH.jmY8veIPOBp1sNx7E7WozqpcH7N./Mtui7nNy', 2),
(27, 'Jose', 'adminjose', '$2b$10$Lf7xr5EeoYfNbR6ynUiN.OTiCURdHfSw4D0wytr9w3KF2BPcM/53O', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `apuestas`
--
ALTER TABLE `apuestas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_equipo1` (`id_equipo1`,`id_equipo2`),
  ADD KEY `apuestas_ibfk_2` (`id_equipo2`);

--
-- Indices de la tabla `apuestas_clientes`
--
ALTER TABLE `apuestas_clientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `apuestas_clientes_ibfk_1` (`id_cliente`),
  ADD KEY `apuestas_clientes_ibfk_2` (`id_equipo`),
  ADD KEY `apuestas_clientes_ibfk_3` (`id_apuesta`);

--
-- Indices de la tabla `autores`
--
ALTER TABLE `autores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `contactos`
--
ALTER TABLE `contactos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `id_categoria` (`id_categoria`);

--
-- Indices de la tabla `noticias`
--
ALTER TABLE `noticias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_autor`),
  ADD KEY `id_categoria` (`id_categoria`);

--
-- Indices de la tabla `recargas`
--
ALTER TABLE `recargas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_tarjeta` (`numero_tarjeta`),
  ADD UNIQUE KEY `id_cliente_2` (`id_cliente`),
  ADD UNIQUE KEY `id_cliente_3` (`id_cliente`),
  ADD UNIQUE KEY `numero_tarjeta_2` (`numero_tarjeta`,`id_cliente`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rol` (`rol`);

--
-- Indices de la tabla `seguimientos`
--
ALTER TABLE `seguimientos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_cliente` (`id_cliente`,`id_equipo`),
  ADD KEY `seguimientos_ibfk_2` (`id_equipo`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario` (`usuario`),
  ADD KEY `id_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `apuestas`
--
ALTER TABLE `apuestas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `apuestas_clientes`
--
ALTER TABLE `apuestas_clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT de la tabla `autores`
--
ALTER TABLE `autores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT de la tabla `contactos`
--
ALTER TABLE `contactos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de la tabla `equipos`
--
ALTER TABLE `equipos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT de la tabla `noticias`
--
ALTER TABLE `noticias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT de la tabla `recargas`
--
ALTER TABLE `recargas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `seguimientos`
--
ALTER TABLE `seguimientos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `apuestas`
--
ALTER TABLE `apuestas`
  ADD CONSTRAINT `apuestas_ibfk_1` FOREIGN KEY (`id_equipo1`) REFERENCES `equipos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `apuestas_ibfk_2` FOREIGN KEY (`id_equipo2`) REFERENCES `equipos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `apuestas_clientes`
--
ALTER TABLE `apuestas_clientes`
  ADD CONSTRAINT `apuestas_clientes_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `apuestas_clientes_ibfk_2` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `apuestas_clientes_ibfk_3` FOREIGN KEY (`id_apuesta`) REFERENCES `apuestas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD CONSTRAINT `equipos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `noticias`
--
ALTER TABLE `noticias`
  ADD CONSTRAINT `noticias_ibfk_1` FOREIGN KEY (`id_autor`) REFERENCES `autores` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `noticias_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `recargas`
--
ALTER TABLE `recargas`
  ADD CONSTRAINT `recargas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `seguimientos`
--
ALTER TABLE `seguimientos`
  ADD CONSTRAINT `seguimientos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `seguimientos_ibfk_2` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
