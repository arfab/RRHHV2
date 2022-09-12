using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class ParametroController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                IParametroRepo parametroRepo;

                parametroRepo = new ParametroRepo();

                return View(parametroRepo.ObtenerTodos());
            }

            return RedirectToAction("Login", "Usuario");


        }

        [HttpGet]
        public IActionResult Edit(string codigo)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            if (codigo != null)
            {
                IParametroRepo parametroRepo;

                parametroRepo = new ParametroRepo();

                Parametro parametro = new Parametro();

                parametro = parametroRepo.Obtener(codigo);

                ViewData["CODIGO"] = codigo;

                return View(parametro);
            }
            else
            {
                ViewData["CODIGO"] = "";
                return View();
            }


        }



        [HttpPost]
        public IActionResult Edit(string codigo, Parametro parametro)
        {

            string sret;

            IParametroRepo parametroRepo;

            //if (ModelState.IsValid)
            //{

            parametroRepo = new ParametroRepo();

            //if (codigo != null)
            //    sret = parametroRepo.Modificar(parametro);
            //else
            sret = parametroRepo.Insertar(parametro);

            if (sret == "")
            {

                return RedirectToAction("Index", "Parametro");
            }
            else
            {
                ViewBag.Message = sret;
            }

            // }

            return View(parametro);
        }

        public IActionResult Delete(string hfCodigo)
        {
            string sret;
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
         
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            IParametroRepo parametroRepo;

            parametroRepo = new ParametroRepo();

            sret = parametroRepo.Eliminar(hfCodigo);


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
