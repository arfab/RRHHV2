using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class ResponsableController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1 || perfil_id == 2)
            {
                IResponsableRepo responsableRepo;

                responsableRepo = new ResponsableRepo();

                return View(responsableRepo.ObtenerTodos());
            }

            return View();


        }

        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            if (id != null)
            {
                IResponsableRepo responsableRepo;

                responsableRepo = new ResponsableRepo();

                Responsable res = new Responsable();

                res = responsableRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(res);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }


        [HttpPost]
        public IActionResult Edit(int? id, Responsable responsable)
        {

            string sret;
            IResponsableRepo responsableRepo;

            if (ModelState.IsValid)
            {

                responsableRepo = new ResponsableRepo();

                if (id != null)
                    sret = responsableRepo.Modificar(responsable);
                else
                    sret = responsableRepo.Insertar(responsable);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Responsable");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(responsable);
        }


        public IActionResult Delete(int hfID)
        {
            string sret;
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            IResponsableRepo responsableRepo;

            responsableRepo = new ResponsableRepo();

            sret=responsableRepo.Eliminar(hfID);

            if (sret == "")
            {

                return RedirectToAction("Index", "Responsable");
            }
            else
            {
                ViewBag.Message = sret;

                return View("Index", responsableRepo.ObtenerTodos());
            }

           

        }

    }
}
