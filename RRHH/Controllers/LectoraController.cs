using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class LectoraController : Controller
    {
        static readonly string strConnectionString = Tools.GetConnectionString();


        private Microsoft.AspNetCore.Hosting.IWebHostEnvironment Environment;

        public LectoraController(Microsoft.AspNetCore.Hosting.IWebHostEnvironment _environment)
        {
            Environment = _environment;
        }


        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                ILectoraRepo lectoraRepo;

                lectoraRepo = new LectoraRepo();

                return View(lectoraRepo.ObtenerTodos());
            }

            return RedirectToAction("Login", "Usuario");


        }



        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            Lectora lectora = new Lectora();

            if (id != null)
            {
                ILectoraRepo lectoraRepo;

                lectoraRepo = new LectoraRepo();

               

                lectora = lectoraRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(lectora);
            }
            else
            {
                ViewData["ID"] = 0;
                return View(lectora);
            }


        }



        [HttpPost]
        public IActionResult Edit(int? id, Lectora lectora)
        {

            string sret;
            ILectoraRepo lectoraRepo;

            //if (ModelState.IsValid)
            //{

            lectoraRepo = new LectoraRepo();

            if (id != null)
                sret = lectoraRepo.Modificar(lectora);
            else
                sret = lectoraRepo.Insertar(lectora);

            if (sret == "")
            {

                return RedirectToAction("Index", "Lectora");
            }
            else
            {
                ViewBag.Message = sret;
            }

            // }

            return View(lectora);
        }

        public IActionResult Delete(int hfID)
        {
            string sret;
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            ILectoraRepo lectoraRepo;

            lectoraRepo = new LectoraRepo();

            sret = lectoraRepo.Eliminar(hfID);


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
