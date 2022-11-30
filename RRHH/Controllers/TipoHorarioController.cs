using Microsoft.AspNetCore.Mvc;
using Dapper;
using RRHH.Models;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc.Rendering;
using RRHH.Repository;
using ClosedXML.Excel;
using SelectPdf;

namespace RRHH.Controllers
{
    public class TipoHorarioController : Controller
    {

        static readonly string strConnectionString = Tools.GetConnectionString();


        public IActionResult Index( int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id, int tipo_hora_id, int legajo_id, string filtro, int nro_item)
        {


            string? usuario_id = HttpContext.Session.GetString("USUARIO_ID");

            if (usuario_id == null) return RedirectToAction("Login", "Usuario");

            int? perfil_id = HttpContext.Session.GetInt32("PERFIL_ID");



            ViewData["ITEM_ACTUAL"] = nro_item;


            if (apellido != null) HttpContext.Session.SetString("APELLIDO_HORARIO_ACTUAL", apellido);


            if (HttpContext.Session.GetString("APELLIDO_HORARIO_ACTUAL") != null) apellido = HttpContext.Session.GetString("APELLIDO_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPLEADO_HORARIO_ACTUAL") != null) legajo_id = (int)HttpContext.Session.GetInt32("EMPLEADO_HORARIO_ACTUAL");
            
            if (HttpContext.Session.GetString("FILTRO_HORARIO_ACTUAL") != null) filtro = HttpContext.Session.GetString("FILTRO_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("EMPRESA_HORARIO_ACTUAL") != null) empresa_id = (int)HttpContext.Session.GetInt32("EMPRESA_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("UBICACION_HORARIO_ACTUAL") != null) ubicacion_id = (int)HttpContext.Session.GetInt32("UBICACION_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("SECTOR_HORARIO_ACTUAL") != null) sector_id = (int)HttpContext.Session.GetInt32("SECTOR_HORARIO_ACTUAL");

            if (HttpContext.Session.GetInt32("TIPO_HORA_ACTUAL") != null) tipo_hora_id = (int)HttpContext.Session.GetInt32("TIPO_HORA_ACTUAL");



            if (perfil_id > 0)
            {
                ITipoHorarioRepo tipoHorarioRepo;

                tipoHorarioRepo = new TipoHorarioRepo();


                ViewData["EmpresaActual"] = empresa_id;

                ViewData["UbicacionActual"] = ubicacion_id;
                ViewData["SectorActual"] = sector_id;
                ViewData["LocalActual"] = local_id;
                ViewData["ApellidoActual"] = apellido;

                ViewData["EmpleadoActual"] = legajo_id;

                ViewData["FiltroJustificacionActual"] = filtro;
                
                /*
               Legajo legajo = new Legajo();
               ILegajoRepo legajoRepo;
               legajoRepo = new LegajoRepo();

               legajo = legajoRepo.Obtener(legajo_id);


               if (legajo != null)
               {
                   ViewData["UbicacionActual"] = legajo.ubicacion_id;
                   ViewData["SectorActual"] = legajo.sector_id;
                   ViewData["LocalActual"] = legajo.local_id;
                   nro_legajo = legajo.nro_legajo.Value;
                   empresa_id = legajo.empresa_id.Value;

                   ViewData["EmpresaActual"] = legajo.empresa_id;
                   ViewData["LegajoActual"] = legajo.nro_legajo;
                   ViewData["Legajo"] = legajo;
               }

               if (nro_legajo > 0)
               {
                   if (empresa_id <= 0)
                   {
                       ViewBag.Message = "Debe seleccionar la empresa";
                       return View();
                   }
                   else
                   {

                       if (legajo == null)
                       {
                           ViewBag.Message = "No existe el legajo para esa empresa";
                           return View();
                       }
                   }


               }
               */




                IEnumerable<TipoHorario> horarios;

                horarios = tipoHorarioRepo.ObtenerTodos((ubicacion_id == 0) ? -1 : ubicacion_id, (sector_id == 0) ? -1 : sector_id, (legajo_id == 0) ? -1 : legajo_id, (tipo_hora_id == 0) ? -1 : tipo_hora_id);


              
                return View(horarios);

            }



            return View();


        }


        [HttpPost]
        public IActionResult Buscar( int empresa_id, int nro_legajo, string apellido, int ubicacion_id, int sector_id, int local_id, int tipo_hora_id, int legajo_id, string filtro)
        {

            HttpContext.Session.SetInt32("EMPRESA_HORARIO_ACTUAL", empresa_id);
            HttpContext.Session.SetInt32("LEGAJO_HORARIO_ACTUAL", nro_legajo);
            HttpContext.Session.SetString("APELLIDO_HORARIO_ACTUAL", (apellido == null) ? "" : apellido);

            HttpContext.Session.SetInt32("EMPLEADO_HORARIO_ACTUAL", legajo_id);
            HttpContext.Session.SetString("FILTRO_HORARIO_ACTUAL", (filtro == null) ? "" : filtro);

            HttpContext.Session.SetInt32("UBICACION_HORARIO_ACTUAL", ubicacion_id);
            HttpContext.Session.SetInt32("SECTOR_HORARIO_ACTUAL", sector_id);
            HttpContext.Session.SetInt32("TIPO_HORA_ACTUAL", tipo_hora_id);


            return RedirectToAction("Index", "TipoHorario", new { desde = "busqueda" });

        }



    }
}
