﻿using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class LegajoHorasController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();

        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LegajoHorasController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }


        public IActionResult Index(int legajo_id, int nro_item)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            ViewData["ITEM_ACTUAL"] = nro_item;




            if (perfil_id > 0)
            {
                ILegajoHorasRepo legajoHorasRepo;

                legajoHorasRepo = new LegajoHorasRepo();

                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                Legajo legajo = new Legajo();

                legajo = legajoRepo.Obtener(legajo_id);


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["ApellidoActual"] = legajo.apellido;
                ViewData["NombreActual"] = legajo.nombre;


                IEnumerable<LegajoHoras> detalle;

                detalle = legajoHorasRepo.ObtenerTodos(legajo_id);



                return View(detalle);

            }



            return View();


        }



        [HttpGet]
        public IActionResult Edit(int? id, int legajo_id, string origen, string modo, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");

            if (perfil_id > 3 && modo != "V") return RedirectToAction("Login", "Usuario");


            LegajoHoras legajoHoras = new LegajoHoras();



            ViewData["ORIGEN"] = origen;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["EmpleadoActual"] = legajo_id;

            if (id != null)
            {
                ILegajoHorasRepo legajoHorasRepo;

                legajoHorasRepo = new LegajoHorasRepo();

                legajoHoras = legajoHorasRepo.Obtener(id.Value);

                if (legajoHoras == null) return RedirectToAction("Index", "LegajoHoras");

                ViewData["ID"] = id.Value;

                ViewData["MODO"] = (modo == null) ? "E" : modo;

                ILegajoRepo legajoRepo;

                legajoRepo = new LegajoRepo();

                Legajo legajo = new Legajo();

                legajo = legajoRepo.Obtener(legajo_id);


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["ApellidoActual"] = legajo.apellido;
                ViewData["NombreActual"] = legajo.nombre;



                return View(legajoHoras);
            }
            else
            {

                Legajo legajo = new Legajo();
                ILegajoRepo legajoRepo;
                legajoRepo = new LegajoRepo();
                legajo = legajoRepo.Obtener(legajo_id);


                ViewData["EmpleadoActual"] = legajo_id;
                ViewData["ApellidoActual"] = legajo.apellido;
                ViewData["NombreActual"] = legajo.nombre;

                ViewData["MODO"] = "A";


                return View(legajoHoras);
            }


        }



        [HttpPost]
        public IActionResult Edit(string modo, int? id, int legajo_id, LegajoHoras legajoHoras, string origen, int nro_item)
        {
            int? usuario_id = HttpContext.Session.GetInt32("UID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            string sret = "";

            ILegajoHorasRepo legajoHorasRepo;

            ViewData["MODO"] = modo;

            ViewData["ITEM_ACTUAL"] = nro_item;

            ViewData["EmpleadoActual"] = legajo_id;
            ViewData["ApellidoActual"] = legajoHoras.apellido;
            ViewData["NombreActual"] = legajoHoras.nombre;



            ViewData["MODO"] = (modo == null) ? "E" : modo;

            string mensaje = "";
            if (valida(legajoHoras, ref mensaje))
            {



                legajoHorasRepo = new LegajoHorasRepo();

                if (modo == "E" || modo == null)
                    sret = legajoHorasRepo.Modificar(legajoHoras);
                else
                {
                    sret = legajoHorasRepo.Insertar(legajo_id, legajoHoras);
                }


                if (sret == "")
                {
                    if (origen == "F")
                        return RedirectToAction("Index", "LegajoHoras", new { legajo_id = legajo_id });
                    else
                        return RedirectToAction("Index", "LegajoHoras", new { legajo_id = legajo_id });

                }


            }
            else
            {
                ViewBag.Message = mensaje;
            }


            return View(legajoHoras);
        }



        public IActionResult Delete(int hfID, string origen, int legajo_id, int nro_item)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            ViewData["ITEM_ACTUAL"] = nro_item;

            ILegajoHorasRepo legajoHorasRepo;

            legajoHorasRepo = new LegajoHorasRepo();

            legajoHorasRepo.Eliminar(hfID);


            if (origen == "F")
                return RedirectToAction("Index", "LegajoHoras", new { legajo_id = legajo_id });
            else
                return RedirectToAction("Index", "LegajoHoras", new { legajo_id = legajo_id });

        }



        public Boolean valida(LegajoHoras legajoHoras, ref string mensaje)
        {


            if (legajoHoras.tipo == "") return false;



            return true;

        }

    }
}
