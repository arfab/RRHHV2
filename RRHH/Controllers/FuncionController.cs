using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class FuncionController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                IFuncionRepo funcionRepo;

                funcionRepo = new FuncionRepo();

                return View(funcionRepo.ObtenerTodos());
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
                IFuncionRepo funcionRepo;

                funcionRepo = new FuncionRepo();

                Funcion fun = new Funcion();

                fun = funcionRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(fun);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }



        [HttpPost]
        public IActionResult Edit(int? id, Funcion funcion)
        {

            string sret;
            IFuncionRepo funcionRepo;

            if (ModelState.IsValid)
            {

                funcionRepo = new FuncionRepo();

                if (id != null)
                    sret = funcionRepo.Modificar(funcion);
                else
                    sret = funcionRepo.Insertar(funcion);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Funcion");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(funcion);
        }

        public IActionResult Delete(int hfID)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            IFuncionRepo funcionRepo;

            funcionRepo = new FuncionRepo();

            funcionRepo.Eliminar(hfID);


            return RedirectToAction("Index");

        }
    }
}
