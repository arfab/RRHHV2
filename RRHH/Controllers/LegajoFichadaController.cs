using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class LegajoFichadaController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Edit(int? legajo_id, int lectora_id, String fecha, String entrada_1, String salida_1, String entrada_2, String salida_2)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ILegajoFichadaRepo legajoFichadaRepo;

            legajoFichadaRepo = new LegajoFichadaRepo();

            LegajoFichada legajoFichada=null;

            if (fecha == null)
            {
                fecha= DateTime.Now.Date.ToString("dd/MM/yyyy");
            }

            if (legajo_id != null)
            {

                if (fecha != null)
                {

                    fecha = DateTime.Parse(fecha).ToString("dd/MM/yyyy");

                    legajoFichada = legajoFichadaRepo.ObtenerPorLegajo(legajo_id.Value, fecha);

                   

                    ViewData["FECHA"] = fecha;
                }

                if (legajoFichada == null) legajoFichada = new LegajoFichada();

                ViewData["LEGAJO_ID"] = legajo_id;
                ViewData["LECTORA_ID"] = lectora_id;

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();
                legajo = legajoRepo.Obtener(legajo_id.Value);


                if (legajo != null)
                {
                    legajoFichada.nro_legajo = legajo.nro_legajo.Value;
                    legajoFichada.empresa_id = legajo.empresa_id.Value;

                    ViewData["EMPRESA_ID"] = legajoFichada.empresa_id;
                    ViewData["NRO_LEGAJO"] = legajoFichada.nro_legajo;
                    ViewData["FiltroFichadaActual"] = legajoFichada.nro_legajo;
                    ViewData["EmpleadoActual"] = legajo.id;
                }
            }

            if (legajoFichada != null)
            {
                ViewData["ID"] = legajoFichada.id;
            }
           

            return View(legajoFichada);


        }



        [HttpPost]
        public IActionResult Edit(string modo, int legajo_id, int lectora_id, String fecha, String entrada_1, String salida_1, String entrada_2, String salida_2)
        {

            ILegajoFichadaRepo legajoFichadaRepo;
            LegajoFichada legajoFichada = new LegajoFichada();
            string sret;


            if (legajo_id <= 0)
            {
                ViewBag.Message = "El legajo es obligatorio";
                return View(legajoFichada);
            }
            //if (ModelState.IsValid)
            //{

            legajoFichadaRepo = new LegajoFichadaRepo();

                legajoFichada.legajo_id = legajo_id;

                legajoFichada.lectora_id = lectora_id;

                legajoFichada.fecha = DateTime.Parse(fecha);

                if (entrada_1!=null) legajoFichada.entrada_1 = entrada_1;
                if (salida_1 != null) legajoFichada.salida_1 = salida_1;
                if (entrada_2 != null) legajoFichada.entrada_2 = entrada_2;
                if (salida_2 != null) legajoFichada.salida_2 = salida_2;

                //if (id != null)
                //    sret = legajoFichadaRepo.Modificar(legajoFichada);
                //else
                sret = legajoFichadaRepo.Insertar(legajoFichada);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Fichada");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            //}

            return View(legajoFichada);
        }


        [HttpPost]
        public IActionResult Delete(int legajo_id, int lectora_id, String fecha)
        {

            string sret;
            ILegajoFichadaRepo legajoFichadaRepo;
            LegajoFichada legajoFichada = new LegajoFichada();

            legajoFichadaRepo = new LegajoFichadaRepo();

            legajoFichada.legajo_id = legajo_id;

            legajoFichada.lectora_id = lectora_id;

            legajoFichada.fecha = DateTime.Parse(fecha);

            legajoFichada.entrada_1 = null;
            legajoFichada.salida_1 = null;
            legajoFichada.entrada_2 = null;
            legajoFichada.salida_2 = null;

            sret = legajoFichadaRepo.Insertar(legajoFichada);

            if (sret == "")
            {

                return RedirectToAction("Index", "Fichada");
            }
            else
            {
                ViewBag.Message = sret;
            }

            //}

            return View(legajoFichada);

        }


        public IActionResult Restaurar(int id)
        {

            string sret;
            ILegajoFichadaRepo legajoFichadaRepo;

            legajoFichadaRepo = new LegajoFichadaRepo();

            sret = legajoFichadaRepo.Eliminar(id);

            if (sret == "")
            {

                return RedirectToAction("Index", "Fichada");
            }
            else
            {
                ViewBag.Message = sret;
            }


            return View();

        }


    }
}
