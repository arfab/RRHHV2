using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;

namespace RRHH.Controllers
{
    public class CategoriaController : Controller
    {
        public IActionResult Index()
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            if (perfil_id == 1)
            {
                ICategoriaRepo categoriaRepo;

                categoriaRepo = new CategoriaRepo();

                return View(categoriaRepo.ObtenerTodos());
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
                ICategoriaRepo categoriaRepo;

                categoriaRepo = new CategoriaRepo();

                Categoria cat = new Categoria();

                cat = categoriaRepo.Obtener(id.Value);

                ViewData["ID"] = id.Value;

                return View(cat);
            }
            else
            {
                ViewData["ID"] = 0;
                return View();
            }


        }



        [HttpPost]
        public IActionResult Edit(int? id, Categoria categoria)
        {

            string sret;
            ICategoriaRepo categoriaRepo;

            if (ModelState.IsValid)
            {

                categoriaRepo = new CategoriaRepo();

                if (id != null)
                    sret = categoriaRepo.Modificar(categoria);
                else
                    sret = categoriaRepo.Insertar(categoria);

                if (sret == "")
                {

                    return RedirectToAction("Index", "Categoria");
                }
                else
                {
                    ViewBag.Message = sret;
                }

            }

            return View(categoria);
        }
    }
}
