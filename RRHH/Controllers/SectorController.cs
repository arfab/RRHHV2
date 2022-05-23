using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class SectorController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                ISectorRepo sectorRepo;

                sectorRepo = new SectorRepo();

                return View(sectorRepo.ObtenerTodos());
            }

            return View();


        }

        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            if (id!=null)
            {
                ISectorRepo sectorRepo;
                sectorRepo = new SectorRepo();

                Sector sec = new Sector();

                sec = sectorRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(sec);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }
            

        }



        [HttpPost]
        public IActionResult Edit(int? id, Sector sector)
        {

            string sret;
            ISectorRepo sectorRepo;

            if (ModelState.IsValid)
            {

                sectorRepo = new SectorRepo();

                if (id != null)
                    sret = sectorRepo.Modificar(sector);
                else
                    sret = sectorRepo.Insertar(sector);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Sector");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(sector);
        }

    }
}
