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
        public IActionResult Edit(int? legajo_id, int lectora_id, String fecha, String entrada_1, String salida_1, String entrada_2, String salida_2, String entrada_3, String salida_3)
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
        public IActionResult Edit(string modo, int legajo_id, int lectora_id, String fecha, String entrada_1, String salida_1, String entrada_2, String salida_2, String entrada_3, String salida_3)
        {

            ILegajoFichadaRepo legajoFichadaRepo;
            LegajoFichada legajoFichada = new LegajoFichada();
            string sret;

            Legajo legajo = new Legajo();
            ILegajoRepo legajoRepo;
            legajoRepo = new LegajoRepo();
            legajo = legajoRepo.Obtener(legajo_id);


            if (legajo != null)
            {
                legajoFichada.nro_legajo = legajo.nro_legajo.Value;
                legajoFichada.empresa_id = legajo.empresa_id.Value;

                ViewData["EMPRESA_ID"] = legajoFichada.empresa_id;
                ViewData["NRO_LEGAJO"] = legajoFichada.nro_legajo;
                ViewData["FiltroFichadaActual"] = legajoFichada.nro_legajo;
                ViewData["EmpleadoActual"] = legajo.id;
            }

            if (legajo_id <= 0)
            {
                ViewBag.Message = "El legajo es obligatorio";
                return View(legajoFichada);
            }
            //if (ModelState.IsValid)
            //{

            if (entrada_1 == null && salida_1!=null ||
                salida_1 == null && entrada_2!= null ||
                entrada_2 == null && salida_2!= null ||
                salida_2 == null && entrada_3 != null
                )
             {
                ViewBag.Message = "No pueden saltearse horarios de fichadas";
                return View(legajoFichada);
            }

           

            if (entrada_1 != null && salida_1 != null)
            {
                TimeSpan span1 = DateTime.Parse(salida_1).Subtract(DateTime.Parse(entrada_1));

                if (span1.TotalMinutes < 2)
                {
                    ViewBag.Message = "La salida 1 debe ser mayor a 2 minutos que la entrada 1";
                    return View(legajoFichada);
                }
            }


            if (salida_1 != null && entrada_2 != null)
            {
                TimeSpan span1 = DateTime.Parse(entrada_2).Subtract(DateTime.Parse(salida_1));

                if (span1.TotalMinutes < 2)
                {
                    ViewBag.Message = "La entrada 2 debe ser mayor a 2 minutos que la salida 1";
                    return View(legajoFichada);
                }
            }

            if (entrada_2 != null && salida_2 != null)
            {
                TimeSpan span1 = DateTime.Parse(salida_2).Subtract(DateTime.Parse(entrada_2));

                if (span1.TotalMinutes <2)
                {
                    ViewBag.Message = "La salida 2 debe ser mayor a 2 minutos que la entrada 2";
                    return View(legajoFichada);
                }
            }

            if (salida_2 != null && entrada_3 != null)
            {
                TimeSpan span1 = DateTime.Parse(entrada_3).Subtract(DateTime.Parse(salida_2));

                if (span1.TotalMinutes < 2)
                {
                    ViewBag.Message = "La entrada 3 debe ser mayor a 2 minutos que la salida 2";
                    return View(legajoFichada);
                }

            }

            if (entrada_3 != null && salida_3 != null)
            {
                TimeSpan span1 = DateTime.Parse(salida_3).Subtract(DateTime.Parse(entrada_3));

                if (span1.TotalMinutes < 2)
                {
                    ViewBag.Message = "La salida 3 debe ser mayor a 2 minutos que la entrada 3";
                    return View(legajoFichada);
                }
            }


            legajoFichadaRepo = new LegajoFichadaRepo();

                legajoFichada.legajo_id = legajo_id;

                legajoFichada.lectora_id = -1;

                legajoFichada.fecha = DateTime.Parse(fecha);

                if (entrada_1!=null) legajoFichada.entrada_1 = entrada_1;
                if (salida_1 != null) legajoFichada.salida_1 = salida_1;
                if (entrada_2 != null) legajoFichada.entrada_2 = entrada_2;
                if (salida_2 != null) legajoFichada.salida_2 = salida_2;
                if (entrada_3 != null) legajoFichada.entrada_3 = entrada_3;
                if (salida_3 != null) legajoFichada.salida_3 = salida_3;

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
            legajoFichada.entrada_3 = null;
            legajoFichada.salida_3 = null;

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
