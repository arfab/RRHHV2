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

                return View(sectorRepo.ObtenerTodos(-1));
            }

            return View();


        }

        [HttpGet]
        public IActionResult Edit(int? id)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");
           
            Sector sec = new Sector();

            if (id!=null)
            {
                ISectorRepo sectorRepo;
                sectorRepo = new SectorRepo();

              

                sec = sectorRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(sec);
            }
            else
            {
                ViewData["ID"] = 0;
                return View(sec);
            }
            

        }



        [HttpPost]
        public IActionResult Edit(int? id, Sector sector)
        {

            string sret;
            ISectorRepo sectorRepo;

            ModelState.Remove("ubicacion");

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

        public IActionResult Delete(int hfID)
        {

            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");
            if (usuario_id == null) return RedirectToAction("Login", "Usuario");


            ISectorRepo sectorRepo;

            sectorRepo = new SectorRepo();

            sectorRepo.Eliminar(hfID);


            return RedirectToAction("Index");

        }

    }
}
