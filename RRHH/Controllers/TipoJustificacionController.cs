using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class TipoJustificacionController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ITipoJustificacionRepo tipoJustificacionRepo;

                tipoJustificacionRepo = new TipoJustificacionRepo();

                return View(tipoJustificacionRepo.ObtenerTodos());
            }

            return RedirectToAction("Login", "Usuario");


        }

        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            if (id != null)
            {
                ITipoJustificacionRepo tipoJustificacionRepo;

                tipoJustificacionRepo = new TipoJustificacionRepo();

                TipoJustificacion tipo = new TipoJustificacion();

                tipo = tipoJustificacionRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(tipo);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }



        [HttpPost]
        public IActionResult Edit(int? id, TipoJustificacion tipoJustificacion)
        {

            string sret;
            ITipoJustificacionRepo tipoJustificacionRepo;

            //if (ModelState.IsValid)
            //{

                tipoJustificacionRepo = new TipoJustificacionRepo();

                if (id != null)
                    sret = tipoJustificacionRepo.Modificar(tipoJustificacion);
                else
                    sret = tipoJustificacionRepo.Insertar(tipoJustificacion);

                if (sret == "")
                {

                    return RedirectToAction("Index", "TipoJustificacion");
                }
                else
                {
                    ViewBag.Message = sret;
                }

           // }

            return View(tipoJustificacion);
        }

        public IActionResult Delete(int hfID)
        {
            string sret;
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            ITipoJustificacionRepo tipoJustificacionRepo;

            tipoJustificacionRepo = new TipoJustificacionRepo();

            sret = tipoJustificacionRepo.Eliminar(hfID);


            if (sret == "")
            {

                return RedirectToAction("Index");
            }
            else
            {
                ViewBag.Message = sret;
            }

            return RedirectToAction("Index");

        }
    }
}
