using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;


namespace RRHH.Controllers
{
    public class FichadaOriginalController : Controller
    {
        public IActionResult Index(int legajo_id, string fecha, int sin_excluidos)
        {
            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");

            ViewData["SIN_EXCLUIDOS"] = sin_excluidos;

            Legajo legajo = new Legajo();
            ILegajoRepo legajoRepo;
            legajoRepo = new LegajoRepo();

            legajo = legajoRepo.Obtener(legajo_id);


            if (legajo != null)
            {
                ViewData["Ubicacion"] = legajo.ubicacion;
                ViewData["Sector"] = legajo.sector;
                ViewData["Local"] = legajo.local;
                ViewData["Empresa"] = legajo.empresa;
                ViewData["NroLegajo"] = legajo.nro_legajo;
                ViewData["Apellido"] = legajo.apellido;
                ViewData["Nombre"] = legajo.nombre;
            }


            if (perfil_id == 1 || perfil_id == 2)
            {
                IFichadaRepo fichadaRepo;

                fichadaRepo = new FichadaRepo();

                return View(fichadaRepo.ObtenerFichadasOriginales(legajo_id, fecha, sin_excluidos));
            }

           

            return RedirectToAction("Login", "Usuario");


        }

    }
}
